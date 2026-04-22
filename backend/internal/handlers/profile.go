package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/civiq/sudarshan-backend/internal/db"
	"github.com/civiq/sudarshan-backend/internal/middleware"
	"github.com/civiq/sudarshan-backend/internal/models"
	"github.com/go-chi/chi/v5"
)

// GetMyProfile returns the current authenticated user's full profile
func GetMyProfile(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())

	var p models.Profile
	err := db.Pool.QueryRow(r.Context(), `
		SELECT id, phone, name, avatar_url, role, trust_score, is_active,
		       current_location::text, volunteer_kyc_status, fcm_token,
		       xp_points, level, streak_days, total_reports, total_resolved, rank,
		       created_at, updated_at
		FROM profiles
		WHERE id = $1
	`, userID).Scan(
		&p.ID, &p.Phone, &p.Name, &p.AvatarURL, &p.Role, &p.TrustScore, &p.IsActive,
		&p.CurrentLocation, &p.VolunteerKYCStatus, &p.FCMToken,
		&p.XPPoints, &p.Level, &p.StreakDays, &p.TotalReports, &p.TotalResolved, &p.Rank,
		&p.CreatedAt, &p.UpdatedAt,
	)

	if err != nil {
		http.Error(w, `{"error": "profile not found"}`, http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(p)
}

// UpdateMyProfile updates the current user's editable fields
func UpdateMyProfile(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())

	var req models.UpdateProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, `{"error": "invalid request body"}`, http.StatusBadRequest)
		return
	}

	_, err := db.Pool.Exec(r.Context(), `
		UPDATE profiles
		SET name = NULLIF($1, ''),
		    avatar_url = NULLIF($2, ''),
		    updated_at = now()
		WHERE id = $3
	`, req.Name, req.AvatarURL, userID)

	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"status": "updated"})
}

// GetPublicProfile returns a public view of any user's profile
func GetPublicProfile(w http.ResponseWriter, r *http.Request) {
	profileID := chi.URLParam(r, "id")

	var p models.PublicProfile
	err := db.Pool.QueryRow(r.Context(), `
		SELECT id, name, avatar_url, role, trust_score,
		       xp_points, level, total_reports, total_resolved, rank
		FROM profiles
		WHERE id = $1
	`, profileID).Scan(
		&p.ID, &p.Name, &p.AvatarURL, &p.Role, &p.TrustScore,
		&p.XPPoints, &p.Level, &p.TotalReports, &p.TotalResolved, &p.Rank,
	)

	if err != nil {
		http.Error(w, `{"error": "profile not found"}`, http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(p)
}

// GetMyBadges returns all badges earned by the current user
func GetMyBadges(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())

	rows, err := db.Pool.Query(r.Context(), `
		SELECT id, badge_type, awarded_at
		FROM badges
		WHERE volunteer_id = $1
		ORDER BY awarded_at DESC
	`, userID)
	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var badges []models.BadgeWithMeta
	for rows.Next() {
		var b models.Badge
		if err := rows.Scan(&b.ID, &b.BadgeType, &b.AwardedAt); err != nil {
			continue
		}
		badges = append(badges, enrichBadge(b))
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(badges)
}

// GetUserBadges returns badges for a specific user (public)
func GetUserBadges(w http.ResponseWriter, r *http.Request) {
	profileID := chi.URLParam(r, "id")

	rows, err := db.Pool.Query(r.Context(), `
		SELECT id, badge_type, awarded_at
		FROM badges
		WHERE volunteer_id = $1
		ORDER BY awarded_at DESC
	`, profileID)
	if err != nil {
		http.Error(w, fmt.Sprintf(`{"error": "%s"}`, err.Error()), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var badges []models.BadgeWithMeta
	for rows.Next() {
		var b models.Badge
		if err := rows.Scan(&b.ID, &b.BadgeType, &b.AwardedAt); err != nil {
			continue
		}
		badges = append(badges, enrichBadge(b))
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(badges)
}

// enrichBadge adds human-readable metadata to a raw badge record
func enrichBadge(b models.Badge) models.BadgeWithMeta {
	meta := models.BadgeWithMeta{
		ID:        b.ID,
		BadgeType: b.BadgeType,
		AwardedAt: b.AwardedAt,
	}

	switch b.BadgeType {
	case "first_responder":
		meta.Label = "First Responder"
		meta.Description = "Resolved your first community issue"
		meta.Icon = "shield"
		meta.Color = "#FE6A34"
	case "community_pillar":
		meta.Label = "Community Pillar"
		meta.Description = "Resolved 5 issues in your community"
		meta.Icon = "people"
		meta.Color = "#00998D"
	case "locality_hero":
		meta.Label = "Locality Hero"
		meta.Description = "Resolved 10 issues — you're a local legend"
		meta.Icon = "star"
		meta.Color = "#AB3500"
	case "neighborhood_guardian":
		meta.Label = "Neighborhood Guardian"
		meta.Description = "Resolved 25 issues and kept your neighborhood safe"
		meta.Icon = "verified"
		meta.Color = "#040723"
	case "city_protector":
		meta.Label = "City Protector"
		meta.Description = "Resolved 50 issues — the city is safer because of you"
		meta.Icon = "emoji_events"
		meta.Color = "#FFD700"
	case "green_city":
		meta.Label = "Green City"
		meta.Description = "Contributed to environmental issue resolution"
		meta.Icon = "eco"
		meta.Color = "#4FDBCC"
	default:
		meta.Label = b.BadgeType
		meta.Description = "Achievement unlocked"
		meta.Icon = "emoji_events"
		meta.Color = "#FE6A34"
	}

	return meta
}
