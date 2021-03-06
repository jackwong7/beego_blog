package models

import (
	"github.com/astaxie/beego/orm"
	"github.com/garyburd/redigo/redis"
	"beego_blog/service"
	jsoniter "github.com/json-iterator/go"
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
	var json = jsoniter.ConfigCompatibleWithStandardLibrary
	name := "getConfigs"
	configs := []*Config{}
	conn := service.Pool.Get()
	defer conn.Close()
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
func GetConfigsJson() *[]byte {
	var json = jsoniter.ConfigCompatibleWithStandardLibrary
	name := "getConfigs"
	configs := []*Config{}
	conn := service.Pool.Get()
	defer conn.Close()
	if jsonData, err := redis.Bytes(conn.Do("get", name)); err == nil {
		return &jsonData
	}
	o := orm.NewOrm()
	o.QueryTable(new(Config).TableName()).All(&configs)

	cacheConfigs, err := json.Marshal(configs)
	if err == nil {
		conn.Do("set", name, cacheConfigs, "ex", service.Exp)
	}
	return &cacheConfigs
}
