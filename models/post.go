package models

import (
	"beego_blog/service"
	"github.com/astaxie/beego/orm"
	"github.com/garyburd/redigo/redis"
	jsoniter "github.com/json-iterator/go"
	"strconv"
	"time"
)

type Post struct {
	Id         int
	UserId     int
	Title      string
	Url        string
	Content    string
	Tags       string
	Views      int
	IsTop      int8
	Created    time.Time
	Updated    time.Time
	CategoryId int
	Status     int8
	Types      int8
	Info       string
	Image      string
}

type PostView struct {
	Id         int
	Title      string
	Tags       string
	Views      int
	CategoryId int
	Info       string
	Image      string
	Updated    time.Time
}

type PostHotView struct {
	Id    int
	Title string
}

func (m *Post) TableName() string {
	return TableName("post")
}

type QueryField struct {
	ActionName string
	Page       int
	CateId     int
	Keyword    string
}

type Postlists struct {
	Keyword  *string
	List     *[]orm.Params
	Hosts    *[]orm.Params
	Page     *int
	Pagesize *int
	Count    *int64
}

func GetPosts(queryField *QueryField, o orm.Ormer) *Postlists {
	var json = jsoniter.ConfigCompatibleWithStandardLibrary
	var (
		offset   int
		hosts    []orm.Params
		pagesize int = 6
		count    int64
		list     []orm.Params
	)
	name := queryField.ActionName + "c" + strconv.Itoa(queryField.CateId) + "p" + strconv.Itoa(queryField.Page) + "k" + queryField.Keyword
	postlists := Postlists{}
	conn := service.Pool.Get()
	defer conn.Close()
	if jsonData, err := redis.Bytes(conn.Do("get", name)); err == nil {
		err := json.Unmarshal(jsonData, &postlists)
		if err == nil {
			return &postlists
		}
	}

	query := o.QueryTable(new(Post).TableName())
	if queryField.ActionName == "resource" {
		query = query.Filter("types", 0)
	} else {
		query = query.Filter("types", 1)
	}

	offset = (queryField.Page - 1) * pagesize

	if queryField.CateId != 0 {
		query = query.Filter("category_id", queryField.CateId)
	}
	if queryField.Keyword != "" {
		query = query.Filter("title__icontains", queryField.Keyword)
	}
	query.OrderBy("-views").Limit(10, 0).Values(&hosts, "id", "title")
	if queryField.ActionName == "home" {
		query = query.Filter("is_top", 1)
	}
	count, _ = query.Count()
	query.OrderBy("-created").Limit(pagesize, offset).Values(&list, "id", "title", "tags", "views", "info", "updated")
	for _, v := range list {
		v["Updated"] = v["Updated"].(time.Time).Format("2006-01-02 15:04:05")
	}
	if len(list) == 0 {
		list = []orm.Params{}
	}
	if len(hosts) == 0 {
		hosts = []orm.Params{}
	}
	postlists = Postlists{
		Keyword:  &queryField.Keyword,
		List:     &list,
		Hosts:    &hosts,
		Page:     &queryField.Page,
		Pagesize: &pagesize,
		Count:    &count,
	}

	cachePostlists, err := json.Marshal(postlists)
	if err == nil {
		conn.Do("set", name, cachePostlists, "ex", service.Exp)
	}
	return &postlists
}
