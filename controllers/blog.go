package controllers

import (
	"github.com/jackwong7/beego_blog/models"
	"github.com/jackwong7/beego_blog/util"
	"time"
)

type BlogController struct {
	baseController
}

func (c *BlogController) list() {

	getCategories := models.GetCategories()
	c.Data["cates"] = getCategories

	queryField := models.QueryField{}
	queryField.ActionName = c.actionName
	if queryField.Page, _ = c.GetInt("page"); queryField.Page < 1 {
		queryField.Page = 1
	}
	queryField.CateId, _ = c.GetInt("cate_id")
	queryField.Keyword = c.Input().Get("keyword")

	//var postLists models.Postlists
	postLists := models.GetPosts(&queryField, c.o)

	c.Data["list"] = *postLists.List
	c.Data["count"] = *postLists.Count
	c.Data["pagebar"] = util.NewPager(*postLists.Page, int(*postLists.Count), *postLists.Pagesize, "/"+c.actionName, true).ToString()
	c.Data["hosts"] = *postLists.Hosts
	c.Data["keyword"] = *postLists.Keyword
}

/**
首页
*/
func (c *BlogController) Home() {
	c.list()
	c.Data["actionTitle"] = "网站首页"
	c.TplName = c.controllerName + "/home.html"
}

/**
列表页面
*/
func (c *BlogController) Article() {
	c.list()
	c.Data["actionTitle"] = "文章专栏"
	c.TplName = c.controllerName + "/article.html"
}

/**
详情
*/
func (c *BlogController) Detail() {
	c.Data["actionTitle"] = "文章详情"
	if id, _ := c.GetInt("id"); id != 0 {
		post := models.Post{Id: id}
		err := c.o.Read(&post)
		if err != nil {
			c.Abort("404")
		}
		c.Data["post"] = post
		comments := []*models.Comment{}
		query := c.o.QueryTable(new(models.Comment).TableName()).Filter("post_id", id)
		query.All(&comments)
		c.Data["comments"] = comments

		categorys := []*models.Category{}
		c.o.QueryTable(new(models.Category).TableName()).All(&categorys)
		c.Data["cates"] = categorys
		var hosts []*models.Post
		querys := c.o.QueryTable(new(models.Post).TableName()).Filter("types", 1)
		querys.OrderBy("-views").Limit(10, 0).All(&hosts)
		c.Data["hosts"] = hosts
		go func() {
			c.o.Raw("UPDATE tb_post SET views = views + 1 WHERE id = ?", id).Exec()
		}()
		c.Data["actionTitle"] = post.Title
	} else {
		c.Abort("404")
	}
	c.TplName = c.controllerName + "/detail.html"
}

/**
关于我们
*/
func (c *BlogController) About() {
	post := models.Post{Id: 1}
	c.o.Read(&post)
	c.Data["post"] = post
	c.Data["actionTitle"] = "关于我们"
	c.TplName = c.controllerName + "/about.html"
}

//时间线
func (c *BlogController) Timeline() {
	c.Data["actionTitle"] = "点点滴滴"
	c.TplName = c.controllerName + "/timeline.html"
}

//资源
func (c *BlogController) Resource() {
	c.list()
	c.Data["actionTitle"] = "资源分享"
	c.TplName = c.controllerName + "/resource.html"
}

//插入评价
func (c *BlogController) Comment() {
	Comment := models.Comment{}
	Comment.Username = c.GetString("username")
	Comment.Content = c.GetString("content")
	Comment.Ip = c.getClientIp()
	Comment.PostId, _ = c.GetInt("post_id")
	Comment.Created = time.Now()
	if _, err := c.o.Insert(&Comment); err != nil {
		c.History("发布评价失败"+err.Error(), "")
	} else {
		c.History("发布评价成功", "")
	}
}

//测试配置接口
func (c *BlogController) GetConfigJson() {
	c.Ctx.Output.Body(*models.GetConfigsJson())
}
