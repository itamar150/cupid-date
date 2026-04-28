# אפיון מעודכן - Hangly

## 1. הגדרת על (Mission)
אפליקציית Mobile (Native) ב-Flutter המיועדת לזוגות, שמטרתה להפוך את תהליך בחירת הבילוי הזוגי לאוטומטי, מהיר ונטול חיכוך. המערכת מבוססת על אינטראקציות של קליקים בלבד, ללא צ'אט.

---

## 2. Onboarding וקישור זוגי

- **כניסה:** Magic Link (ללא סיסמאות) - 
משתמש ראשון יתחבר עם מייל או GMAIL
- **קישור זוגי:** משתמש א' יוצר קבוצה ומקבל קוד ייחודי → משתמש ב' מזין קוד → מקושרים ל-Couple_ID משותף.
משתמש ב' יתחבר עם הקוד ויעבור ישר למסך שך Red Lines
- **Red Lines (per-user):** שם פרטי, שם משפחה, איזור מגורים, רדיוס מקסימלי, העדפות תזונה
- **הצלבת נתונים:** המערכת לוקחת את הערך המחמיר מבין שני הפרטנרים
- **Vibe Profile:** Swipe על תמונות סגנונות בילוי לבניית פרופיל ראשוני
- **Surprise Mode:** opt-in/opt-out בשלב ה-Onboarding (ברירת מחדל: פעיל)

---

## 2.5 Hang Profile — מיפוי לקטגוריות Vibe

המשתמש בוחר פעילויות אהובות ב-Onboarding. אלה נשמרות ב-`preferences.vibe_profile` ומשמשות לדירוג תוצאות.

### קטגוריות Vibe (6)
| קטגוריה | emoji | תיאור |
|---|---|---|
| רגוע (calm) | 🧘 | פעילויות שקטות ומרגיעות |
| אוכל (food) | 🍽️ | חוויות אוכל ושתייה |
| טבע (nature) | 🌿 | חוצות ואוויר פתוח |
| אתגרי (adventure) | 🧗 | פעילות פיזית ואתגר |
| מצחיק (funny) | 😂 | בידור והומור |
| רועש (loud) | 🎉 | מוזיקה, ריקוד, אנרגיה |

### מיפוי hang → vibe
| פעילות | קטגוריות |
|---|---|
| טיול | טבע |
| מסעדה / קפה | אוכל |
| ספא | רגוע |
| הופעות | רועש |
| קולנוע | רגוע |
| טיפוס קיר | אתגרי |
| ריקוד | רועש |
| סדנאות | רגוע |
| בר | אוכל, רועש |
| מוזיאון | רגוע |
| חדר בריחה | אתגרי, מצחיק |
| מסיבות | רועש |
| קמפינג | טבע |
| סטנדאפ | מצחיק |

### שימוש ב-Scoring
`vibe_match` = ציון התאמה בין ה-vibe שנבחר במסך הראשי לבין פרופיל הhangs של המשתמש.
ככל שיותר hangs מהפרופיל מתאימים ל-vibe שנבחר — הציון גבוה יותר.

---

## 3. מנוע 5 השלבים

### שלב 1: איסוף נתונים (Data Pipeline)
- סריקה אוטומטית של מקומות דרך **Google Places API**
- אימות: שעות פתיחה, דירוג 4+
- **הוסר מה-MVP:** scraping מ-TikTok/Instagram

### שלב 2: סינון ודירוג
- סינון קשיח ב-SQL מול Red Lines
- דירוג ב-**Weighted Scoring Algorithm** (ללא AI):
  `ציון = (Google Rating × 0.4) + (התאמה לvibe × 0.4) + (מרחק × 0.2)`
- שמירת X רשומות ב-DB מאורגנות per-vibe per-עיר

### שלב 3: חווית המשתמש (Discovery UX)
- המשתמש בוחר Vibe מ**רשימה קבועה** (רגוע / רועש / אקטיבי / אוכל / טבע)
- **Freshness Check:** לפני הצגה, ping ל-Google Places על 4-5 אופציות בלבד. אם מקום סגור → מוחלף מה-pool
- הצגת **4-5 אופציות** למשתמש היוזם
- **Shuffle:** עד **5 פעמים** - שולף מה-pool שב-DB (ללא קריאת API)
- לאחר 5 Shuffles: הצעה "הרחב חיפוש?" (רדיוס / תקציב)
- אם אין תוצאות בכלל: הרחבה אוטומטית של רדיוס
- **Surprise Mode:** בחירת בילוי שפרטיו נחשפים רק סמוך ליציאה (רק למשתמשים שבחרו opt-in)

