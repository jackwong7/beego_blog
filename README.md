# beego_Blog

基于Go语言和beego框架 前端使用layui 布局 开发的个人博客系统

## 编译安装说明：


1 . 下载安装

    $ go get beego_blog

2 . 加入数据库

   mysql 新建blog数据库把根目录 beego_blog.sql 导入

3 . 修改 app.conf 配置

    #MYSQL地址
    dbhost = localhost

    #MYSQL端口
    dbport = 3306

    #MYSQL用户名
    dbuser = root

    #MYSQL密码
    dbpassword =

    #MYSQL数据库名称
    dbname = beego_blog

    #MYSQL表前缀
    dbprefix = tb_

 6 . 运行

    cd 到 beego_blog 目录 执行
    $ bee run

 7 . 浏览器演示

http://localhost:8080 (前台)

http://localhost:8080/admin/login (后台)

