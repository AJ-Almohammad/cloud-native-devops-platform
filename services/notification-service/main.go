package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

type Notification struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	Title     string    `json:"title"`
	Message   string    `json:"message"`
	Type      string    `json:"type"`   // email, sms, push
	Status    string    `json:"status"` // pending, sent, failed
	CreatedAt time.Time `json:"created_at"`
}

var notifications []Notification

func main() {
	router := gin.Default()

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":    "healthy",
			"service":   "notification-service",
			"timestamp": time.Now().UTC().Format(time.RFC3339),
		})
	})

	// Get all notifications
	router.GET("/notifications", func(c *gin.Context) {
		c.JSON(http.StatusOK, notifications)
	})

	// Create notification
	router.POST("/notifications", func(c *gin.Context) {
		var notification Notification
		if err := c.BindJSON(&notification); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		notification.ID = fmt.Sprintf("notif_%d", time.Now().UnixNano())
		notification.CreatedAt = time.Now().UTC()
		notification.Status = "pending"

		notifications = append(notifications, notification)

		// Simulate sending notification
		go func(n Notification) {
			time.Sleep(100 * time.Millisecond)
			log.Printf("Notification sent: %s to user %s", n.Title, n.UserID)
		}(notification)

		c.JSON(http.StatusCreated, notification)
	})

	// Get notification by ID
	router.GET("/notifications/:id", func(c *gin.Context) {
		id := c.Param("id")
		for _, notification := range notifications {
			if notification.ID == id {
				c.JSON(http.StatusOK, notification)
				return
			}
		}
		c.JSON(http.StatusNotFound, gin.H{"error": "Notification not found"})
	})

	// Get user notifications
	router.GET("/users/:userId/notifications", func(c *gin.Context) {
		userID := c.Param("userId")
		var userNotifications []Notification
		for _, notification := range notifications {
			if notification.UserID == userID {
				userNotifications = append(userNotifications, notification)
			}
		}
		c.JSON(http.StatusOK, userNotifications)
	})

	log.Println("Notification service starting on :8080")
	router.Run(":8080")
}
