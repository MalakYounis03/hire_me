# AGENTS.md — HireMe

## Required Workflow

Read the relevant skill from `hireme_skills/` **before** writing any code.

| When | Skill |
|------|-------|
| Before any new controller or feature screen | `flutter-getx-controller` |
| Before touching backend, routing, notifications, chat, auth, or uploads | `hireme-architecture` |
| Before writing or editing any test | `hireme-testing` |
| After completing work, before marking done | `flutter-code-review` |
| Before committing or opening a PR | `flutter-pr` |

## Commands

### Development

```bash
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings   # exact flags — must match CI
flutter test --no-pub                                  # matches CI; omit --no-pub locally if needed
flutter run
flutter build apk --release
```

### Deploy

Run from **project root** only.

```bash
firebase deploy --only database          # after editing database.rules.json
firebase deploy --only functions         # after editing functions/index.js
firebase deploy --only firestore:indexes # after adding new indexes
```

CI: `pub get` → `analyze` → `test --no-pub` → `build apk --release` → Firebase App Distribution. Flutter `3.41.6`, Java 17.

## Entrypoint (`lib/main.dart`)

`dotenv.load` → `Firebase.initializeApp` + `Supabase.initialize` (parallel, with `Firebase.apps.isEmpty` guard) → `Get.putAsync(StorageService)` → `Get.putAsync(NotificationService)` → `runApp`.