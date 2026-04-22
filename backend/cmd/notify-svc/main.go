package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/civiq/sudarshan-backend/internal/db"
	"github.com/civiq/sudarshan-backend/internal/fcm"
	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()

	if err := db.Init(); err != nil {
		fmt.Printf("Failed to init DB: %v\n", err)
		os.Exit(1)
	}
	defer db.Close()

	if err := fcm.Init(); err != nil {
		fmt.Printf("Failed to init FCM: %v\n", err)
		os.Exit(1)
	}

	// Start polling goroutine
	go pollDispatchQueue()
	go pollEscalationCron()

	mux := http.NewServeMux()
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`{"status":"ok"}`))
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "8081"
	}

	fmt.Printf("notify-svc listening on :%s\n", port)
	if err := http.ListenAndServe(":"+port, mux); err != nil {
		fmt.Printf("Server error: %v\n", err)
	}
}

func pollDispatchQueue() {
	ticker := time.NewTicker(5 * time.Second)
	defer ticker.Stop()

	for range ticker.C {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		processDispatchQueue(ctx)
		cancel()
	}
}

func processDispatchQueue(ctx context.Context) {
	// Find active issues created in last minute that haven't been broadcast
	rows, err := db.Pool.Query(ctx, `
		SELECT i.id, i.category, i.severity, i.description,
		       ST_X(i.exact_location::geometry) as lng,
		       ST_Y(i.exact_location::geometry) as lat,
		       i.broadcast_radius_m
		FROM issues i
		WHERE i.status = 'active'
		  AND i.assigned_volunteer_id IS NULL
		  AND i.created_at > now() - interval '2 minutes'
		  AND NOT EXISTS (
			  SELECT 1 FROM verification_events ve
			  WHERE ve.profile_id = i.reporter_id
			    AND ve.event_type = 'issue_broadcast'
			    AND ve.metadata->>'issue_id' = i.id::text
		  )
		LIMIT 10
	`)
	if err != nil {
		fmt.Printf("Dispatch query error: %v\n", err)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var issueID, category string
		var severity int
		var description *string
		var lng, lat float64
		var radiusM int

		if err := rows.Scan(&issueID, &category, &severity, &description, &lng, &lat, &radiusM); err != nil {
			continue
		}

		// Find nearby active volunteers
		volRows, err := db.Pool.Query(ctx, `
			SELECT p.fcm_token
			FROM profiles p
			WHERE p.is_active = true
			  AND p.role = 'volunteer'
			  AND p.fcm_token IS NOT NULL
			  AND ST_DWithin(p.current_location::geography, ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography, $3)
		`, lng, lat, radiusM)
		if err != nil {
			continue
		}

		var tokens []string
		for volRows.Next() {
			var token string
			if err := volRows.Scan(&token); err == nil {
				tokens = append(tokens, token)
			}
		}
		volRows.Close()

		if len(tokens) > 0 {
			title := fmt.Sprintf("New %s Issue Nearby", category)
			body := "A new issue needs your attention. Tap to view details."
			if description != nil && len(*description) > 0 {
				body = *description
				if len(body) > 100 {
					body = body[:100] + "..."
				}
			}

			data := map[string]string{
				"issue_id": issueID,
				"type":     "dispatch",
				"severity": fmt.Sprintf("%d", severity),
			}

			br, err := fcm.SendMulticast(ctx, tokens, title, body, data)
			if err != nil {
				fmt.Printf("FCM multicast error: %v\n", err)
			} else {
				fmt.Printf("FCM sent: %d success, %d failure\n", br.SuccessCount, br.FailureCount)
			}
		}

		// Mark as broadcast
		db.Pool.Exec(ctx, `
			INSERT INTO verification_events (profile_id, event_type, metadata)
			VALUES ((SELECT reporter_id FROM issues WHERE id = $1), 'issue_broadcast', jsonb_build_object('issue_id', $1))
		`, issueID)
	}
}

func pollEscalationCron() {
	ticker := time.NewTicker(1 * time.Minute)
	defer ticker.Stop()

	for range ticker.C {
		ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
		processEscalation(ctx)
		cancel()
	}
}

func processEscalation(ctx context.Context) {
	// Escalate broadcast radius at t+30min and t+60min
	_, err := db.Pool.Exec(ctx, `
		UPDATE issues
		SET broadcast_radius_m = CASE
			WHEN broadcast_radius_m = 2000 AND created_at < now() - interval '30 minutes' THEN 5000
			WHEN broadcast_radius_m = 5000 AND created_at < now() - interval '60 minutes' THEN 20000
			ELSE broadcast_radius_m
		END
		WHERE status = 'active'
		  AND assigned_volunteer_id IS NULL
	`)
	if err != nil {
		fmt.Printf("Escalation error: %v\n", err)
	}
}
