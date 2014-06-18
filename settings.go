package main

import (
	"fmt"
	"os"
	"github.com/Unknwon/goconfig"
)

func main() {
	config,_ := goconfig.LoadConfigFile("/home/gogs/gogs/custom/conf/app.ini")

	app_name := os.Getenv("APP_NAME")
	domain := os.Getenv("DOMAIN")
	root_url := os.Getenv("ROOT_URL")
	mem_type := os.Getenv("MEM_TYPE")
	db_type := os.Getenv("DB_TYPE")

	var mem_addr string
	var mem_port string
	if mem_type == "redis" {
		mem_addr = os.Getenv("REDIS_PORT_6379_TCP_ADDR")
		mem_port = os.Getenv("REDIS_PORT_6379_TCP_PORT")
	} else if mem_type == "memcache" {
		mem_addr = os.Getenv("MEMCACHE_PORT_11211_TCP_ADDR")
		mem_port = os.Getenv("MEMCACHE_PORT_11211_TCP_PORT")
	} else if mem_type == "memory" {

	} else {
		// Invalid Memory Type
	}

	var db_addr string
	var db_port string
	if db_type == "mysql" {
		db_addr = os.Getenv("MYSQL_PORT_3306_TCP_ADDR")
		db_port = os.Getenv("MYSQL_PORT_3306_TCP_PORT")
	} else if db_type == "postgresql" {
		db_addr = os.Getenv("POSTGRESQL_PORT_5432_TCP_ADDR")
		db_port = os.Getenv("POSTGRESQL_PORT_5432_TCP_PORT")
	} else if db_type == "sqlite" {
		config.SetValue("database", "PATH", "data/gogs.db")
	} else {
		// Invalid DB Type
	}

	config.SetValue(goconfig.DEFAULT_SECTION, "APP_NAME", app_name)

	// Server
	config.SetValue("server", "DOMAIN", domain)
	config.SetValue("server", "ROOT_URL", root_url)

    // Database
	config.SetValue("database", "DB_TYPE", db_type)
	if db_addr!="" && db_port!="" {
		config.SetValue("database", "HOST", fmt.Sprintf("%s:%s", db_addr, db_port))
	}
	if db_type == "mysql" || db_type == "postgresql" {
		config.SetValue("database", "NAME", os.Getenv("DB_NAME"))
		config.SetValue("database", "USER", os.Getenv("DB_USER"))
		config.SetValue("database", "PASSWORD", os.Getenv("DB_PASSWORD"))
	}

	// Cache
	config.SetValue("cache", "ADAPTER", mem_type)
	if mem_addr!="" && mem_port!="" {
		config.SetValue("cache", "HOST", fmt.Sprintf("%s:%s", mem_addr, mem_port))
	}

	// Session
	if mem_type == "redis" {
		config.SetValue("session", "PROVIDER", "redis")
		config.SetValue("session", "PROVIDER_CONFIG", fmt.Sprintf("%s:%s,100", mem_addr, mem_port))
	} else {
		config.SetValue("session", "PROVIDER", "memory")
	}

	goconfig.SaveConfigFile(config, "/home/gogs/gogs/custom/conf/app.ini")
}