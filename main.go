package main

import (
  "net/http"
  "github.com/gin-gonic/gin"
)

var unitProfile = Profile{ 
  WS: 2, 
  BS: 2,
}

type Profile struct {
  WS int `json:"ws"`
  BS int `json:"bs"`
}

func getProfile(c *gin.Context) {
  c.JSON( http.StatusOK, unitProfile )
  // c.JSON( http.StatusOK, gin.H{ "ws": unitProfile.ws, "bs": unitProfile.bs } )
}

func getDummy(c *gin.Context) {
  c.String(http.StatusOK, "Hello")
}

func getValue(c *gin.Context) {
  name := c.Param("name")
  c.JSON( http.StatusOK, name )
}

func main() {
  router := gin.Default()

  router.SetTrustedProxies( nil )

  router.GET( "/", getDummy )
  router.GET( "/value/:name", getValue )
  router.GET( "/profile", getProfile )

  router.Run()
}
