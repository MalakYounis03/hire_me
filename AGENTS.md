# AGENTS.md — HireMe

## Developer Commands

```bash
flutter pub get          # Install dependencies
flutter analyze          # Lint (uses flutter_lints, no custom rules)
flutter test             # Run all tests
flutter test test/<file> # Run a single test file
flutter run              # Run on connected device/emulator
flutter build apk --release  # Build release APK
```

## Setup

- Requires Flutter SDK ^3.11.0 / Dart SDK ^3.11.0
- A `.env` file at project root is **required** before running:
  ```
  SUPABASE_URL=...
  SUPABASE_ANON_KEY=...
  ```
- Firebase configured via `flutterfire configure --project=hireme-a59e6` (generates `lib/firebase_options.dart`)
- `google-services.json` lives at `android/app/google-services.json`

## Architecture

- **State management & routing:** GetX (`GetMaterialApp`, `GetPage`, bindings, controllers)
- **Entry point:** `lib/main.dart` — loads `.env`, initializes Firebase + Supabase in parallel (`Future.wait`), registers `StorageService` as permanent GetX service
- **Feature-first modular structure:** `lib/app/modules/{auth, company, job_seeker, main_wrapper, profile}/`
  - Each feature has `bindings/`, `controllers/`, `views/` subdirectories
- **Routing:** `lib/app/routes/app_pages.dart` (defines all GetPage entries) + `app_routes.dart` (route string constants as `part`)
- **Role guard:** `lib/app/middleware/role_guard_middleware.dart` — all protected routes use `RoleGuardMiddleware`. Mismatched role redirects to the other role's wrapper (`Routes.MAIN_WRAPPER` or `Routes.COMPANY_MAIN_WRAPPER`)
- **Session persistence:** `lib/app/services/storage_service.dart` — GetX permanent service backed by `SharedPreferences`. Stores role, userId, tokens. Normalizes roles: `jobseeker`, `job seeker`, `job_seeker` all map to `job_seeker`
- **Shared layer:** `lib/core/models/`, `lib/core/utils/`, `lib/core/widgets/`
- **Asset constants:** `lib/core/utils/app_assets.dart` — auto-generated class for `assets/images/`

## Backend

- **Firebase:** Auth, Firestore, Storage, Realtime Database
- **Supabase:** Initialized from `.env` credentials, used alongside Firebase
- Auth sessions are persisted locally via `StorageService` (not Firebase state alone)

## CI/CD (`.github/workflows/flutter.yml`)

- Triggers on push/PR to `main`
- Uses Flutter **3.41.6** stable, Java 17
- Pipeline: `pub get` → `flutter analyze --no-fatal-infos --no-fatal-warnings` → `flutter test --no-pub` → `flutter build apk --release` → Firebase App Distribution
- `.env` is generated from GitHub secrets (`SUPABASE_URL`, `SUPABASE_ANON_KEY`)

## Testing

- Tests live in `/test/`. Current tests use local fakes, not Firebase mocks — no Firebase initialization needed for unit tests
- `widget_test.dart` is a placeholder
- Run: `flutter test` or `flutter test test/auth_login_controller_test.dart`

## Asset & Font Conventions

- Images: `assets/images/` (referenced via generated `Assets` class in `app_assets.dart`)
- Fonts: Poppins, Inter, Montserrat, Roboto, Segoe.UI (defined in `pubspec.yaml`)
- `.env` is declared as a Flutter asset — do not remove from `pubspec.yaml`

## Skills
- skills/flutter-code-review/SKILL.md — run when task is done
- skills/flutter-pr/SKILL.md — run when creating a PR  
- skills/flutter-getx-controller/SKILL.md — run when creating a new screen