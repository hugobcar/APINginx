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
#########

# Verifica se script esta sendo executado com o usuario "hugo"
if [ `whoami` != 'hugo' ]; then
	echo "Script deve ser executado com o usuario (hugo)"
	exit 1
fi

# Lista servidores Ativos
alert_slack='nao'  # NAO ALTERAR

for ativos in `mysql -u ${userDB} --password=${passDB} -e "use ${dbDB}; SELECT CONCAT(nome_servidor,';',IP,';',env,';',type_server) FROM servidores WHERE check_md5=1;" | grep -v CONCAT`; do
	SERVIDOR=`echo $ativos | cut -f 1 -d ';'`
	IP=`echo $ativos | cut -f 2 -d ';'`
	ENV=`echo $ativos | cut -f 3 -d ';'`
	TYPE_SERVER=`echo $ativos | cut -f 4 -d ';'`

	# Verifica se IP eh valido
	echo ${IP} | egrep '[0-9]' 1>/dev/null 2>/dev/null
	resp=$?

	# Se for localizado um IP valido, entao faz a verificacao
	if [ "${resp}" -eq 0 ]; then
		echo "Conectando no servidor (${SERVIDOR}/${IP}) para checar MD5..."

		ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -t ${IP} "md5sum /etc/nginx/conf.d/maps/* | sed -e 's/  /;/g'" > /tmp/${ENV}_${TYPE_SERVER}.txt
		
		for md5 in `cat /tmp/${ENV}_${TYPE_SERVER}.txt | sed -e 's/\r//g'`; do
			MD5=`echo ${md5} | cut -f 1 -d ';'`
			ARQ=`echo ${md5} | cut -f 2 -d ';'`

			# Verifica se tem md5sum
			echo ${MD5} | egrep '[a-Z]|[0-9]' 1>/dev/null 2>/dev/null
			resp1=$?

			# Se for gerado algum MD5
			if [ "${resp1}" -eq 0 ]; then
				if [ ${TYPE_SERVER} = 'DMZ' ]; then
					check_md5=`mysql -u ${userDB} --password=${passDB} -e "use ${dbDB}; SELECT count(1) AS MD5_CHECK FROM mapeamentos WHERE ENV='"${ENV}"' AND md5_dmz='"${MD5}"';" | grep -v 'MD5_CHECK'`
				else
					check_md5=`mysql -u ${userDB} --password=${passDB} -e "use ${dbDB}; SELECT count(1) AS MD5_CHECK FROM mapeamentos WHERE ENV='"${ENV}"' AND md5_app='"${MD5}"';" | grep -v 'MD5_CHECK'`
				fi

				if [ "${check_md5}" -eq 1 ]; then
					echo "MD5 OK - ${ARQ}" 
				else
					if [ ${alert_slack} = 'nao' ]; then
						echo "Arquivos que foram alterados ou que foram gerados manualmente" | tee -a /tmp/msg_slack_md5
						echo "-------------------------------------------------------------" | tee -a /tmp/msg_slack_md5
					fi
	
					echo "-- Arquivo: (${ARQ}) - Servidor: (${SERVIDOR}/${IP}) - Env: (${ENV}) - Tipo: (${TYPE_SERVER}) - MD5: (${MD5})" | tee -a /tmp/msg_slack_md5
					
					alert_slack='sim'
				fi
			else
				echo "Nenhum arquivo foi gerado para verificacao"
				echo	
			fi
		done			
	fi
done

# Alertar Slack
if [ "${alert_slack}" = 'sim' ]; then
	json="{\"channel\": \"${canal_slack}\", \"text\": \"$(cat /tmp/msg_slack_md5)\"}"
	curl -s -d "payload=$json" ${webhook_slack}
fi


