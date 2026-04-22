package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"github.com/civiq/sudarshan-backend/internal/db"
	"github.com/civiq/sudarshan-backend/internal/middleware"
	"github.com/civiq/sudarshan-backend/internal/models"
	"github.com/go-chi/chi/v5"
)

func CreateIssue(w http.ResponseWriter, r *http.Request) {
	var req models.CreateIssueRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error": "invalid request body"}`, http.StatusBadRequest)
		return
	}

	if req.BroadcastRadiusM == 0 {
		req.BroadcastRadiusM = 2000
	}

	userID := middleware.GetUserID(r.Context())

	var issueID string
	err := db.Pool.QueryRow(r.Context(), `
		INSERT INTO issues (reporter_id, category, severity, exact_location, description, details, photo_url, broadcast_radius_m)
		VALUES ($1, $2, $3, ST_SetSRID(ST_MakePoint($4, $5), 4326), $6, $7, $8, $9)
		RETURNING id
	`, userID, req.Category, req.Severity, req.Lng, req.Lat, req.Description, req.Details, req.PhotoURL, req.BroadcastRadiusM).Scan(&issueID)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"id": issueID, "status": "created"})
}

func GetNearbyIssues(w http.ResponseWriter, r *http.Request) {
	latStr := r.URL.Query().Get("lat")
	lngStr := r.URL.Query().Get("lng")
	radiusStr := r.URL.Query().Get("radius_m")

	lat, _ := strconv.ParseFloat(latStr, 64)
	lng, _ := strconv.ParseFloat(lngStr, 64)
	radiusM, _ := strconv.Atoi(radiusStr)
	if radiusM == 0 {
		radiusM = 2000
	}

	rows, err := db.Pool.Query(r.Context(), `
		SELECT id, reporter_id, assigned_volunteer_id, status, category, severity,
		       ST_X(exact_location::geometry) as lng, ST_Y(exact_location::geometry) as lat,
		       description, details, photo_url, created_at
		FROM issues
		WHERE status = 'active'
		  AND ST_DWithin(exact_location::geography, ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography, $3)
		ORDER BY exact_location <-> ST_SetSRID(ST_MakePoint($1, $2), 4326)
		LIMIT 50
	`, lng, lat, radiusM)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var issues []map[string]interface{}
	for rows.Next() {
		var id, reporterID, status, category string
		var severity int
		var lng, lat float64
		var desc, details, photoURL *string
		var assignedTo *string
		var createdAt time.Time

		if err := rows.Scan(&id, &reporterID, &assignedTo, &status, &category, &severity, &lng, &lat, &desc, &details, &photoURL, &createdAt); err != nil {
			continue
		}

		issue := map[string]interface{}{
			"id":         id,
			"status":     status,
			"category":   category,
			"severity":   severity,
			"lat":        lat,
			"lng":        lng,
			"created_at": createdAt,
		}
		if desc != nil {
			issue["description"] = *desc
		}
		if details != nil {
			issue["details"] = *details
		}
		if photoURL != nil {
			issue["photo_url"] = *photoURL
		}
		issues = append(issues, issue)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(issues)
}

func GetIssueDetail(w http.ResponseWriter, r *http.Request) {
	issueID := chi.URLParam(r, "id")
	userID := middleware.GetUserID(r.Context())

	var issue models.Issue
	var lng, lat float64
	err := db.Pool.QueryRow(r.Context(), `
		SELECT id, reporter_id, assigned_volunteer_id, status, category, severity,
		       ST_X(exact_location::geometry), ST_Y(exact_location::geometry),
		       description, details, photo_url, created_at, accepted_at, resolved_at
		FROM issues WHERE id = $1
	`, issueID).Scan(
		&issue.ID, &issue.ReporterID, &issue.AssignedVolunteerID, &issue.Status, &issue.Category, &issue.Severity,
		&lng, &lat, &issue.Description, &issue.Details, &issue.PhotoURL, &issue.CreatedAt, &issue.AcceptedAt, &issue.ResolvedAt,
	)

	if err != nil {
		http.Error(w, `{"error": "issue not found"}`, http.StatusNotFound)
		return
	}

	// Location privacy: only show exact location if assigned or reporter
	if issue.ReporterID == userID || (issue.AssignedVolunteerID != nil && *issue.AssignedVolunteerID == userID) {
		issue.ExactLocation = fmt.Sprintf("POINT(%f %f)", lng, lat)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(issue)
}

func ClaimIssue(w http.ResponseWriter, r *http.Request) {
	issueID := chi.URLParam(r, "id")
	volunteerID := middleware.GetUserID(r.Context())

	var claimedID string
	err := db.Pool.QueryRow(r.Context(), `
		UPDATE issues
		SET assigned_volunteer_id = $1, status = 'in_progress', accepted_at = now()
		WHERE id = $2 AND status = 'active' AND assigned_volunteer_id IS NULL
		RETURNING id
	`, volunteerID, issueID).Scan(&claimedID)

	if err != nil {
		w.WriteHeader(http.StatusConflict)
		json.NewEncoder(w).Encode(map[string]string{"error": "Task already taken"})
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"id": claimedID, "status": "claimed"})
}

func ResolveIssue(w http.ResponseWriter, r *http.Request) {
	issueID := chi.URLParam(r, "id")
	volunteerID := middleware.GetUserID(r.Context())

	var req models.ResolveIssueRequest
	json.NewDecoder(r.Body).Decode(&req)

	var resolutionID string
	err := db.Pool.QueryRow(r.Context(), `
		UPDATE issues
		SET status = 'resolved', resolved_at = now()
		WHERE id = $1 AND assigned_volunteer_id = $2 AND status = 'in_progress'
		RETURNING id
	`, issueID, volunteerID).Scan(&resolutionID)

	if err != nil {
		http.Error(w, `{"error": "issue not found or not assigned to you"}`, http.StatusBadRequest)
		return
	}

	// Create resolution record
	_, err = db.Pool.Exec(r.Context(), `
		INSERT INTO issue_resolutions (issue_id, volunteer_id, resolution_notes, response_time_minutes)
		VALUES ($1, $2, $3, (
			SELECT EXTRACT(EPOCH FROM (now() - accepted_at)) / 60
			FROM issues WHERE id = $1
		))
	`, issueID, volunteerID, req.ResolutionNotes)

	if err != nil {
		// Non-fatal: resolution record creation failed but issue is marked resolved
		fmt.Printf("Failed to create resolution record: %v\n", err)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"id": resolutionID, "status": "resolved"})
}

