# Deployment Strategy

**Version:** 1.0
**Created:** March 2026
**Status:** In Progress

---

## Table of Contents

1. [Firebase Environments](#firebase-environments)
2. [Deploy Commands](#deploy-commands)
3. [Firebase Emulator Suite](#firebase-emulator-suite)
4. [Firebase Performance Monitoring](#firebase-performance-monitoring)
5. [Analytics Navigation Tracking](#analytics-navigation-tracking)
6. [Alpha Testing Distribution](#alpha-testing-distribution)
7. [Environment Setup Checklist](#environment-setup-checklist)

---

## Firebase Environments

Project aliases are configured in `.firebaserc`:

| Alias     | Project ID   | Purpose                    |
|-----------|--------------|----------------------------|
| `dev`     | `seed-dev`   | Development & alpha testing |
| `prod`    | `seed-3d48d` | Production                 |

Use `--project <alias>` with any Firebase CLI command to target the right environment.

> `seed-dev` has not been created yet (checked 2026-09-05: only
> `seed-3d48d` exists in the account). Every `--project dev` command
> below fails until the Environment Setup Checklist is completed.

---

## Deploy Commands

```bash
# Deploy everything to dev
npm run firebase -- deploy --project dev

# Deploy everything to prod
npm run firebase -- deploy --project prod

# Deploy specific services
npm run firebase -- deploy --only firestore:rules --project dev
npm run firebase -- deploy --only functions --project prod
npm run firebase -- deploy --only firestore:indexes --project dev
```

---

## Firebase Emulator Suite

Local development uses the Firebase Emulator Suite to avoid hitting
cloud projects. Emulator ports are configured in `firebase.json`:

| Service    | Port |
|------------|------|
| Auth       | 9099 |
| Firestore  | 8080 |
| Storage    | 9199 |
| Emulator UI| 4000 |

### Starting the emulators

```bash
npm run firebase -- emulators:start
```

The Emulator UI is available at `http://localhost:4000`.

### Running the app with emulators

```bash
flutter run --dart-define=USE_EMULATOR=true
```

This connects Auth, Firestore, and Storage to the local emulators
(`main.dart` checks the `USE_EMULATOR` flag). The default emulator
host is `10.0.2.2` (Android emulator loopback). For iOS simulator
or physical devices, update the host in `main.dart`.

### Emulator host by device type

| Device            | Host        |
|-------------------|-------------|
| Android emulator  | `10.0.2.2`  |
| iOS simulator     | `localhost`  |
| Physical device   | Machine's LAN IP |

---

## Firebase Performance Monitoring

`firebase_performance` is included as a dependency and initialized in
`main.dart`. Performance collection is disabled in debug mode to avoid
noise.

Firebase Performance automatically tracks:
- App startup time
- HTTP request latency (for supported clients)
- Screen rendering performance

Custom traces can be added for specific operations:

```dart
final trace = FirebasePerformance.instance.newTrace('my_operation');
await trace.start();
// ... perform operation ...
await trace.stop();
```

---

## Analytics Navigation Tracking

`FirebaseAnalyticsObserver` is wired into GoRouter (`router.dart`)
to automatically track screen views as users navigate. This works
alongside the existing manual `logScreenView()` calls and custom
events in `AnalyticsService`.

---

## Alpha Testing Distribution

Firebase App Distribution is the recommended approach for sharing
builds with testers.

### Android

```bash
# Build release APK
flutter build apk --release

# Distribute via Firebase App Distribution
npm run firebase -- appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app <FIREBASE_APP_ID> \
  --groups "alpha-testers" \
  --project dev
```

### iOS

```bash
# Build release IPA
flutter build ipa --release

# Distribute via Firebase App Distribution
npm run firebase -- appdistribution:distribute \
  build/ios/ipa/seed_app.ipa \
  --app <FIREBASE_APP_ID> \
  --groups "alpha-testers" \
  --project dev
```

Testers receive an email invite and install builds via the Firebase
App Tester app.

---

## Environment Setup Checklist

When setting up the dev Firebase project, duplicate the following
from prod:

- [ ] Create `seed-dev` project in Firebase Console
- [ ] Update `.firebaserc` with actual dev project ID
- [ ] Enable Auth providers (Google, Apple Sign-In)
- [ ] Deploy Firestore security rules (`--only firestore:rules`)
- [ ] Deploy Firestore indexes (`--only firestore:indexes`)
- [ ] Deploy Cloud Functions (`--only functions`)
- [ ] Seed read-only collections (`actionLibrary`, `mascotSpecies`, `cosmeticItems`)
- [ ] Configure FCM for dev
- [ ] Run `flutterfire configure --project=seed-dev --out=lib/firebase_options_dev.dart`
- [ ] Set up Firebase App Distribution tester groups
