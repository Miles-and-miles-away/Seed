# Play Store Deployment

**Created:** 2026-09-13
**Status:** Pre-launch. No build has been uploaded. Developer account
verified, no app created in Play Console yet.
**Purpose:** The Google Play release track: identifiers that cannot
change, the production access gate, the Console declarations, and the
order to do them in.
**Companion docs:** `DEPLOYMENT_STRATEGY.md` holds Firebase
environments, deploy commands, the emulator suite, and Firebase App
Distribution for alpha builds. `SETUP_ANDROID.md` holds local
toolchain setup. Neither is restated here.

**Not here:** App Store Connect and the iOS release path, which has
its own gate and its own review rules.

---

## Table of Contents

1. [Application ID](#application-id)
2. [Production access gate](#production-access-gate)
3. [Target audience and Families policy](#target-audience-and-families-policy)
4. [App access and the review account](#app-access-and-the-review-account)
5. [Console declarations](#console-declarations)
6. [Build and signing](#build-and-signing)
7. [Order of operations](#order-of-operations)
8. [Open decisions](#open-decisions)

---

## Application ID

`com.seedahabit.app`, carried in five places:

- `android/app/build.gradle.kts`, as both `namespace` and
  `applicationId`
- `android/app/src/main/kotlin/com/seedahabit/app/MainActivity.kt`
- `ios/Runner.xcodeproj/project.pbxproj`, as
  `PRODUCT_BUNDLE_IDENTIFIER` for Runner and RunnerTests
- `ios/Runner/Info.plist`, indirectly: `CFBundleURLSchemes` holds the
  reversed iOS OAuth client ID. Firebase issues a new iOS client when
  the iOS app is re-registered, so this scheme must be replaced or
  Google sign-in on iOS fails without an error.
- the Firebase Android and iOS app registrations, which generate
  `google-services.json`, `GoogleService-Info.plist` and
  `lib/firebase_options.dart` (all three gitignored)

The web client ID in `auth_remote_datasource.dart` is project-level
and does not change.

**This is permanent from the first upload.** Play cannot rename a
published app. Changing it means a new listing that starts at zero
installs, zero reviews, and no update path for existing users.

Renamed from `com.seedapp` on 2026-09-13, before any upload, so the
old identifier has no history to preserve. Firebase still holds only
the `com.seedapp` apps, and they carry the SHA fingerprints, OAuth
clients and App Check registration. Delete them only after the new
apps exist, are configured, and a build has signed in through them.

---

## Production access gate

The developer account is a **personal** account created after
13 November 2023. Production is locked until a closed test has run
with:

- at least **12 testers** enrolled, and
- those testers **opted in continuously for 14 days**

A tester who opts out and back in restarts their own 14 days, so the
count is 12 testers each with an unbroken 14-day run, not 12 sign-ups
at any point. "Apply for production" then appears on the Console
dashboard and opens a three-part form on the testing process, the app,
and production readiness.

Recruiting 12 real testers is the critical path, not the build. It
starts before the first upload, not after.

---

## Target audience and Families policy

Declaring an audience that includes under-13s puts Seed under the
Families policy. That is not a checkbox; it attaches these:

- **Every SDK must be approved for primarily child-directed
  services.** Seed ships Firebase Auth, Firestore, Storage, Analytics,
  Crashlytics, Performance, Messaging and App Check.
- **No Android Advertising ID transmission**, along with SIM serial,
  build serial, BSSID, MAC, IMSI and IMEI. The Firebase SDK collects
  AAID by default, so this requires explicit disabling and a switch to
  app set ID.
- **No precise location** from a child-only app.
- **Neutral age screening** if the audience is mixed rather than
  child-only, gating the unapproved SDKs behind it.
- **Content rating, target audience and Data safety must all agree**,
  and stay in agreement across updates.

The harder constraint is upstream of Play. Seed collects an **email
address and display name at signup** (`auth_repository.dart` exposes
email, Google and Apple sign-in, with no anonymous path). Collecting
personal information from a child under 13 requires **verifiable
parental consent** under COPPA. That is a consent flow to design,
build and operate, not a declaration.

**Recommendation: declare 13+ and do not opt into Families.** Seed's
content is habit tracking, CO2 calculators and SDG education, which
carries fine at 13+. Opting in buys a younger audience at the cost of
a parental consent system, an SDK audit, and a permanently tighter
review surface. See D1.

---

## App access and the review account

Seed is fully login-gated. There is no anonymous or guest path, so a
reviewer who opens the app sees only a sign-in screen and the review
fails.

Required: a permanent review account entered under **App access** in
the Console, with seeded activity so the reviewer can see logged
actions, a levelled mascot and populated progress screens rather than
an empty first-run state. It must not expire, and its credentials must
be updated in the Console if they ever rotate.

The account must be **email-verified** before it is entered. The
router sends unverified password users to the verification screen and
nowhere else, so an unverified review account is a dead end.

---

## Console declarations

- [ ] **Data safety.** One list, matched against the privacy policy
      in `legal_content.dart` and the iOS `PrivacyInfo.xcprivacy`:
      email address, display name, Firebase user ID, action history
      and custom action text (user content), FCM token (device ID),
      analytics and crash diagnostics. Analytics is **optional**
      collection because the settings toggle can turn it off. Include
      the IP-derived approximate location that Analytics reports,
      which is easy to miss.
- [ ] **Advertising ID.** Answer "no". firebase_analytics pulls in
      `com.google.android.gms.permission.AD_ID` and two ADSERVICES
      permissions; `AndroidManifest.xml` strips all three with
      `tools:node="remove"` and turns off Analytics ad ID collection.
      Confirm on every upload that the merged manifest still lacks
      them. See D2.
- [ ] **Privacy policy URL.** https://seed-3d48d.web.app/privacy,
      built from `public/privacy.html`.
- [ ] **Account deletion URL.** https://seed-3d48d.web.app/delete-account,
      built from `public/delete-account.html`. Backed by the
      `deleteUserAccount` callable, which removes subcollections and
      the Auth user server-side.
- [ ] **Content rating questionnaire.**
- [ ] **Target audience and content.** See D1 before answering.
- [ ] **Ads declaration.** Seed serves no ads.
- [ ] **News app declaration.** Seed is not a news app.
- [ ] **Store listing.** Title, short and full description, feature
      graphic, screenshots per form factor, app icon.

The in-app policy text these must match lives in
`lib/features/settings/data/legal_content.dart` and is hosted by
`scripts/legal/build_legal_pages.py`. The Console answers are a second
statement of the same facts, so they are the most likely place for a
contradiction to appear.

---

## Build and signing

```bash
flutter build appbundle --release --obfuscate \
  --split-debug-info=build/debug-info
```

SDK levels come from Flutter's defaults: minSdk 24, targetSdk 36,
compileSdk 36. Nothing in the repo pins them.

Play App Signing holds the release key. The **upload** keystore is
local, configured through `android/key.properties`, which is
gitignored and exists on one machine. Back it up somewhere that
survives that machine. Losing it without a backup means an upload key
reset request to Play support, which is recoverable but slow.

Because Google re-signs the bundle, the installed app carries the
**Play App Signing certificate**, not the upload key. Google sign-in
and App Check verify that certificate. After the first upload, copy its
SHA-1 and SHA-256 from Play Console (Test and release > App integrity)
into Firebase project settings and App Check, then re-download
`google-services.json`. Skipping this is the usual cause of sign-in
failing only on Play-installed builds.

`--split-debug-info` writes the Dart symbols to `build/debug-info`.
Crashlytics cannot symbolicate Dart stack traces until they are
uploaded; the Gradle plugin handles the R8 mapping only:

```bash
npm run firebase -- crashlytics:symbols:upload \
  --app=<android app id> build/debug-info
```

`pubspec.yaml` carries `version: 1.0.0+1`. The `+N` build number must
increase on every upload; Play rejects a reused one.

---

## Order of operations

1. Merge the rename branch so every checkout carries
   `com.seedahabit.app`. A config for the new package breaks builds on
   any branch still at `com.seedapp`.
2. Create the Firebase Android and iOS apps for `com.seedahabit.app`,
   add the debug and release SHA-1 and SHA-256 fingerprints, run
   `flutterfire configure`, and replace the URL scheme in
   `ios/Runner/Info.plist` with the new reversed client ID. Android
   builds fail until this is done, because the Google Services Gradle
   plugin rejects a `google-services.json` whose package name disagrees
   with `applicationId`.
3. Register the new package for App Check Play Integrity, and the new
   bundle ID for DeviceCheck.
4. Sign in with email, Google and Apple from a debug build, then
   delete the `com.seedapp` apps in Firebase.
5. Decide D2 and, if removing the advertising ID, land the manifest
   change before the first upload.
6. Create the app in Play Console. Answer D1 first, since target
   audience drives the content rating and Data safety answers.
7. Create, verify and seed the review account.
8. Complete the Console declarations above.
9. Build the signed app bundle, upload the Dart symbols, upload the
   bundle to closed testing.
10. Add the Play App Signing SHA-1 and SHA-256 to Firebase and App
    Check, re-download `google-services.json`, and confirm Google
    sign-in from the Play-installed build.
11. Recruit 12 testers and hold them for 14 unbroken days.
12. Apply for production.

---

## Open decisions

**D1. Target audience: 13+ or Families.** Open as of 2026-09-13.
Recommendation is 13+, on the grounds that under-13 collection of
email and display name triggers COPPA verifiable parental consent,
which Seed has no flow for. Revisit only with a deliberate decision to
build that flow. The answer here is not permanent the way the
application ID is, but changing it later re-opens the content rating
and Data safety answers and can trigger re-review.

**D2. Advertising ID: removed.** Decided. Seed serves no ads and
nothing reads the identifier, so the permission is stripped in
`AndroidManifest.xml` and Analytics ad ID collection is disabled. This
also satisfies the Families rule on AAID should D1 include children.
The rejected alternative was declaring it as collected under Device or
other IDs, which is honest but describes collection with no purpose.
