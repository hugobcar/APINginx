.PHONY: clean # flag dizendo ao Make que nenhum arquivo vai ser gerado quando chamar "make clean"
clean:
	rm -rf APINginx
all:
	go build -ldflags "-X main.Version=`git describe --tags`" -o APINginx main.go
