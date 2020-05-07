package service

import (
	"github.com/garyburd/redigo/redis"
	"time"
)

var Pool *redis.Pool
var Exp = 60 * 5

func init() {
	Pool = &redis.Pool{
		MaxIdle:     256,
		MaxActive:   0,
		IdleTimeout: time.Duration(120),
		Dial: func() (redis.Conn, error) {
			return redis.Dial("tcp", "localhost:6379")
		},
	}
}
