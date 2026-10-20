# Deployment Strategy

Firebase deployment reference shared by both store tracks. The Play
Console track is `PLAY_STORE_DEPLOYMENT.md`, the App Store track is
`APP_STORE_DEPLOYMENT.md`, and the release build commands live in the
`Makefile` (`make release-android`, `make release-ios`). Nothing about
the stores is restated here.

---

## Table of Contents

1. [Firebase Environments](#firebase-environments)
2. [Deploy Commands](#deploy-commands)
3. [Legal Pages (Firebase Hosting)](#legal-pages-firebase-hosting)
4. [Firebase Emulator Suite](#firebase-emulator-suite)

---

## Firebase Environments

Project aliases are configured in `.firebaserc`:

| Alias     | Project ID   | Purpose                    |
|-----------|--------------|----------------------------|
| `dev`     | `seed-dev`   | Development & alpha testing |
| `prod`    | `seed-3d48d` | Production                 |

Use `--project <alias>` with any Firebase CLI command to target the right environment.

> `seed-dev` has not been created; only `seed-3d48d` exists in the
> account. Every `--project dev` command fails until it is. Creating it
> means duplicating from prod: Auth providers, Firestore rules and
> indexes, Cloud Functions, the seeded read-only collections, FCM, and
> `flutterfire configure --project=seed-dev --out=lib/firebase_options_dev.dart`.

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

## Legal Pages (Firebase Hosting)

The privacy policy, terms of service and account-deletion page are
served from Firebase Hosting on the prod project. Both store listings
point at these URLs, and Google Play requires the deletion URL.

| Page | URL |
|------|-----|
| Privacy policy | https://seed-3d48d.web.app/privacy |
| Terms of service | https://seed-3d48d.web.app/terms |
| Account deletion | https://seed-3d48d.web.app/delete-account |

The HTML in `public/` is generated from the in-app text in
`legal_content.dart`, so the app and the hosted pages never diverge.
After editing that file, rebuild and redeploy:

```bash
python3 scripts/legal/build_legal_pages.py
npm run firebase -- deploy --only hosting --project prod
```

Preview locally with `npm run firebase -- emulators:start --only hosting`.
Plain static servers do not honour the `cleanUrls` setting in
`firebase.json`, so `/privacy` returns 404 on them.

---

## Firebase Emulator Suite

Local development uses the Firebase Emulator Suite to avoid hitting
cloud projects. Emulator ports are configured in `firebase.json`:

| Service    | Port |
|------------|------|
| Auth       | 9099 |
| Firestore  | 8080 |
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

This connects Auth and Firestore to the local emulators (`main.dart`
checks the `USE_EMULATOR` flag). The host is `10.0.2.2` on Android
emulators and `localhost` elsewhere; for a physical device, use the
machine's LAN IP.

### Emulator host by device type

| Device            | Host        |
|-------------------|-------------|
| Android emulator  | `10.0.2.2`  |
| iOS simulator     | `localhost`  |
| Physical device   | Machine's LAN IP |