### שלב 4: סנכרון זוגי
- אלכס בוחר → דנה מקבלת פוש → דנה מאשרת ✅ או Pivot 🔄
- **Pivot:** בחירת Vibe חדש מרשימה קבועה → המערכת מעדכנת 4-5 אופציות ב-Real-time (Supabase Realtime)
- **משוב:** יום אחרי הדייט - דירוג ⭐/💔 + **optional tags** (🔥 וואו / 👍 סבבה / 😐 בסדר / 👎 לא בשבילנו) שנעלמים אחרי 5 שניות אם לא נוגעים

### שלב 5: אוטומציה והתראות
- **Weekend Booster:** פוש ביום רביעי/חמישי אם אין דייט סגור
- **Deadline Keeper:** תזכורת ביום שהוגדר כדד-ליין זוגי
- **ביטול אוטומטי:** כשסטטוס הופך ל-Confirmed, כל ה-Nudges הפתוחים מתבטלים

---

## 4. ארכיטקטורה טכנולוגית

| רכיב | טכנולוגיה | הערות |
|---|---|---|
| Frontend | Flutter | iOS + Android מ-codebase אחד |
| Backend & DB | Supabase | PostgreSQL, Realtime, Edge Functions, Auth, pg_cron |
| Notifications | Firebase Cloud Messaging (FCM) | חינמי, עובד עם FlutterFire |
| AI | **הוסר מה-MVP** | יכנס בהמשך לpersonalization |

**הוסר:** Vercel (לא רלוונטי לmobile app - Supabase מכסה הכל)

---

## 5. סכמת Supabase

### profiles
```
id              uuid PRIMARY KEY references auth.users
name            text
email           text
couple_id       uuid references couples(id)
surprise_opt_in boolean DEFAULT true
created_at      timestamptz
```

### couples
```
id          uuid PRIMARY KEY
user_a_id   uuid references profiles(id)
user_b_id   uuid references profiles(id)
status      text DEFAULT 'active'
created_at  timestamptz
```

### preferences (per-user)
```
id              uuid PRIMARY KEY
user_id         uuid references profiles(id)
couple_id       uuid references couples(id)
max_radius_km   integer
dietary         text[]   -- ['kosher', 'vegan', ...]
max_budget      integer
vibe_profile    jsonb    -- תוצאת ה-onboarding swipes
updated_at      timestamptz
```

### events (pool לילי)
```
id                uuid PRIMARY KEY
google_place_id   text UNIQUE
name              text
vibe              text   -- calm / loud / active / food / nature
city              text
lat               numeric
lng               numeric
google_rating     numeric
score             numeric
opening_hours     jsonb
last_validated_at timestamptz
created_at        timestamptz
```

### date_sessions
```
id                uuid PRIMARY KEY
couple_id         uuid references couples(id)
status            text   -- choosing / pending_partner / confirmed / cancelled
vibe_selected     text
initiated_by      uuid references profiles(id)
selected_event_id uuid references events(id)
shuffle_count     integer DEFAULT 0
deadline_day      text
created_at        timestamptz
confirmed_at      timestamptz
```

### history
```
id              uuid PRIMARY KEY
couple_id       uuid references couples(id)
event_id        uuid references events(id)
date_session_id uuid references date_sessions(id)
date            date
feedback_a      text     -- 'star' / 'broken_heart'
feedback_b      text
tags_a          text[]
tags_b          text[]
created_at      timestamptz
```

### nudges
```
id             uuid PRIMARY KEY
couple_id      uuid references couples(id)
type           text   -- 'weekend_booster' / 'deadline_keeper'
scheduled_for  timestamptz
status         text DEFAULT 'pending'   -- pending / sent / cancelled
created_at     timestamptz
```

---

## 6. RLS (Row Level Security)

- **עיקרון:** כל משתמש רואה רק שורות עם ה-couple_id שלו
- **preferences:** קריאה לשני הפרטנרים (נדרש להצלבת Red Lines), כתיבה רק לעצמו
- **events:** קריאה פתוחה (אין מידע אישי)
- **שאר הטבלאות:** קריאה/כתיבה לשני בני הזוג בלבד

---

## 7. לוגיקה עסקית מרכזית

### הצלבת Red Lines
```
effective_radius  = MIN(pref_a.max_radius_km, pref_b.max_radius_km)
effective_budget  = MIN(pref_a.max_budget, pref_b.max_budget)
effective_dietary = UNION(pref_a.dietary, pref_b.dietary)
```

### Shuffle
- עד 5 shuffles → שליפה רנדומלית מה-pool ב-DB
- לאחר 5: "הרחב חיפוש?" → איפוס shuffle_count

### ביטול Nudges
```
כש date_session.status → 'confirmed':
UPDATE nudges SET status='cancelled'
WHERE couple_id = X AND status='pending'
```

---

## 8. עלויות משוערות

| שלב | משתמשים | עלות/חודש |
|---|---|---|
| MVP | 0-200 זוגות | ~$0 (Google $200 קרדיט מכסה) |
| גדילה | 1,000 זוגות | ~$50-100 |
| Scale | 10,000 זוגות | ~$500-800 |
