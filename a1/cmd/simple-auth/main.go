package main

import (
	"log"
	"os"
	"time"

	"simple-auth/internal/db"
	"simple-auth/internal/handler"

	"github.com/gin-gonic/gin"
)

func main() {
	cfg := db.Config{
		Host:     getenv("DB_HOST", "127.0.0.1"),
		Port:     getenv("DB_PORT", "5432"),
		User:     getenv("DB_USER", "simpleauth"),
		Password: getenv("DB_PASS", "simpleauthpass"),
		DBName:   getenv("DB_NAME", "simpleauth"),
	}

	database, err := db.New(cfg)
	if err != nil {
		log.Fatal(err)
	}
	defer database.Close()

	r := gin.Default()
	h := handler.NewHandler(database, 2*time.Hour)

	r.POST("/token", h.TokenHandler)
	r.GET("/check", h.CheckHandler)

	port := getenv("PORT", "8080")
	r.Run(":" + port)
}

func getenv(k, def string) string {
	if v := os.Getenv(k); v != "" {
		return v
	}
	return def
}
