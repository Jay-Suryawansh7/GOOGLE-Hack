package models

import (
	"time"
)

// Profile extends Supabase Auth users with app-specific fields
type Profile struct {
	ID                 string     `json:"id" db:"id"`
	Phone              string     `json:"phone" db:"phone"`
	Name               *string    `json:"name,omitempty" db:"name"`
	AvatarURL          *string    `json:"avatar_url,omitempty" db:"avatar_url"`
	Role               string     `json:"role" db:"role"`
	TrustScore         int        `json:"trust_score" db:"trust_score"`
	IsActive           bool       `json:"is_active" db:"is_active"`
	CurrentLocation    *string    `json:"current_location,omitempty" db:"current_location"`
	VolunteerKYCStatus string     `json:"volunteer_kyc_status" db:"volunteer_kyc_status"`
	FCMToken           *string    `json:"fcm_token,omitempty" db:"fcm_token"`
	// Gamification
	XPPoints      int    `json:"xp_points" db:"xp_points"`
	Level         int    `json:"level" db:"level"`
	StreakDays    int    `json:"streak_days" db:"streak_days"`
	TotalReports  int    `json:"total_reports" db:"total_reports"`
	TotalResolved int    `json:"total_resolved" db:"total_resolved"`
	Rank          string `json:"rank" db:"rank"`
	// Meta
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// PublicProfile is a subset of Profile returned for public viewing
type PublicProfile struct {
	ID            string  `json:"id"`
	Name          *string `json:"name,omitempty"`
	AvatarURL     *string `json:"avatar_url,omitempty"`
	Role          string  `json:"role"`
	TrustScore    int     `json:"trust_score"`
	XPPoints      int     `json:"xp_points"`
	Level         int     `json:"level"`
	TotalReports  int     `json:"total_reports"`
	TotalResolved int     `json:"total_resolved"`
	Rank          string  `json:"rank"`
}

// UpdateProfileRequest for PATCH /profile/me
type UpdateProfileRequest struct {
	Name      string `json:"name"`
	AvatarURL string `json:"avatar_url"`
}

// Issue represents a community-reported issue
type Issue struct {
	ID                  string     `json:"id" db:"id"`
	ReporterID          string     `json:"reporter_id" db:"reporter_id"`
	AssignedVolunteerID *string    `json:"assigned_volunteer_id,omitempty" db:"assigned_volunteer_id"`
	Status              string     `json:"status" db:"status"`
	Category            string     `json:"category" db:"category"`
	Severity            int        `json:"severity" db:"severity"`
	ExactLocation       string     `json:"exact_location" db:"exact_location"`
	Description         *string    `json:"description,omitempty" db:"description"`
	Details             *string    `json:"details,omitempty" db:"details"`
	PhotoURL            *string    `json:"photo_url,omitempty" db:"photo_url"`
	BroadcastRadiusM    int        `json:"broadcast_radius_m" db:"broadcast_radius_m"`
	CreatedAt           time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt           time.Time  `json:"updated_at" db:"updated_at"`
	AcceptedAt          *time.Time `json:"accepted_at,omitempty" db:"accepted_at"`
	ResolvedAt          *time.Time `json:"resolved_at,omitempty" db:"resolved_at"`
}

// IssueResolution tracks volunteer resolution of an issue
type IssueResolution struct {
	ID                  string    `json:"id" db:"id"`
	IssueID             string    `json:"issue_id" db:"issue_id"`
	VolunteerID         string    `json:"volunteer_id" db:"volunteer_id"`
	ReporterConfirmed   bool      `json:"reporter_confirmed" db:"reporter_confirmed"`
	PointsAwarded       int       `json:"points_awarded" db:"points_awarded"`
	ResponseTimeMinutes *int      `json:"response_time_minutes,omitempty" db:"response_time_minutes"`
	ResolutionNotes     *string   `json:"resolution_notes,omitempty" db:"resolution_notes"`
	ResolvedAt          time.Time `json:"resolved_at" db:"resolved_at"`
}

// Badge represents an achievement earned by a volunteer
type Badge struct {
	ID         string    `json:"id" db:"id"`
	VolunteerID string   `json:"volunteer_id" db:"volunteer_id"`
	BadgeType  string    `json:"badge_type" db:"badge_type"`
	AwardedAt  time.Time `json:"awarded_at" db:"awarded_at"`
}

// BadgeWithMeta includes human-readable badge info
type BadgeWithMeta struct {
	ID          string    `json:"id"`
	BadgeType   string    `json:"badge_type"`
	Label       string    `json:"label"`
	Description string    `json:"description"`
	Icon        string    `json:"icon"`
	Color       string    `json:"color"`
	AwardedAt   time.Time `json:"awarded_at"`
}

// VerificationEvent is an append-only audit log (DPDP Act compliance)
type VerificationEvent struct {
	ID         string                 `json:"id" db:"id"`
	ProfileID  string                 `json:"profile_id" db:"profile_id"`
	EventType  string                 `json:"event_type" db:"event_type"`
	ReviewerID *string                `json:"reviewer_id,omitempty" db:"reviewer_id"`
	ReasonCode *string                `json:"reason_code,omitempty" db:"reason_code"`
	Metadata   map[string]interface{} `json:"metadata,omitempty" db:"metadata"`
	CreatedAt  time.Time              `json:"created_at" db:"created_at"`
}

// CreateIssueRequest for POST /issues
type CreateIssueRequest struct {
	Category         string  `json:"category" validate:"required,oneof=medical safety infra animal environment other"`
	Severity         int     `json:"severity" validate:"required,min=1,max=5"`
	Lat              float64 `json:"lat" validate:"required"`
	Lng              float64 `json:"lng" validate:"required"`
	Description      string  `json:"description"`
	Details          string  `json:"details"`
	PhotoURL         string  `json:"photo_url"`
	BroadcastRadiusM int     `json:"broadcast_radius_m"`
}

// ClaimIssueRequest for PATCH /issues/:id/claim
type ClaimIssueRequest struct {
	VolunteerID string `json:"volunteer_id" validate:"required,uuid"`
}

// ResolveIssueRequest for PATCH /issues/:id/resolve
type ResolveIssueRequest struct {
	ResolutionNotes string `json:"resolution_notes"`
}

// ToggleVolunteerRequest for POST /volunteer/toggle
type ToggleVolunteerRequest struct {
	IsActive bool    `json:"is_active"`
	Lat      float64 `json:"lat,omitempty"`
	Lng      float64 `json:"lng,omitempty"`
}

// NearbyIssuesRequest query params
type NearbyIssuesRequest struct {
	Lat     float64 `json:"lat" validate:"required"`
	Lng     float64 `json:"lng" validate:"required"`
	RadiusM int     `json:"radius_m" validate:"required,min=100,max=10000"`
}

// SafetyGridRequest query params
type SafetyGridRequest struct {
	MinLat float64 `json:"min_lat" validate:"required"`
	MaxLat float64 `json:"max_lat" validate:"required"`
	MinLng float64 `json:"min_lng" validate:"required"`
	MaxLng float64 `json:"max_lng" validate:"required"`
}

// SafetyGridCell represents aggregated risk data
type SafetyGridCell struct {
	CellCenterLat float64 `json:"cell_center_lat"`
	CellCenterLng float64 `json:"cell_center_lng"`
	IssueCount    int     `json:"issue_count"`
	AvgSeverity   float64 `json:"avg_severity"`
	RiskScore     float64 `json:"risk_score"`
}

// FCMNotification for push dispatch
type FCMNotification struct {
	Token string            `json:"token"`
	Title string            `json:"title"`
	Body  string            `json:"body"`
	Data  map[string]string `json:"data,omitempty"`
}
