# Cupid Date — Progress Tracker

## תשתית ומסמכים
- [x] `docs/spec.md` — אפיון מלא (כולל מיפוי hang→vibe, קטגוריות vibe, מגדר)
- [x] `docs/instructions.md` — מצפן מוצר
- [x] `docs/design_system.md` — Design System מלא
- [x] `CLAUDE.md` — סטנדרטים טכניים + Self-QA Checklist

## סביבת פיתוח
- [x] Flutter SDK מותקן (3.41.7)
- [x] Android Studio מותקן
- [x] Android toolchain מוגדר
- [x] אמולטור Pixel 8 מוגדר
- [x] פרויקט Flutter נוצר (`app/`)
- [x] `pubspec.yaml` — כל ה-dependencies + `assets/images/vibes/`
- [x] מבנה תיקיות Clean Architecture

## Backend
- [x] Supabase — פרויקט נוצר, URL + anon key בידינו
- [x] Firebase — פרויקט נוצר, `google-services.json` + `firebase_options.dart` מוגדרים
- [x] עמודת `gender INTEGER DEFAULT 1` נוספה לטבלת `profiles`

## אבטחה
- [x] `firebase_options.dart` ב-`.gitignore`
- [x] `google-services.json` ב-`.gitignore`
- [ ] RLS מוגדר על טבלאות Supabase

---

## Phase 1 — Design System בקוד ✅
- [x] `core/theme/app_colors.dart` (כולל heroGradient, heroGradient1, card colors)
- [x] `core/theme/app_typography.dart` (Rubik)
- [x] `core/theme/app_spacing.dart`
- [x] `core/theme/app_radius.dart`
- [x] `core/theme/app_theme.dart`

## Phase 2 — Auth ✅
- [x] Supabase Auth + Magic Link + Google Sign-in (`login_screen.dart`)
- [x] OTP verification (`otp_screen.dart`)
- [x] Riverpod providers: `isAuthenticatedProvider`, `profileExistsProvider`, `vibeProfileCompleteProvider`, `currentUserNameProvider`, `currentUserGenderProvider`
- [x] קישור זוגי — קובץ קיים (`couple_link_screen.dart`), **לא בonboarding** — יופעל מכפתור בבית
- [x] Splash Screen — native + Flutter fade-in animation
- [x] Routing: `_ProfileGate` → `_VibeGate` → `VibeSelectionScreen` (ללא CoupleGate)
- [x] Logout דרך לחיצה על שם המשתמש בכותרת הבית (bottom sheet)

## Phase 3 — Onboarding ✅ (חלקי)
- [x] User Profile screen — שם, מגדר (dropdown), איזור, רדיוס, העדפות אוכל (`user_profile_screen.dart`)
  - הוסר: מצב הפתעה (עבר לכפתור בבית)
- [x] Hang Profile screen — 14 פעילויות, אנימציית scale על בחירה (`hang_profile_screen.dart`)
- [x] Gender entity + enum (`domain/entities/gender.dart`) — male/female/other, תומך בטקסט דינמי זכר/נקבה
- [x] Vibe entity + מיפוי hang→vibe (`domain/entities/vibe.dart`) — קטגוריות: רגוע/אוכל/טבע/אתגרי/קומי/חיי לילה
- [x] OnboardingHeader מעודכן — gradient + קימור + כוכבים (כמו HomeHeader)

## Phase 3 — מסך הבית ✅ (חלקי)
- [x] `HomeHeader` — widget משותף לכל מסכי הבית (gradient + קימור + כוכבים + שם משתמש)
- [x] `VibeSelectionScreen` — קרוסלה תלת-ממדית עם scale, 6 קטגוריות, כפתור "תפתיע אותנו!", 2 כפתורי פינות
- [x] כפתור "תפתיע אותנו!" — אקטיבציה לסשן בלבד (לא נשמר ב-DB), surpriseOptIn=false כברירת מחדל
- [ ] תמונות אמיתיות לכרטיסי קרוסלה (JPG, 800×1100px, תיקייה: `assets/images/vibes/`)
- [ ] כפתור שמאל (tune) — הרחבת/עדכון חיפוש (רדיוס, vibe, עיר)
- [ ] כפתור ימין (group_add) — הוספת פרטנר לHang