func ToggleVolunteer(w http.ResponseWriter, r *http.Request) {
	var req models.ToggleVolunteerRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error": "invalid request body"}`, http.StatusBadRequest)
		return
	}

	userID := middleware.GetUserID(r.Context())

	var err error
	if req.IsActive && req.Lat != 0 && req.Lng != 0 {
		_, err = db.Pool.Exec(r.Context(), `
			UPDATE profiles
			SET is_active = $1, current_location = ST_SetSRID(ST_MakePoint($2, $3), 4326), updated_at = now()
			WHERE id = $4
		`, req.IsActive, req.Lng, req.Lat, userID)
	} else {
		_, err = db.Pool.Exec(r.Context(), `
			UPDATE profiles
			SET is_active = $1, current_location = NULL, updated_at = now()
			WHERE id = $2
		`, req.IsActive, userID)
	}

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "updated", "is_active": fmt.Sprintf("%v", req.IsActive)})
}

func GetSafetyGrid(w http.ResponseWriter, r *http.Request) {
	minLat, _ := strconv.ParseFloat(r.URL.Query().Get("min_lat"), 64)
	maxLat, _ := strconv.ParseFloat(r.URL.Query().Get("max_lat"), 64)
	minLng, _ := strconv.ParseFloat(r.URL.Query().Get("min_lng"), 64)
	maxLng, _ := strconv.ParseFloat(r.URL.Query().Get("max_lng"), 64)

	if maxLat-minLat > 2.0 || maxLng-minLng > 2.0 {
		http.Error(w, `{"error": "bounding box too large"}`, http.StatusBadRequest)
		return
	}

	rows, err := db.Pool.Query(r.Context(), `
		SELECT 
			ST_Y(ST_Centroid(grid_geom)) as cell_center_lat,
			ST_X(ST_Centroid(grid_geom)) as cell_center_lng,
			COALESCE(COUNT(i.id), 0) as issue_count,
			COALESCE(AVG(i.severity), 0) as avg_severity
		FROM (
			SELECT ST_SquareGrid(0.005, ST_MakeEnvelope($1, $2, $3, $4, 4326)) AS grid_geom
		) g
		LEFT JOIN issues i ON ST_Within(i.exact_location::geometry, g.grid_geom) AND i.status = 'active'
		GROUP BY g.grid_geom
		HAVING COUNT(i.id) > 0
	`, minLng, minLat, maxLng, maxLat)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var cells []models.SafetyGridCell
	for rows.Next() {
		var cell models.SafetyGridCell
		if err := rows.Scan(&cell.CellCenterLat, &cell.CellCenterLng, &cell.IssueCount, &cell.AvgSeverity); err != nil {
			continue
		}
		cell.RiskScore = cell.AvgSeverity * float64(cell.IssueCount)
		cells = append(cells, cell)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(cells)
}

func GetMyReports(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	statusFilter := r.URL.Query().Get("status")

	query := `
		SELECT id, status, category, severity,
		       ST_X(exact_location::geometry) as lng, ST_Y(exact_location::geometry) as lat,
		       description, details, photo_url, created_at, resolved_at
		FROM issues
		WHERE reporter_id = $1
	`
	args := []interface{}{userID}

	if statusFilter != "" {
		query += ` AND status = $2`
		args = append(args, statusFilter)
	}
	query += ` ORDER BY created_at DESC LIMIT 50`

	rows, err := db.Pool.Query(r.Context(), query, args...)
	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var issues []map[string]interface{}
	for rows.Next() {
		var id, status, category string
		var severity int
		var lng, lat float64
		var desc, details, photoURL *string
		var createdAt time.Time
		var resolvedAt *time.Time

		if err := rows.Scan(&id, &status, &category, &severity, &lng, &lat, &desc, &details, &photoURL, &createdAt, &resolvedAt); err != nil {
			continue
		}

		issue := map[string]interface{}{
			"id":         id,
			"status":     status,
			"category":   category,
			"severity":   severity,
			"lat":        lat,
			"lng":        lng,
			"created_at": createdAt,
		}
		if desc != nil {
			issue["description"] = *desc
		}
		if details != nil {
			issue["details"] = *details
		}
		if photoURL != nil {
			issue["photo_url"] = *photoURL
		}
		if resolvedAt != nil {
			issue["resolved_at"] = *resolvedAt
		}
		issues = append(issues, issue)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(issues)
}

func GetVolunteerHistory(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())

	rows, err := db.Pool.Query(r.Context(), `
		SELECT i.id, i.status, i.category, i.severity,
		       i.description, i.details, i.photo_url, i.created_at, i.resolved_at,
		       ir.points_awarded, ir.response_time_minutes
		FROM issues i
		JOIN issue_resolutions ir ON ir.issue_id = i.id
		WHERE i.assigned_volunteer_id = $1
		ORDER BY i.resolved_at DESC NULLS LAST
		LIMIT 50
	`, userID)
	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var history []map[string]interface{}
	for rows.Next() {
		var id, status, category string
		var severity, pointsAwarded int
		var desc, details, photoURL *string
		var createdAt time.Time
		var resolvedAt *time.Time
		var responseTime *int

		if err := rows.Scan(&id, &status, &category, &severity, &desc, &details, &photoURL, &createdAt, &resolvedAt, &pointsAwarded, &responseTime); err != nil {
			continue
		}

		item := map[string]interface{}{
			"id":             id,
			"status":         status,
			"category":       category,
			"severity":       severity,
			"points_awarded": pointsAwarded,
			"created_at":     createdAt,
		}
		if desc != nil {
			item["description"] = *desc
		}
		if details != nil {
			item["details"] = *details
		}
		if photoURL != nil {
			item["photo_url"] = *photoURL
		}
		if resolvedAt != nil {
			item["resolved_at"] = *resolvedAt
		}
		if responseTime != nil {
			item["response_time_minutes"] = *responseTime
		}
		history = append(history, item)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(history)
}

func UpdateFCMToken(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Token string `json:"token"`
	}
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error": "invalid request body"}`, http.StatusBadRequest)
		return
	}

	userID := middleware.GetUserID(r.Context())
	_, err := db.Pool.Exec(r.Context(), `
		UPDATE profiles SET fcm_token = $1, updated_at = now() WHERE id = $2
	`, req.Token, userID)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "updated"})
}
