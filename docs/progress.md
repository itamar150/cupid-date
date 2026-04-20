# Cupid Date — Progress Tracker

## תשתית ומסמכים
- [x] `docs/spec.md` — אפיון מלא
- [x] `docs/instructions.md` — מצפן מוצר
- [x] `docs/design_system.md` — Design System מלא
- [x] `CLAUDE.md` — סטנדרטים טכניים + Self-QA Checklist

## סביבת פיתוח
- [x] Flutter SDK מותקן (3.41.7)
- [x] Android Studio מותקן
- [x] Android toolchain מוגדר
- [x] אמולטור Pixel 8 מוגדר
- [x] פרויקט Flutter נוצר (`app/`)
- [x] `pubspec.yaml` — כל ה-dependencies
- [x] מבנה תיקיות Clean Architecture (`core/`, `data/`, `domain/`, `presentation/`)

## Backend
- [x] Supabase — פרויקט נוצר, URL + anon key בידינו
- [x] Firebase — פרויקט נוצר, `google-services.json` + `firebase_options.dart` מוגדרים

## אבטחה
- [x] `firebase_options.dart` ב-`.gitignore`
- [x] `google-services.json` ב-`.gitignore`
- [ ] RLS מוגדר על טבלאות Supabase

---

## Phase 1 — Design System בקוד ✅
- [x] `core/theme/app_colors.dart`
- [x] `core/theme/app_typography.dart`
- [x] `core/theme/app_spacing.dart`
- [x] `core/theme/app_radius.dart`
- [x] `core/theme/app_theme.dart`
- [x] `core/widgets/app_button.dart`
- [x] `core/widgets/date_card.dart`
- [x] `core/widgets/vibe_chip.dart`
- [x] `core/widgets/feedback_widget.dart`

## Phase 2 — Auth
- [ ] Supabase Auth + Magic Link
- [ ] קישור זוגי (couple code)
- [ ] טבלאות Supabase: `profiles`, `couples`, `preferences`

## Phase 3 — Discovery
- [ ] Onboarding + Vibe Profile swipes
- [ ] Discovery screen + Date Cards
- [ ] Shuffle logic (עד 5 פעמים)
- [ ] Freshness Check (Google Places)

## Phase 4 — סנכרון זוגי
- [ ] Real-time Partner Sync (Supabase Realtime)
- [ ] Push Notifications (FCM)
- [ ] Pivot flow

## Phase 5 — פינישינג
- [ ] Post-date Feedback widget
- [ ] History screen
- [ ] Nudges אוטומטיים (Weekend Booster, Deadline Keeper)

---

> עדכן קובץ זה בסיום כל משימה.
