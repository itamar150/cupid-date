# Cupid Date — Design System

> Source of Truth לכל החלטת UI/UX בפרויקט.
> כל widget, צבע, ומרווח מוגדר כאן — אף ערך לא מופיע hard-coded בקוד.

---

## 1. Design Tokens

### צבעים — "Tender Modern"

פלטה חמה ופרמיום. לא האדום/ורוד הקלישאתי של אפליקציות דייטינג.

| Token | Hex | שימוש |
|---|---|---|
| `primary` | `#C4556A` | Dusty Rose — צבע ראשי, branding |
| `primaryLight` | `#E8849A` | hover states, gradients, backgrounds |
| `accent` | `#F0956A` | Warm Coral — CTA buttons, highlights |
| `background` | `#FDF8F5` | רקע כללי — לבן חמים |
| `surface` | `#FFFFFF` | כרטיסים ו-sheets |
| `surfaceVariant` | `#F5EDE8` | רקע לכרטיסים משניים |
| `secondary` | `#8B7B8B` | Muted Mauve — אלמנטים משניים |
| `textPrimary` | `#1C1B1F` | טקסט ראשי |
| `textSecondary` | `#49454F` | טקסט משני, placeholders |
| `textDisabled` | `#9E9E9E` | אלמנטים לא פעילים |
| `error` | `#B00020` | שגיאות |
| `success` | `#2E7D32` | אישורים |
| `divider` | `#E8E0EC` | מפרידים |

**Dark Mode:** לא ב-MVP. מתוכנן לגרסה עתידית — ThemeExtensions תומך בהרחבה.

---

### טיפוגרפיה

פונט ראשי: **Rubik** (תומך עברית + אנגלית, עיצוב מודרני ונקי).
פונט fallback: `sans-serif`.

| Style | Size | Weight | Line Height | שימוש |
|---|---|---|---|---|
| `displayLarge` | 32sp | Bold (700) | 40sp | כותרות ראשיות מרכזיות |
| `headlineMedium` | 24sp | SemiBold (600) | 32sp | כותרות מסכים |
| `titleLarge` | 20sp | SemiBold (600) | 28sp | כותרות כרטיסים |
| `titleMedium` | 16sp | Medium (500) | 24sp | שמות venues |
| `bodyLarge` | 16sp | Regular (400) | 24sp | טקסט גוף ראשי |
| `bodyMedium` | 14sp | Regular (400) | 20sp | תיאורים, מידע משני |
| `labelLarge` | 14sp | Medium (500) | 20sp | טקסט בכפתורים |
| `labelSmall` | 11sp | Medium (500) | 16sp | tags, chips |

---

### Spacing Scale

מבוסס על grid של **4px**. כל ריווח בקוד משתמש בטוקנים האלה בלבד.

| Token | Value | שימוש טיפוסי |
|---|---|---|
| `xs` | 4px | ריווח פנימי קטן מאוד |
| `sm` | 8px | ריווח בין אלמנטים קרובים |
| `md` | 12px | padding פנימי ברכיבים |
| `lg` | 16px | padding סטנדרטי |
| `xl` | 24px | ריווח בין סקציות |
| `xxl` | 32px | ריווח גדול, headers |
| `xxxl` | 48px | ריווח בין מסכים |

---

### Border Radius

| Token | Value | שימוש |
|---|---|---|
| `small` | 8px | תגיות, chips קטנים |
| `medium` | 16px | כרטיסים (DateCard) |
| `large` | 24px | bottom sheets, modals |
| `full` | 999px | כפתורים עגולים מלאים |

---

## 2. Atomic Components

### `DateCard`
כרטיס venue מרכזי — המרכיב הויזואלי החשוב ביותר באפליקציה.

**Props:**
- `name` — שם המקום
- `vibe` — `calm / loud / active / food / nature`
- `rating` — מספר (1.0–5.0)
- `distanceKm` — מרחק בק"מ
- `imageUrl` — תמונה ראשית
- `isSurprise` — האם במצב Surprise (מסתיר פרטים)
- `onTap` — callback

**כללים:**
- גובה קבוע: 220px
- Border radius: `medium` (16px)
- תמונה: `cached_network_image`, cover fit
- כשה-`isSurprise=true`: מציג blur על התמונה + אייקון 🎁 בלבד

---

### `VibeChip`
כפתור בחירת vibe — מופיע ברשימה אופקית.

**Props:**
- `vibe` — אחד מ-5 הערכים
- `isSelected` — boolean
- `onTap` — callback

**כללים:**
- גובה מינימום: 48dp (Accessibility)
- Border radius: `small` (8px)
- צבע נבחר: `primary`, לא נבחר: `surfaceVariant`
- אייקון + תווית (עברית)

