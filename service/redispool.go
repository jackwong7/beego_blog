package service

import (
	"github.com/garyburd/redigo/redis"
)

var Pool *redis.Pool
var Exp = 60 * 5

func init() {
	Pool = &redis.Pool{
		MaxIdle:     100,
		MaxActive:   0,
		IdleTimeout: 200,
		Dial: func() (redis.Conn, error) {
			return redis.Dial("tcp", "localhost:6379")
		},
	}
}
