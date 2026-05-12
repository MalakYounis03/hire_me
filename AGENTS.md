# AGENTS.md — HireMe

## Commands

```bash
flutter pub get                                   # Install deps
flutter analyze --no-fatal-infos --no-fatal-warnings  # CI lint
flutter test                                      # All tests
flutter test test/<file>.dart                     # Single test
flutter test --no-pub                             # CI test (skips pub get)
flutter run                                       # Device/emulator
flutter build apk --release                       # Release APK
firebase deploy --only functions                  # Deploy Cloud Functions
```

CI (`flutter.yml` on main): `pub get` → `analyze` → `test --no-pub` → `build apk --release` → Firebase App Distribution. CI creates `.env` from secrets (`SUPABASE_URL`/`SUPABASE_ANON_KEY`). Flutter `3.41.6`, Java 17.

## Setup

- Dart SDK `^3.11.0`. Flutter `3.41.6` pinned in CI only.
- `.env` at project root (declared as asset, gitignored). Required: `SUPABASE_URL`, `SUPABASE_ANON_KEY`.
- `flutterfire configure --project=hireme-a59e6` generates `lib/firebase_options.dart` + `android/app/google-services.json`.
- **Do not edit:** `firebase_options.dart`, `google-services.json`, `.env`.
- Cloud Functions at `functions/` (Node 20, firebase-functions v5). Deploy from project root via `firebase.json`.

## Architecture

- **State/routing:** GetX. Import `app/routes/app_pages.dart` only — `app_routes.dart` is `part of 'app_pages.dart'`. Use `Routes.*` constants.
- **Modules:** `lib/app/modules/{auth, company, job_seeker, main_wrapper, profile}`. Each sub-feature: `bindings/`, `controllers/`, `views/`.
- **Data layer:** `lib/app/data/repositories/` (currently just `notification_repository.dart`). Models inline per-module (`model/` dirs).
- **Backend:** Firebase (Auth, Firestore, Storage, Realtime Database, Messaging) + Supabase.
- **Notifications:** FCM tokens saved to `users/{uid}` AND role-specific collection (`jobSeekers/{uid}` / `companies/{uid}`) via `SetOptions(merge: true)`. Tap routing: `application_update` → `JOB_SEEKER_NOTIFICATIONS`, `new_application` → `APPLICATION_LIST`, `chat_message` → role-based chat details.
- **RTDB chat path:** `chats/{companyId}_{jobSeekerId}` with messages at `chats/{chatId}/messages/`.

### Entrypoint (`lib/main.dart`)

```dart
main()
  // 1. FirebaseMessaging.onBackgroundMessage handler (top-level, @pragma('vm:entry-point'))
  // 2. dotenv.load('.env')
  // 3. Future.wait(Firebase.initializeApp, Supabase.initialize)
  // 4. Get.putAsync(StorageService, permanent: true)
  // 5. Get.putAsync(NotificationService, permanent: true)
  // 6. runApp(GetMaterialApp, initialRoute: Routes.SPLASH)
```

Background handler runs in a separate isolate and re-initializes Firebase.

### Session & Role Guard

- `StorageService` — GetX permanent service backed by SharedPreferences.
- `normalizeRole()` maps `jobseeker`/`job seeker`/`job_seeker` → `job_seeker`. `AppUserRole` enum `.value` yields `'company'` or `'job_seeker'`.
- `RoleGuardMiddleware` checks `FirebaseAuth.currentUser` + SharedPreferences role. Mismatch → redirect to other role's wrapper; null/unauthed → `/login`.

## Utils & Conventions

- `lib/core/utils/` is the single source of truth: `AppColor`, `CustomTextstyle`, `AppString`, `AppAssets` (auto-generated, do not edit manually). Helpers (`formatTime`, `formatDate`) at `lib/core/helper/data_helper.dart`.
- **Firestore writes:** always `SetOptions(merge: true)`.
- **Import style:** Mixed — `package:hire_me/...` and relative `../../` paths both resolve. Prefer whichever convention exists in the file you edit.
- **pubspec.lock must be committed** (no `.gitignore` entry).

## Testing

- Manual fakes only — no mockito/mocktail (not in `pubspec.yaml`). No Firebase/Supabase init needed.
- `flutter test test/<file>.dart` for single file.
- Call `Get.reset()` in `tearDown` for GetX isolation.

## Quirks

- **Broken font families:** `" Poppins"`, `" Inter"`, `" Segoe.UI"` have leading spaces in `app_text_style.dart` — won't match `Poppins`/`Inter`/`Segoe.UI` in `pubspec.yaml`.
- `Routes.COMPANY_APPLICANTS` defined in `app_routes.dart` but has **no** `GetPage` entry in `app_pages.dart`.
- `Routes.JOB_SEEKER_CONGRATULATIONS` maps to `JobSeekerApplyJobView`, not a dedicated view.
- `Routes.JOB_SEEKER_SEARCH_JOBS` has **no** `RoleGuardMiddleware` — public access.
- Unlinked modules (bindings/controllers/views exist, zero `GetPage` entries): `auth/role_selector/`, `job_seeker/Jobseekercongratulations/`.
- `pubspec.yaml` uses `package:flutter_lints/flutter.yaml` — no custom lint rules.
