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

## Phase 2 — Auth ✅
- [x] Supabase Auth + Magic Link (`presentation/auth/screens/login_screen.dart`)
- [x] OTP verification (`presentation/auth/screens/otp_screen.dart`)
- [x] Riverpod providers: `isAuthenticatedProvider`, `profileExistsProvider`, `vibeProfileCompleteProvider`, `isCoupleLinkedProvider`
- [x] קישור זוגי — create + join couple (`presentation/onboarding/screens/couple_link_screen.dart`)
- [x] טבלאות Supabase: `profiles`, `couples`, `preferences` (מוגדרות ב-spec, ממומשות ב-repositories)
- [x] Splash Screen — native + Flutter (fade-in animation, ממתין לכל ה-gates)
- [x] Routing gates: `_ProfileGate` → `_VibeGate` → `_CoupleGate`

## Phase 3 — Onboarding ✅ (חלקי)
- [x] User Profile screen — שם, איזור, רדיוס, העדפות אוכל, Surprise Mode (`presentation/onboarding/screens/user_profile_screen.dart`)
- [x] Hang Profile screen — בחירת 14 פעילויות אהובות (`presentation/onboarding/screens/hang_profile_screen.dart`)
- [x] Vibe entity + מיפוי hang→vibe (`domain/entities/vibe.dart`)
- [x] מסך בחירת Vibe ראשי — 6 קטגוריות בגריד (`presentation/home/screens/vibe_selection_screen.dart`)
- [ ] Discovery screen — Date Cards (4-5 הצעות לפי vibe שנבחר)
- [ ] Shuffle logic (עד 5 פעמים)
- [ ] Freshness Check (Google Places via Supabase Edge Function)

## Phase 4 — סנכרון זוגי
- [ ] Real-time Partner Sync (Supabase Realtime)
- [ ] Push Notifications (FCM)
- [ ] Pivot flow

## Phase 5 — פינישינג
- [ ] Post-date Feedback widget
- [ ] History screen
- [ ] Nudges אוטומטיים (Weekend Booster, Deadline Keeper)

---

## משימות עתידיות (לא דחוף)
- [ ] מחיקה אוטומטית של משתמשים שלא השלימו רישום — דורש Supabase Pro או Edge Function + pg_cron
- [ ] Certificate Pinning מול Supabase
- [ ] Code Obfuscation לפני עלייה לחנות

---

> עדכן קובץ זה בסיום כל משימה.
