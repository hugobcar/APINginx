#!/bin/sh
############################################################################
# Efetua um CheckSum dos mapeamentos em todos os servidores para verificar
# se algum arquivo foi modificado ou criado manualmente.
#
#                                   Hugo Branquinho de Carvalho - 27/01/2017
############################################################################

rm -f /tmp/msg_slack_md5

######### Veriaveis
# Slack
webhook_slack='https://hooks.slack.com/services/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'  #api
canal_slack="#api"

# Dados MySQL
userDB="apinginx"
passDB="APi99875dd"
dbDB="apinginx"
portDB=3336
#########

# Verifica se script esta sendo executado com o usuario "hugo"
if [ `whoami` != 'hugo' ]; then
	echo "Script deve ser executado com o usuario (hugo)"
	exit 1
fi

check_aprovado=`mysql -u ${userDB} --password=${passDB} -P ${portDB} -e "use ${dbDB}; SELECT count(1) AS APROVADO FROM mapeamentos WHERE mapeamentos.aprovado<>1" | grep -v APROVADO`

if [ "${check_aprovado}" -ge 1 ]; then
	echo "Enviando mensagem no slack de aprovacoes a se fazer"

	echo "Favor aprovar mapeamentos abaixo:" > /tmp/msg_aprovados
	echo "---------------------------------" >> /tmp/msg_aprovados
	echo >> /tmp/msg_aprovados

	mysql -u ${userDB} --password=${passDB} -P ${portDB} -e "use ${dbDB}; SELECT CONCAT('Solicitante: ',usuarios.nome_usuario,'  -  Mapeamento: (',mapeamentos.id_mapeamento,') /',mapeamentos.location_prefix,'/',mapeamentos.location,' (', mapeamentos.env,')') AS APROVADO FROM mapeamentos INNER JOIN usuarios ON (mapeamentos.id_usuario=usuarios.id_usuario) WHERE mapeamentos.aprovado<>1" | grep -v APROVADO >> /tmp/msg_aprovados

	json="{\"channel\": \"${canal_slack}\", \"text\": \"$(cat /tmp/msg_aprovados)\"}"
	curl -s -d "payload=$json" ${webhook_slack}
else
	echo "Nenhuma aprovacao a se fazer"
fi

