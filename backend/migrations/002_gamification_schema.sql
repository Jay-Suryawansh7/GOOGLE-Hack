-- Migration 002: Gamification, profile enrichment, and badge triggers

-- Add gamification fields to profiles
ALTER TABLE profiles
    ADD COLUMN IF NOT EXISTS name VARCHAR(100),
    ADD COLUMN IF NOT EXISTS avatar_url TEXT,
    ADD COLUMN IF NOT EXISTS xp_points INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS level INT NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS streak_days INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS total_reports INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS total_resolved INT NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS rank VARCHAR(30) NOT NULL DEFAULT 'Newcomer';

-- Add details field to issues (rich description shown in cards)
ALTER TABLE issues
    ADD COLUMN IF NOT EXISTS details TEXT;

-- Create index for profile stats lookups
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- Create index for my-reports lookups
CREATE INDEX IF NOT EXISTS idx_issues_reporter_created ON issues(reporter_id, created_at DESC);

-- Create index for volunteer history lookups
CREATE INDEX IF NOT EXISTS idx_issues_volunteer_resolved ON issues(assigned_volunteer_id, resolved_at DESC);

-- Function to award badges based on resolution count milestones
CREATE OR REPLACE FUNCTION award_badges_on_resolution()
RETURNS TRIGGER AS $$
DECLARE
    resolved_count INT;
    volunteer_rank VARCHAR(30);
    new_xp INT;
BEGIN
    -- Only proceed if reporter confirmed the resolution
    IF NEW.reporter_confirmed = true AND OLD.reporter_confirmed = false THEN
        -- Count total resolved issues for this volunteer
        SELECT COUNT(*) INTO resolved_count
        FROM issue_resolutions
        WHERE volunteer_id = NEW.volunteer_id;

        -- Update volunteer stats
        UPDATE profiles
        SET total_resolved = resolved_count,
            xp_points = xp_points + NEW.points_awarded,
            level = CASE
                WHEN xp_points + NEW.points_awarded >= 15000 THEN 15
                WHEN xp_points + NEW.points_awarded >= 10000 THEN 12
                WHEN xp_points + NEW.points_awarded >= 7000 THEN 10
                WHEN xp_points + NEW.points_awarded >= 4500 THEN 8
                WHEN xp_points + NEW.points_awarded >= 2500 THEN 6
                WHEN xp_points + NEW.points_awarded >= 1000 THEN 4
                WHEN xp_points + NEW.points_awarded >= 300 THEN 2
                ELSE 1
            END,
            rank = CASE
                WHEN xp_points + NEW.points_awarded >= 15000 THEN 'Legend'
                WHEN xp_points + NEW.points_awarded >= 10000 THEN 'Sentinel'
                WHEN xp_points + NEW.points_awarded >= 7000 THEN 'Guardian'
                WHEN xp_points + NEW.points_awarded >= 4500 THEN 'Protector'
                WHEN xp_points + NEW.points_awarded >= 2500 THEN 'Defender'
                WHEN xp_points + NEW.points_awarded >= 1000 THEN 'Watcher'
                WHEN xp_points + NEW.points_awarded >= 300 THEN 'Scout'
                ELSE 'Newcomer'
            END
        WHERE id = NEW.volunteer_id;

        -- Award milestone badges (idempotent via ON CONFLICT)
        IF resolved_count >= 1 THEN
            INSERT INTO badges (volunteer_id, badge_type)
            VALUES (NEW.volunteer_id, 'first_responder')
            ON CONFLICT DO NOTHING;
        END IF;

        IF resolved_count >= 5 THEN
            INSERT INTO badges (volunteer_id, badge_type)
            VALUES (NEW.volunteer_id, 'community_pillar')
            ON CONFLICT DO NOTHING;
        END IF;

        IF resolved_count >= 10 THEN
            INSERT INTO badges (volunteer_id, badge_type)
            VALUES (NEW.volunteer_id, 'locality_hero')
            ON CONFLICT DO NOTHING;
        END IF;

        IF resolved_count >= 25 THEN
            INSERT INTO badges (volunteer_id, badge_type)
            VALUES (NEW.volunteer_id, 'neighborhood_guardian')
            ON CONFLICT DO NOTHING;
        END IF;

        IF resolved_count >= 50 THEN
            INSERT INTO badges (volunteer_id, badge_type)
            VALUES (NEW.volunteer_id, 'city_protector')
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for badge awards
DROP TRIGGER IF EXISTS trigger_award_badges ON issue_resolutions;
CREATE TRIGGER trigger_award_badges
    AFTER UPDATE ON issue_resolutions
    FOR EACH ROW
    EXECUTE FUNCTION award_badges_on_resolution();

-- Function to increment reporter's total_reports on issue creation
CREATE OR REPLACE FUNCTION increment_reporter_stats()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE profiles
    SET total_reports = total_reports + 1
    WHERE id = NEW.reporter_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_increment_reporter_stats ON issues;
CREATE TRIGGER trigger_increment_reporter_stats
    AFTER INSERT ON issues
    FOR EACH ROW
    EXECUTE FUNCTION increment_reporter_stats();

-- Update RLS policy for profiles to allow public read of basic gamification fields
DROP POLICY IF EXISTS "profiles_public_read" ON profiles;
CREATE POLICY "profiles_public_read" ON profiles
    FOR SELECT USING (true);
