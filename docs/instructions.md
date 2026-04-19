# Cupid Date — Product Compass

## Mission
A native mobile app (Flutter) for couples that eliminates the friction of choosing how to spend time together.
**Zero-Text Policy** — all interactions are clicks only. No chat, no free text input.

---

## Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (iOS + Android, single codebase) |
| Backend & DB | Supabase (PostgreSQL, Realtime, Edge Functions, Auth, pg_cron) |
| Notifications | Firebase Cloud Messaging (FCM) via FlutterFire |
| Places Data | Google Places API |
| AI | **Removed from MVP** — enters later for personalization |

---

## MVP Boundaries

- No AI, no scraping (TikTok/Instagram removed)
- No Vercel — Supabase covers all backend needs
- Scoring is purely algorithmic: **Weighted Scoring Algorithm**
  ```
  score = (google_rating × 0.4) + (vibe_match × 0.4) + (distance_score × 0.2)
  ```

---

## Core Flows

### 1. Onboarding
1. Magic Link auth (no passwords)
2. User A creates group → receives unique code → User B enters code → both linked via `couple_id`
3. Each user sets **Red Lines**: max radius, dietary restrictions, max budget
4. **Vibe Profile**: swipe on lifestyle images to build initial profile
5. **Surprise Mode**: opt-in/opt-out (default: on)

### 2. Discovery
- User selects a Vibe from a fixed list: `calm / loud / active / food / nature`
- System shows **4–5 option cards**
- **Freshness Check**: before display, ping Google Places for those 4–5 options only. Closed venue → replaced from pool
- **Shuffle**: up to **5 times** — pulls randomly from DB pool (no API call)
- After 5 shuffles: prompt "Expand search?" (radius / budget)
- If zero results: auto-expand radius

### 3. Partner Sync (Real-time)
- Initiator picks → partner receives push notification → partner confirms ✅ or Pivots 🔄
- **Pivot**: partner selects new Vibe → system updates 4–5 options via Supabase Realtime
- **Surprise Mode**: venue details revealed only close to departure time (opt-in users only)

**Conflict Handling Rules:**
- Initiator selected venue + partner presses Pivot simultaneously → **Pivot wins**, session resets to `choosing`
- Both partners confirm at the same time → **first confirmation wins**, status → `confirmed`, second write is ignored (optimistic lock via Supabase)
- All conflict resolution is detected via Supabase Realtime — both partners see updated state immediately, no manual refresh needed

### 4. Post-Date Feedback
- Next day: ⭐ / 💔 rating
- Optional tags disappear after 5 seconds if untouched: 🔥 Wow / 👍 Fine / 😐 OK / 👎 Not for us

### 5. Automated Notifications
- **Weekend Booster**: push on Wednesday/Thursday if no confirmed date
- **Deadline Keeper**: reminder on the couple's self-set deadline day
- **Auto-cancel nudges**: when `date_session.status → confirmed`, all pending nudges cancelled

---

## Red Lines Intersection Logic

```
effective_radius  = MIN(pref_a.max_radius_km, pref_b.max_radius_km)
effective_budget  = MIN(pref_a.max_budget, pref_b.max_budget)
effective_dietary = UNION(pref_a.dietary, pref_b.dietary)
```

---

## Database Schema (Quick Reference)

| Table | Key Columns |
|---|---|
| `profiles` | id, name, email, couple_id, surprise_opt_in |
| `couples` | id, user_a_id, user_b_id, status |
| `preferences` | user_id, couple_id, max_radius_km, dietary[], max_budget, vibe_profile (jsonb) |
| `events` | google_place_id, name, vibe, city, lat, lng, google_rating, score, opening_hours, last_validated_at |
| `date_sessions` | couple_id, status, vibe_selected, initiated_by, selected_event_id, shuffle_count, deadline_day |
| `history` | couple_id, event_id, date_session_id, date, feedback_a/b, tags_a/b |
| `nudges` | couple_id, type, scheduled_for, status |

**`date_sessions.status` values:** `choosing` → `pending_partner` → `confirmed` / `cancelled`

---

## Estimated Costs

| Stage | Users | Monthly Cost |
|---|---|---|
| MVP | 0–200 couples | ~$0 (Google $200 credit covers it) |
| Growth | 1,000 couples | ~$50–100 |
| Scale | 10,000 couples | ~$500–800 |
