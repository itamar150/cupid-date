-- ============================================================
-- Cupid Date — Supabase Schema
-- הרץ קובץ זה פעם אחת ב-Supabase SQL Editor
-- ============================================================

-- ============================================================
-- 1. couples
-- ============================================================
create table if not exists couples (
  id          uuid primary key default gen_random_uuid(),
  user_a_id   uuid references auth.users(id) on delete cascade,
  user_b_id   uuid references auth.users(id) on delete cascade,
  invite_code text unique,
  status      text not null default 'active',
  created_at  timestamptz not null default now()
);

alter table couples enable row level security;

create policy "couples: שני בני הזוג קוראים"
  on couples for select
  using (user_a_id = auth.uid() or user_b_id = auth.uid());

create policy "couples: יצירה על ידי בן הזוג הראשון"
  on couples for insert
  with check (user_a_id = auth.uid());

create policy "couples: עדכון על ידי שני בני הזוג"
  on couples for update
  using (user_a_id = auth.uid() or user_b_id = auth.uid());

-- ============================================================
-- 2. profiles
-- ============================================================
create table if not exists profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  name            text,
  last_name       text,
  email           text,
  area            text,
  couple_id       uuid references couples(id) on delete set null,
  surprise_opt_in boolean not null default true,
  created_at      timestamptz not null default now()
);

alter table profiles enable row level security;

create policy "profiles: קריאה עצמית"
  on profiles for select
  using (id = auth.uid());

create policy "profiles: כתיבה עצמית"
  on profiles for insert
  with check (id = auth.uid());

create policy "profiles: עדכון עצמי"
  on profiles for update
  using (id = auth.uid());

-- פונקציית עזר — מוגדרת אחרי profiles כי היא מבצעת query על הטבלה
create or replace function get_my_couple_id()
returns uuid
language sql
stable
security definer
as $$
  select couple_id from profiles where id = auth.uid();
$$;

-- ============================================================
-- 3. preferences
-- ============================================================
create table if not exists preferences (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references profiles(id) on delete cascade,
  couple_id     uuid references couples(id) on delete cascade,
  max_radius_km integer not null default 20,
  dietary       text[] not null default '{}',
  max_budget    integer not null default 500,
  vibe_profile  jsonb not null default '{}',
  updated_at    timestamptz not null default now()
);

alter table preferences enable row level security;

-- שני בני הזוג קוראים (נדרש להצלבת Red Lines)
create policy "preferences: שני בני הזוג קוראים"
  on preferences for select
  using (couple_id = get_my_couple_id());

-- רק הבעלים כותב לרשומה שלו
create policy "preferences: כתיבה עצמית בלבד"
  on preferences for insert
  with check (user_id = auth.uid());

create policy "preferences: עדכון עצמי בלבד"
  on preferences for update
  using (user_id = auth.uid());

-- ============================================================
-- 4. events (pool מקומות — ללא מידע אישי)
-- ============================================================
create table if not exists events (
  id                uuid primary key default gen_random_uuid(),
  google_place_id   text unique not null,
  name              text not null,
  vibe              text not null, -- calm / loud / active / food / nature
  city              text not null,
  lat               numeric not null,
  lng               numeric not null,
  google_rating     numeric,
  score             numeric,
  opening_hours     jsonb,
  last_validated_at timestamptz,
  created_at        timestamptz not null default now()
);

alter table events enable row level security;

-- קריאה פתוחה לכולם (אין מידע אישי)
create policy "events: קריאה פתוחה"
  on events for select
  using (true);

-- אין כתיבה מהלקוח — רק Edge Functions עם service_role

-- ============================================================
-- 5. date_sessions
-- ============================================================
create table if not exists date_sessions (
  id                uuid primary key default gen_random_uuid(),
  couple_id         uuid not null references couples(id) on delete cascade,
  status            text not null default 'choosing',
  -- choosing / pending_partner / confirmed / cancelled
  vibe_selected     text,
  initiated_by      uuid references profiles(id),
  selected_event_id uuid references events(id),
  shuffle_count     integer not null default 0,
  deadline_day      text,
  created_at        timestamptz not null default now(),
  confirmed_at      timestamptz
);

alter table date_sessions enable row level security;

create policy "date_sessions: שני בני הזוג קוראים"
  on date_sessions for select
  using (couple_id = get_my_couple_id());

create policy "date_sessions: שני בני הזוג יוצרים"
  on date_sessions for insert
  with check (couple_id = get_my_couple_id());

create policy "date_sessions: שני בני הזוג מעדכנים"
  on date_sessions for update
  using (couple_id = get_my_couple_id());

-- ============================================================
-- 6. history
-- ============================================================
create table if not exists history (
  id              uuid primary key default gen_random_uuid(),
  couple_id       uuid not null references couples(id) on delete cascade,
  event_id        uuid references events(id),
  date_session_id uuid references date_sessions(id),
  date            date,
  feedback_a      text, -- 'star' / 'broken_heart'
  feedback_b      text,
  tags_a          text[] not null default '{}',
  tags_b          text[] not null default '{}',
  created_at      timestamptz not null default now()
);

alter table history enable row level security;

create policy "history: שני בני הזוג קוראים"
  on history for select
  using (couple_id = get_my_couple_id());

create policy "history: שני בני הזוג יוצרים"
  on history for insert
  with check (couple_id = get_my_couple_id());

create policy "history: שני בני הזוג מעדכנים"
  on history for update
  using (couple_id = get_my_couple_id());

-- ============================================================
-- 7. nudges
-- ============================================================
create table if not exists nudges (
  id            uuid primary key default gen_random_uuid(),
  couple_id     uuid not null references couples(id) on delete cascade,
  type          text not null, -- 'weekend_booster' / 'deadline_keeper'
  scheduled_for timestamptz not null,
  status        text not null default 'pending', -- pending / sent / cancelled
  created_at    timestamptz not null default now()
);

alter table nudges enable row level security;

create policy "nudges: שני בני הזוג קוראים"
  on nudges for select
  using (couple_id = get_my_couple_id());

create policy "nudges: שני בני הזוג יוצרים"
  on nudges for insert
  with check (couple_id = get_my_couple_id());

create policy "nudges: שני בני הזוג מעדכנים"
  on nudges for update
  using (couple_id = get_my_couple_id());

-- ============================================================
-- סיום — בדוק ב-Table Editor ש-7 טבלאות נוצרו עם RLS ✅
-- ============================================================
