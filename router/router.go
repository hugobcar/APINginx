package router

import (
	"net/http"

	"github.com/gorilla/mux"
)

type routeStruct struct {
	Name        string
	Method      string
	Pattern     string
	HandlerFunc http.HandlerFunc
}

type routesStruct []routeStruct

var env string
var routes routesStruct

// NewRouter - Used for create a routes
func NewRouter(Env string) *mux.Router {

	env = Env

	switch env {
	case "app":
		routes = routesStruct{
			routeStruct{
				"CreateMapsFiles",
				"POST",
				"/CreateMapsFiles",
				CreateMapsFiles,
			},
			routeStruct{
				"DeleteMapsFiles",
				"POST",
				"/DeleteMapsFiles",
				DeleteMapsFiles,
			},
			routeStruct{
				"TestProxy",
				"POST",
				"/TestProxy",
				TestProxy,
			},
		}
	case "dmz":
		routes = routesStruct{
			routeStruct{
				"CreateMapsFiles",
				"POST",
				"/CreateMapsFiles",
				CreateMapsFilesDMZ,
			},
			routeStruct{
				"DeleteMapsFiles",
				"POST",
				"/DeleteMapsFiles",
				DeleteMapsFilesDMZ,
			},
		}
	case "server":
		routes = routesStruct{
			routeStruct{
				"CreateMaps",
				"POST",
				"/CreateMaps",
				CreateMaps,
			},
			routeStruct{
				"TestProxyServer",
				"POST",
				"/TestProxy",
				TestProxyServer,
			},
			routeStruct{
				"AplicarMapsAPP",
				"POST",
				"/AplicarMapsAPP",
				AplicarMapsAPP,
			},
		}
	}

	router := mux.NewRouter().StrictSlash(true)
	for _, route := range routes {
		router.
			Methods(route.Method).
			Path(route.Pattern).
			Name(route.Name).
			Handler(route.HandlerFunc)
	}

	return router
}
