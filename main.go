package main

import (
	"encoding/gob"
	"github.com/astaxie/beego"
	_ "github.com/astaxie/beego/session/redis"
	_ "github.com/go-sql-driver/mysql"
	"beego_blog/models"
	_ "beego_blog/routers"
)

func init() {
	models.Init()
	beego.BConfig.WebConfig.Session.SessionOn = true
	beego.BConfig.WebConfig.Session.SessionProvider = "redis"
	beego.BConfig.WebConfig.Session.SessionProviderConfig = "127.0.0.1:6379"
	gob.Register(models.User{})
}

func main() {
	beego.Run()
}
