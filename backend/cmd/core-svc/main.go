package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/civiq/sudarshan-backend/internal/db"
	"github.com/civiq/sudarshan-backend/internal/handlers"
	"github.com/civiq/sudarshan-backend/internal/middleware"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()

	if err := db.Init(); err != nil {
		fmt.Printf("Failed to init DB: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	r := chi.NewRouter()
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PATCH", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-Requested-With"},
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Health check
	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`{"status":"ok"}`))
	})

	// Public routes
	r.Group(func(r chi.Router) {
		r.Post("/onboard", OnboardHandler)
	})

	// Protected routes
	r.Group(func(r chi.Router) {
		r.Use(middleware.SupabaseAuth)

		r.Post("/issues", handlers.CreateIssue)
		r.Get("/issues/nearby", handlers.GetNearbyIssues)
		r.Get("/issues/{id}", handlers.GetIssueDetail)
		r.Patch("/issues/{id}/claim", handlers.ClaimIssue)
		r.Patch("/issues/{id}/resolve", handlers.ResolveIssue)
		r.Get("/issues/my-reports", handlers.GetMyReports)
		r.Get("/issues/volunteer-history", handlers.GetVolunteerHistory)

		r.Get("/profile/me", handlers.GetMyProfile)
		r.Patch("/profile/me", handlers.UpdateMyProfile)
		r.Get("/profile/{id}", handlers.GetPublicProfile)
		r.Get("/profile/me/badges", handlers.GetMyBadges)
		r.Get("/profile/{id}/badges", handlers.GetUserBadges)

		r.Post("/volunteer/toggle", handlers.ToggleVolunteer)
		r.Get("/safety/grid", handlers.GetSafetyGrid)
		r.Post("/fcm/token", handlers.UpdateFCMToken)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Printf("core-svc listening on :%s\n", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		fmt.Printf("Server error: %v\n", err)
	}
}

func OnboardHandler(w http.ResponseWriter, r *http.Request) {
	var req struct {
		UserID string `json:"user_id"`
		Phone  string `json:"phone"`
		Role   string `json:"role"`
	}
	if err := readJSON(r, &req); err != nil {
		http.Error(w, `{"error": "invalid body"}`, http.StatusBadRequest)
		return
	}

	_, err := db.Pool.Exec(r.Context(), `
		INSERT INTO profiles (id, phone, role)
		VALUES ($1, $2, $3)
		ON CONFLICT (id) DO UPDATE SET phone = EXCLUDED.phone, role = EXCLUDED.role
	`, req.UserID, req.Phone, req.Role)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write([]byte(`{"status": "onboarded"}`))
}

func readJSON(r *http.Request, v interface{}) error {
	return json.NewDecoder(r.Body).Decode(v)
}
