# CLAUDE.md — Technical Standards for Cupid Date

## Session Start Protocol
At the beginning of every session, read:
1. `docs/spec.md` — full product specification
2. `docs/instructions.md` — product compass and core logic

---

## Architecture: Clean Architecture

Strict three-layer separation. Business logic never touches Flutter widgets.

```
lib/
├── data/               # Supabase clients, Google Places API, FCM, DTOs, mappers
├── domain/             # Entities, use cases, repository interfaces, Result types
└── presentation/       # Flutter widgets, screens, Riverpod providers (UI state only)
```

**Rules:**
- `domain/` has zero Flutter/Supabase imports — pure Dart only
- `data/` implements domain interfaces; never called directly from `presentation/`
- `presentation/` only calls use cases via Riverpod providers

---

## State Management: Riverpod

Use **Riverpod** exclusively and consistently across the entire app.

- Async data → `AsyncNotifierProvider` / `FutureProvider`
- Real-time streams (Supabase Realtime) → `StreamProvider`
- UI state → `NotifierProvider`
- No `setState` outside of truly local, ephemeral widget state (e.g., animation controllers)

---

## Code Quality

### Linting
- Use `very_good_analysis` package — strictest Flutter linting ruleset
- Configure in `analysis_options.yaml` at project root
- Zero warnings policy: all analysis warnings must be resolved before task completion

### SOLID & DRY
- Single Responsibility: one class, one reason to change
- Extract shared logic immediately — three similar code blocks → one function
- Prefer composition over inheritance

### Naming
- Self-documenting names: `fetchNearbyVenuesByVibe`, not `getData`
- No abbreviations except universally understood ones (`id`, `url`, `fcm`)
- Booleans: `isSurpriseMode`, `hasConfirmedDate`, `isLoading`

### Comments
- Write no comments unless the **why** is non-obvious
- Never document what the code already says

---

## Flutter Performance

- Mark every widget `const` wherever possible
- Use `select()` on Riverpod providers to prevent over-rebuilds
- Lists: use `ListView.builder` (never `ListView` with `.map()`)
- Images: cache with `cached_network_image`
- Avoid `setState` on large widget trees

---

## API & DB Efficiency

- **Freshness Check**: ping Google Places for **4–5 venues max** per check, never bulk
- **Shuffle**: always pull from local DB pool — zero API calls until pool exhausted
- **Batch writes**: collect multiple nudge updates → single `UPDATE` call
- Prefer Supabase RPC functions for complex multi-table logic (keeps round-trips minimal)

---

## Error Handling

- Use `Result<T, Failure>` / `Either<Failure, T>` pattern in domain layer
- Every use case returns a typed `Result` — never throws raw exceptions to UI
- UI layer handles: `loading`, `data`, `error` states for every async operation
- Network errors → user-friendly messages, never stack traces in UI
- Log errors server-side via Supabase Edge Functions where appropriate

---

## Security

### Authentication
- Auth exclusively via **Supabase Magic Link** — no passwords, no password storage
- JWT tokens managed automatically by Supabase SDK
- Refresh tokens stored in **Secure Storage** (`flutter_secure_storage`) — never in SharedPreferences

### Authorization — Row Level Security (RLS)
- **RLS on every table** — no exceptions. Default deny, explicit allow per role
- Every policy scoped to `auth.uid()` via `couple_id` — users see only their own couple's data
- `preferences`: read for both partners, write only for self (`user_id = auth.uid()`)
- `events`: public read (no personal data), no client writes
- `date_sessions`, `history`, `nudges`: read/write for both partners of the couple only

### Secrets Management
- **Google Places API key**: never in Flutter code. All Places calls go through a **Supabase Edge Function** — the key lives only on the server
- **FCM Server key**: only in Supabase Edge Functions — Flutter never sends push notifications directly
- **Supabase service role key**: never in Flutter code — Edge Functions only
- No `.env` files committed to git (add to `.gitignore`)

### Mobile App Hardening
- Enable **code obfuscation** on production builds: `flutter build apk --obfuscate --split-debug-info=...`
- Enable **certificate pinning** against the Supabase project URL
- Never log sensitive user data (couple_id, email, tokens) to console in production

---

## Self-QA Checklist (run after every task)

Before marking a task complete, verify:

1. **Duplication** — Is there repeated logic that should be extracted into a shared function or class?
2. **DB/API efficiency** — Are there unnecessary database queries or Google Places calls that can be eliminated?
3. **Flutter standards** — Do widgets use `const`, avoid unnecessary rebuilds, and follow Flutter style guide?
4. **Layer separation** — Does any business logic leak into widgets? Does `domain/` import Flutter packages?
5. **Error states** — Does every async operation have loading/error/data handling?
6. **RLS coverage** — If a new table or policy was added, is RLS configured?
7. **Zero-Text Policy** — Is there any `TextField`, free-text input, or chat UI? If yes → remove it.
8. **Sync** — Does every widget showing shared couple state subscribe to a `StreamProvider` / Supabase Realtime channel?

**Definition of Done:** all 8 checks pass before moving to the next task.