| Vibe | אייקון | תווית |
|---|---|---|
| calm | 🌿 | רגוע |
| loud | 🎉 | רועש |
| active | 🏃 | אקטיבי |
| food | 🍽️ | אוכל |
| nature | 🌄 | טבע |

---

### `AppButton`

**`PrimaryButton`:**
- רקע: `accent` (`#F0956A`)
- טקסט: לבן, `labelLarge`
- גובה מינימום: 48dp
- Border radius: `full` (999px)
- רוחב: מלא (100%)

**`SecondaryButton`:**
- רקע: שקוף, border בצבע `primary`
- טקסט: `primary`, `labelLarge`
- אותם מידות כמו Primary

**כלל:** שני הסוגים מקבלים `onPressed` ו-`label` בלבד — אפס עיצוב פנימי.

---

### `FeedbackWidget`
מופיע יום אחרי הדייט.

**Props:**
- `onStarTap` — callback
- `onBrokenHeartTap` — callback
- `onTagSelected` — callback עם tag string

**Tags (נעלמים אחרי 5 שניות):**

| Tag | תווית |
|---|---|
| `wow` | 🔥 וואו |
| `fine` | 👍 סבבה |
| `ok` | 😐 בסדר |
| `notForUs` | 👎 לא בשבילנו |

**כלל:** ה-Widget עצמו לא מנהל את ה-timer — מקבל `autoHideAfter: Duration` מבחוץ.

---

## 3. Theme Strategy

### Material 3 + ThemeData

```dart
// app_theme.dart — מרכז הכל
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: _buildColorScheme(),
    textTheme: _buildTextTheme(),
    extensions: [AppSpacing.instance, AppRadius.instance],
  );
}
```

### ThemeExtensions לטוקנים מותאמים

```dart
// app_spacing.dart
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs, sm, md, lg, xl, xxl, xxxl;
  // ...
}

// app_radius.dart
class AppRadius extends ThemeExtension<AppRadius> {
  final double small, medium, large, full;
  // ...
}
```

### חוק ברזל — 3 כללים שאסור לשבור

1. **Stateless בלבד** — כל widget ב-`core/widgets` הוא `StatelessWidget`. אפס state פנימי.
2. **Theme.of(context) בלבד** — `context.theme.colorScheme.primary`, לא `Color(0xFFC4556A)`.
3. **נתונים מבחוץ בלבד** — Widget לא שולף נתונים, לא קורא provider. מקבל הכל דרך constructor.

---

## 4. אסטרטגיית מימוש טכנית

### מבנה תיקיות מחייב

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart        ← ColorScheme + semantic colors
│   │   ├── app_typography.dart    ← TextTheme מלא עם Rubik
│   │   ├── app_spacing.dart       ← ThemeExtension spacing
│   │   ├── app_radius.dart        ← ThemeExtension radius
│   │   └── app_theme.dart         ← buildAppTheme() מרכזי
│   └── widgets/
│       ├── date_card.dart
│       ├── vibe_chip.dart
│       ├── app_button.dart
│       └── feedback_widget.dart
│
├── data/                          ← Supabase, Google Places, FCM
├── domain/                        ← Entities, Use Cases, Repositories
└── presentation/                  ← Screens + Riverpod Providers
    ├── onboarding/
    ├── discovery/
    ├── sync/
    └── history/
```

### כיצד מסך משתמש ב-Design System

```
presentation/discovery/
└── screens/
    └── discovery_screen.dart    ← משתמש ב-DateCard, VibeChip
        ↕ (props בלבד, אפס לוגיקה)
core/widgets/date_card.dart      ← widget "טיפש"
        ↕ (Theme.of(context))
core/theme/app_theme.dart        ← כל הערכים
```

---

## 5. RTL & i18n

- כל layout משתמש ב-`start/end` ולא ב-`left/right`
- `EdgeInsetsDirectional` במקום `EdgeInsets` בכל padding/margin
- `Directionality.of(context)` לכל אלמנט שצריך לדעת כיוון
- **כל טקסט** מגיע מ-`AppLocalizations` — אפס string מוטבע בקוד
- קבצי תרגום: `l10n/app_he.arb` (עברית), `l10n/app_en.arb` (מוכן לעתיד)

---

## 6. Accessibility

- כל אלמנט לחיץ: `minHeight: 48dp`, `minWidth: 48dp`
- Contrast ratio טקסט/רקע: מינימום **4.5:1** (WCAG AA)
- `Semantics` widget על כל אלמנט אינטראקטיבי
- תמיכה ב-`TalkBack` (Android) — `semanticLabel` על כל אייקון
