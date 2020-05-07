package models

import (
	"github.com/astaxie/beego/orm"
	"github.com/garyburd/redigo/redis"
	"github.com/jackwong7/beego_blog/service"
	"github.com/json-iterator/go"
	"time"
)

type Category struct {
	Id      int
	Name    string
	Created time.Time
	Updated time.Time
}

func (m *Category) TableName() string {
	return TableName("category")
}

func GetCategories() []*Category {
	var json = jsoniter.ConfigCompatibleWithStandardLibrary
	name := "getCategories"
	categories := []*Category{}
	conn := service.Pool.Get()
	defer conn.Close()
	if jsonData, err := redis.Bytes(conn.Do("get", name)); err == nil {
		err := json.Unmarshal(jsonData, &categories)
		if err == nil {
			return categories
		}
	}
	o := orm.NewOrm()
	o.QueryTable(new(Category).TableName()).All(&categories)

	cacheCategories, err := json.Marshal(categories)
	if err == nil {
		conn.Do("set", name, cacheCategories, "ex", service.Exp)
	}
	return categories
}
