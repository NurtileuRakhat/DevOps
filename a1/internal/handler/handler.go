package handler

import (
	"database/sql"
	"net/http"
	"strings"
	"time"

	"simple-auth/internal/auth"

	"github.com/gin-gonic/gin"
	"github.com/lib/pq"
)

type Handler struct {
	db       *sql.DB
	lifetime time.Duration
}

func NewHandler(db *sql.DB, lifetime time.Duration) *Handler {
	return &Handler{db: db, lifetime: lifetime}
}

func (h *Handler) TokenHandler(c *gin.Context) {
	clientID := c.PostForm("client_id")
	clientSecret := c.PostForm("client_secret")
	scope := c.PostForm("scope")

	// Debug logging
	c.Writer.Header().Set("X-Debug-ClientID", clientID)

	var secret string
	var scopes []string

	err := h.db.QueryRow(
		`SELECT client_secret, scope FROM public."user" WHERE client_id = $1`,
		clientID,
	).Scan(&secret, pq.Array(&scopes))
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "client not found", "debug": clientID})
		return
	}

	if secret != clientSecret {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "wrong secret"})
		return
	}

	token, _ := auth.GenerateToken(24)
	expires := time.Now().Add(h.lifetime)

	_, err = h.db.Exec(
		`INSERT INTO token (client_id, access_scope, access_token, expiration_time)
		 VALUES ($1, $2, $3, $4)`,
		clientID, pq.Array([]string{scope}), token, expires,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "db error"})
		return
	}

	c.JSON(200, gin.H{
		"access_token":   token,
		"expires_in":     int(h.lifetime.Seconds()),
		"refresh_token":  "",
		"scope":          scope,
		"security_level": "normal",
		"token_type":     "Bearer",
	})
}

func (h *Handler) CheckHandler(c *gin.Context) {
	authHeader := c.GetHeader("Authorization")
	parts := strings.Split(authHeader, " ")
	if len(parts) != 2 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "bad header"})
		return
	}

	token := parts[1]

	var clientID string
	var scopes []string
	var expires time.Time

	err := h.db.QueryRow(
		`SELECT client_id, access_scope, expiration_time FROM token WHERE access_token=$1`,
		token,
	).Scan(&clientID, pq.Array(&scopes), &expires)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid token"})
		return
	}

	if time.Now().After(expires) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "expired"})
		return
	}

	c.JSON(200, gin.H{
		"ClientID": clientID,
		"Scope":    scopes,
	})
}
