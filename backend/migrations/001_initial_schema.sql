-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- profiles table (extends Supabase Auth users)
CREATE TABLE IF NOT EXISTS profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone VARCHAR(15) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('citizen', 'volunteer', 'ngo', 'admin')),
    trust_score SMALLINT NOT NULL DEFAULT 50 CHECK (trust_score >= 0 AND trust_score <= 100),
    is_active BOOLEAN NOT NULL DEFAULT false,
    current_location GEOMETRY(Point, 4326),
    volunteer_kyc_status VARCHAR(20) NOT NULL DEFAULT 'unverified' CHECK (volunteer_kyc_status IN ('unverified', 'pending', 'approved', 'rejected')),
    fcm_token TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- GIST index on volunteer locations
CREATE INDEX IF NOT EXISTS idx_profiles_location ON profiles USING GIST (current_location) WHERE is_active = true;

-- issues table
CREATE TABLE IF NOT EXISTS issues (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reporter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    assigned_volunteer_id UUID REFERENCES profiles(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'in_progress', 'resolved', 'cancelled')),
    category VARCHAR(30) NOT NULL CHECK (category IN ('medical', 'safety', 'infra', 'animal', 'environment', 'other')),
    severity SMALLINT NOT NULL CHECK (severity >= 1 AND severity <= 5),
    exact_location GEOMETRY(Point, 4326) NOT NULL,
    description TEXT,
    photo_url TEXT,
    broadcast_radius_m INT NOT NULL DEFAULT 2000,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    accepted_at TIMESTAMPTZ,
    resolved_at TIMESTAMPTZ
);

-- Spatial indexes
CREATE INDEX IF NOT EXISTS idx_issues_location ON issues USING GIST (exact_location);
CREATE INDEX IF NOT EXISTS idx_issues_status ON issues(status);
CREATE INDEX IF NOT EXISTS idx_issues_reporter ON issues(reporter_id);
CREATE INDEX IF NOT EXISTS idx_issues_volunteer ON issues(assigned_volunteer_id);

-- issue_resolutions table
CREATE TABLE IF NOT EXISTS issue_resolutions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    issue_id UUID NOT NULL UNIQUE REFERENCES issues(id) ON DELETE CASCADE,
    volunteer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    reporter_confirmed BOOLEAN NOT NULL DEFAULT false,
    points_awarded INT NOT NULL DEFAULT 0,
    response_time_minutes INT,
    resolution_notes TEXT,
    resolved_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- badges table
CREATE TABLE IF NOT EXISTS badges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    volunteer_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    badge_type VARCHAR(30) NOT NULL,
    awarded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- verification_events audit log (DPDP Act compliance)
CREATE TABLE IF NOT EXISTS verification_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    event_type VARCHAR(30) NOT NULL,
    reviewer_id UUID REFERENCES profiles(id),
    reason_code VARCHAR(50),
    metadata JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Row Level Security Policies
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE issues ENABLE ROW LEVEL SECURITY;
ALTER TABLE issue_resolutions ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;

-- Profiles: users can read their own, volunteers can read basic info of others
CREATE POLICY "profiles_self_all" ON profiles
    FOR ALL USING (auth.uid() = id);

CREATE POLICY "profiles_public_read" ON profiles
    FOR SELECT USING (true);

-- Issues: reporters can read their own, volunteers can read active issues
CREATE POLICY "issues_reporter_all" ON issues
    FOR ALL USING (auth.uid() = reporter_id);

CREATE POLICY "issues_volunteer_read" ON issues
    FOR SELECT USING (
        status IN ('active', 'in_progress') OR
        assigned_volunteer_id = auth.uid() OR
        reporter_id = auth.uid()
    );

-- Issue resolutions: involved parties can read
CREATE POLICY "resolutions_involved_read" ON issue_resolutions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM issues i
            WHERE i.id = issue_resolutions.issue_id
            AND (i.reporter_id = auth.uid() OR i.assigned_volunteer_id = auth.uid())
        )
    );

-- Badges: public read for volunteers
CREATE POLICY "badges_public_read" ON badges
    FOR SELECT USING (true);

-- Function to update trust score on resolution confirmation
CREATE OR REPLACE FUNCTION update_trust_score()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.reporter_confirmed = true AND OLD.reporter_confirmed = false THEN
        UPDATE profiles
        SET trust_score = LEAST(trust_score + (NEW.points_awarded / 10), 100)
        WHERE id = NEW.volunteer_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_update_trust_score
    AFTER UPDATE ON issue_resolutions
    FOR EACH ROW
    EXECUTE FUNCTION update_trust_score();

-- Function to auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER trigger_issues_updated_at
    BEFORE UPDATE ON issues
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
