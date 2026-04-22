# Sudarshan Backend

Go microservices backend for the Sudarshan community safety platform.

## Architecture

Based on the CIVIQ MVP Plan, with the following tech stack:
- **Go 1.22** microservices (core-svc, notify-svc)
- **Supabase** for PostgreSQL database, Auth (phone OTP), Storage
- **Firebase FCM** for push notifications ONLY
- No Neon SQL, no Better Auth, no Cloudflare R2, no Twilio

## Services

### core-svc (port 8080)
- Issues CRUD (`POST /issues`, `GET /issues/nearby`, `GET /issues/:id`)
- OCC Claim (`PATCH /issues/:id/claim`)
- Resolution (`PATCH /issues/:id/resolve`)
- Volunteer toggle (`POST /volunteer/toggle`)
- Safety grid (`GET /safety/grid`)
- Onboarding (`POST /onboard`)
- FCM token sync (`POST /fcm/token`)

### notify-svc (port 8081)
- Polls database every 5s for new active issues
- Sends FCM push to nearby active volunteers
- Escalation cron: expands broadcast radius at t+30m and t+60m

## Environment Variables

Copy `.env.example` to `.env` and fill in your Supabase project credentials.

## Database

Run `001_initial_schema.sql` in your Supabase SQL Editor. It creates:
- `profiles` (extends `auth.users`)
- `issues` (with PostGIS geometry)
- `issue_resolutions`
- `badges`
- `verification_events` (audit log)
- RLS policies
- Trust score trigger

## Deployment

Build:
```bash
cd backend
go build ./cmd/core-svc
go build ./cmd/notify-svc
```

Run locally:
```bash
SUPABASE_DATABASE_URL=postgresql://... SUPABASE_JWT_SECRET=... ./core-svc
SUPABASE_DATABASE_URL=... ./notify-svc
```

## Supabase Setup

1. Create a Supabase project
2. Enable **Phone Auth** in Authentication > Providers
3. Run the migration SQL in the SQL Editor
4. Update Flutter `SUPABASE_URL` and `SUPABASE_ANON_KEY`
5. Update backend `.env` with database pooler URL and JWT secret
