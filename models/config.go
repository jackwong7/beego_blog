package models

import (
	"encoding/json"
	"github.com/astaxie/beego/orm"
	"github.com/garyburd/redigo/redis"
	"github.com/jackwong7/beego_blog/service"
)

type Config struct {
	Id    int
	Name  string
	Value string
}

func (m *Config) TableName() string {
	return TableName("config")
}

func GetConfigs() []*Config {
	name := "getConfigs"
	configs := []*Config{}
	conn := service.Pool.Get()
	//defer conn.Close()
	if jsonData, err := redis.Bytes(conn.Do("get", name)); err == nil {
		err := json.Unmarshal(jsonData, &configs)
		if err == nil {
			return configs
		}
	}
	o := orm.NewOrm()
	o.QueryTable(new(Config).TableName()).All(&configs)

	cacheConfigs, err := json.Marshal(configs)
	if err == nil {
		conn.Do("set", name, cacheConfigs, "ex", service.Exp)
	}
	return configs
}
