package main

import (
	"APINginx/router"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"

	DB "APINginx/models"
)

var portListen string

// typeApp - server/app/dmz
var typeApp string

// Version aplication
var Version = "no version"

var userDB string
var passDB string
var database string
var hostDB string
var portDB string

func init() {
	flag.StringVar(&portListen, "port", "6885", "Port application to listenner")
	flag.StringVar(&typeApp, "typeApp", "", "(server/app/dmz)")
	flag.StringVar(&userDB, "userDB", "apinginx", "User MySQL")
	flag.StringVar(&passDB, "passDB", "", "Password MySQL. Use default case your not specific.")
	flag.StringVar(&database, "database", "apinginx", "Database MySQL")
	flag.StringVar(&hostDB, "hostDB", "localhost", "Hostname MySQL")
	flag.StringVar(&portDB, "portDB", "3306", "Port MySQL")

	flag.Parse()

	DB.UserDB = userDB

	if passDB == "" {
		DB.PassDB = "APi99875dd"
	} else {
		DB.PassDB = passDB
	}

	DB.DatabaseDB = database
	DB.HostDB = hostDB
	DB.PortDB = portDB
}

func main() {
	os.Setenv("http_proxy", "")
	os.Setenv("https_proxy", "")

	if typeApp == "" || (typeApp != "server" && typeApp != "app" && typeApp != "dmz") {
		fmt.Println("<<< -- Version: " + Version + " -- >>>")
		log.Fatal("Please, use the argument (-typeApp). More details use ./APINginx -h")
	}

	router := router.NewRouter(typeApp)

	log.Println("Listenning to port: " + portListen + " -- Version: " + Version)
	log.Fatal(http.ListenAndServe(":"+portListen, router))
}