## Phase 4 — Data Pipeline ✅ (חלקי)
- [x] `supabase/functions/fetch_events/index.ts` — Edge Function: Google Places → events table
  - קולטת: city, vibe, lat, lng, radius
  - מסננת: rating >= 4.0, מחשבת score
  - upsert ל-events, מחזירה top 5
  - cache check: אם עיר+vibe טריים (< שבוע) → מ-DB בלבד
- [ ] Google Places API Key — להגדיר ב-Google Cloud Console
- [ ] `supabase secrets set GOOGLE_PLACES_KEY=...` — לאחר קבלת המפתח
- [ ] `supabase link --project-ref <REF>` + `supabase functions deploy fetch_events`
- [ ] SQL ב-Supabase: הוסף עמודות `type` ו-`event_date` לטבלת `events`
- [ ] SQL ב-Supabase: `UNIQUE constraint` על `google_place_id` בטבלת `events`

## Phase 4 — Discovery UX (הבא)
- [ ] מסך תוצאות — Date Cards (4-5 הצעות) אחרי לחיצה על vibe
- [ ] Spinner "מחפש בילויים ב[עיר]..." כשעיר חדשה (first-tap)
- [ ] Shuffle logic (עד 5 פעמים, מה-DB בלבד)
- [ ] Freshness Check — ping ל-4-5 venues לפני הצגה
- [ ] "תפתיע אותנו" — vibe רנדומלי + event רנדומלי + אנימציה

## Phase 5 — סריקה לילית
- [ ] Edge Function: `nightly_maintenance` — מחיקת events שחלפו + רענון Google Places
- [ ] Edge Function: `fetch_events_eventbrite` — Eventbrite API
- [ ] Edge Function: `fetch_events_bandsintown` — הופעות מוזיקה
- [ ] Scraping: comy, 2207, ticketmaster, toMix (Deno fetch + HTML parse)
- [ ] pg_cron: `SELECT cron.schedule('nightly', '0 2 * * *', ...)`

## Phase 6 — סנכרון קבוצתי
- [ ] קישור חבר/פרטנר מכפתור בבית (invite code)
- [ ] Real-time Group Sync (Supabase Realtime)
- [ ] Push Notifications (FCM)
- [ ] Pivot flow

## Phase 7 — פינישינג
- [ ] Post-date Feedback widget
- [ ] History screen
- [ ] Nudges אוטומטיים (Weekend Booster, Deadline Keeper)

---

## ארכיטקטורה — החלטות מפתח
- **קהל יעד**: כל קבוצה — זוג / חברים / משפחה (לא רק זוגות)
- **קישור**: invite code גמיש — לא couple_id קבוע מ-onboarding
- **מצב הפתעה**: כפתור "תפתיע אותנו!" לסשן בלבד
- **מגדר**: enum עם value (1=זכר, 2=נקבה, 3=אחר). "אחר" → טקסט זכר. נשמר ב-DB
- **Vibe קטגוריות**: רגוע / אוכל / טבע / אתגרי / קומי / חיי לילה
- **Auth**: Google ראשי + OTP גיבוי. אין הבדל signup/login
- **events.type**: `place` (לא נמחק) | `event` (נמחק יום אחרי event_date)
- **Data sources**: Google Places (on-demand) + Eventbrite/Bandsintown/scrapers (לילי)
- **Edge Functions**: כל קריאת API חיצונית עוברת דרכן — המפתחות לעולם לא ב-Flutter
- **Score formula**: `(google_rating × 0.4) + (vibe_match × 0.4) + (distance × 0.2)`

## SQL שצריך להריץ ב-Supabase
```sql
-- events table additions
ALTER TABLE events ADD COLUMN IF NOT EXISTS type text DEFAULT 'place';
ALTER TABLE events ADD COLUMN IF NOT EXISTS event_date date;
ALTER TABLE events ADD CONSTRAINT IF NOT EXISTS events_google_place_id_key UNIQUE (google_place_id);
```

## משימות עתידיות (לא דחוף)
- [ ] Certificate Pinning מול Supabase
- [ ] Code Obfuscation לפני עלייה לחנות
- [ ] RLS על כל הטבלאות

---

> עדכן קובץ זה בסיום כל משימה.
