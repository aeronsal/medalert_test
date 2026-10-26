-- ==============================================================================
-- MedAlert PostgreSQL Schema for Supabase
-- Instructions:
-- 1. Open your Supabase Dashboard: https://supabase.com/dashboard
-- 2. Select your Project -> Click "SQL Editor" in the left sidebar
-- 3. Click "New Query", paste this entire script, and click "Run"
-- ==============================================================================

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'patient' CHECK (role IN ('patient', 'doctor')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_login TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  profile_complete BOOLEAN NOT NULL DEFAULT FALSE
);

-- 2. USER PROFILES TABLE
CREATE TABLE IF NOT EXISTS public.user_profiles (
  user_id UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  age INT NOT NULL DEFAULT 0,
  gender TEXT DEFAULT '',
  weight REAL NOT NULL DEFAULT 0,
  height REAL NOT NULL DEFAULT 0,
  smoking TEXT DEFAULT 'never',
  alcohol TEXT DEFAULT 'rarely',
  diet_type TEXT DEFAULT 'balanced',
  vegetable_intake TEXT DEFAULT 'daily',
  fruit_intake TEXT DEFAULT 'daily',
  processed_food TEXT DEFAULT 'sometimes',
  activity_level TEXT DEFAULT 'moderate',
  goal TEXT DEFAULT 'maintain' CHECK (goal IN ('lose', 'maintain', 'gain')),
  medical_conditions JSONB DEFAULT '[]'::jsonb,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. DAILY LOGS TABLE
CREATE TABLE IF NOT EXISTS public.daily_logs (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date TEXT NOT NULL,
  sleep_hours REAL NOT NULL DEFAULT 0,
  exercise_minutes INT NOT NULL DEFAULT 0,
  water_intake INT NOT NULL DEFAULT 0,
  caffeine_intake INT NOT NULL DEFAULT 0,
  weight REAL NULL,
  track_weight BOOLEAN DEFAULT FALSE,
  calories INT NOT NULL DEFAULT 0,
  protein REAL NOT NULL DEFAULT 0,
  carbs REAL NOT NULL DEFAULT 0,
  fats REAL NOT NULL DEFAULT 0,
  food_quality TEXT NULL,
  meals JSONB DEFAULT '[]'::jsonb,
  track_macros BOOLEAN DEFAULT FALSE,
  notes TEXT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT daily_logs_user_date_unique UNIQUE (user_id, date)
);

-- 4. ML SNAPSHOTS TABLE
CREATE TABLE IF NOT EXISTS public.ml_snapshots (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date TEXT NOT NULL,
  overall_score REAL NOT NULL DEFAULT 0,
  cardiovascular REAL NOT NULL DEFAULT 0,
  metabolic REAL NOT NULL DEFAULT 0,
  nutritional REAL NOT NULL DEFAULT 0,
  sleep REAL NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT ml_snapshots_user_date_unique UNIQUE (user_id, date)
);

-- 5. DOCTOR TIP REVIEWS TABLE
CREATE TABLE IF NOT EXISTS public.tip_reviews (
  id UUID PRIMARY KEY,
  patient_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  patient_name TEXT NOT NULL,
  patient_email TEXT NOT NULL,
  date TEXT NOT NULL,
  category TEXT NOT NULL,
  item_index INT NOT NULL DEFAULT 0,
  item_key TEXT NOT NULL UNIQUE,
  original_text TEXT NOT NULL,
  approved_text TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  reviewed_by TEXT NULL,
  reviewed_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) & PUBLIC ACCESS POLICIES
-- Configures open read/write access for the client anon key
-- ==============================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ml_snapshots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tip_reviews ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if re-running
DROP POLICY IF EXISTS "Public full access to users" ON public.users;
DROP POLICY IF EXISTS "Public full access to user_profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Public full access to daily_logs" ON public.daily_logs;
DROP POLICY IF EXISTS "Public full access to ml_snapshots" ON public.ml_snapshots;
DROP POLICY IF EXISTS "Public full access to tip_reviews" ON public.tip_reviews;

-- Create policies granting access to client anon key
CREATE POLICY "Public full access to users" ON public.users
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public full access to user_profiles" ON public.user_profiles
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public full access to daily_logs" ON public.daily_logs
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public full access to ml_snapshots" ON public.ml_snapshots
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public full access to tip_reviews" ON public.tip_reviews
  FOR ALL USING (true) WITH CHECK (true);
