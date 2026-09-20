# Play Store Deployment

**Created:** 2026-09-13
**Status:** In closed testing. `0.1.1 (3)` is live on the internal
and closed tracks. Play App Signing is active and its certificate is
registered in Firebase. The 12-tester, 14-day production gate is the
only remaining blocker; see the gate section below.
**Purpose:** The Google Play release track: identifiers that cannot
change, the production access gate, the Console declarations, and the
order to do them in.
**Companion docs:** `DEPLOYMENT_STRATEGY.md` holds Firebase
environments, deploy commands, the emulator suite, and Firebase App
Distribution for alpha builds. `SETUP_ANDROID.md` holds local
toolchain setup. Neither is restated here.

**Not here:** App Store Connect and the iOS release path, which has
its own gate and its own review rules. See
`APP_STORE_DEPLOYMENT.md`.

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
old identifier had no history to preserve. The `com.seedapp` Firebase
apps were deleted on 2026-09-18 once the replacements were configured
and signing in. Firebase now holds one Android and one iOS app, both
on `com.seedahabit.app`.

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
  services.** Seed ships Firebase Auth, Firestore, Analytics,
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

**Decision: 13+ at launch, under-13 support planned.** Seed's content
is habit tracking, CO2 calculators and SDG education, and the intent is
for kids to use it eventually. Launching at 13+ keeps the closed test
unblocked; widening the audience later reopens the content rating and
Data safety answers and can trigger re-review, but nothing permanent.
D1 lists the work the later phase needs.

At 13+ the current privacy policy is correct: its Children's Privacy
section states that Seed is not directed at children under 13. It must
be rewritten in all three languages, and the hosted pages rebuilt, as
part of the under-13 phase, not before.

Play also asks whether the store listing could **unintentionally
appeal to children**. A hatching, evolving mascot is what triggers that
question, so screenshots and descriptions are aimed at teens and
adults, and the answer stays honest.

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

- [x] **Data safety.** One list, matched against the privacy policy
      in `legal_content.dart` and the iOS `PrivacyInfo.xcprivacy`:
      email address, display name, Firebase user ID, action history
      and custom action text (user content), FCM token (device ID),
      analytics and crash diagnostics. Analytics is **optional**
      collection because the settings toggle can turn it off. Include
      the IP-derived approximate location that Analytics reports,
      which is easy to miss.
- [x] **Advertising ID.** Answer "no". firebase_analytics pulls in
      `com.google.android.gms.permission.AD_ID` and two ADSERVICES
      permissions; `AndroidManifest.xml` strips all three with
      `tools:node="remove"` and turns off Analytics ad ID collection.
      Confirm on every upload that the merged manifest still lacks
      them. See D2.
- [x] **Privacy policy URL.** https://seed-3d48d.web.app/privacy,
      built from `public/privacy.html`.
- [x] **Account deletion URL.** https://seed-3d48d.web.app/delete-account,
      built from `public/delete-account.html`. Backed by the
      `deleteUserAccount` callable, which removes subcollections and
      the Auth user server-side.
- [x] **Content rating questionnaire.**
- [x] **Target audience and content.** 13+ per D1. Answer "no" to
      unintentional appeal to children and keep the listing assets
      aimed at teens and adults.
- [x] **Ads declaration.** Seed serves no ads.
- [x] **News app declaration.** Seed is not a news app.
- [x] **Store listing.** Title, short and full description, feature
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
verifies that certificate. Its SHA-1 and SHA-256 live in Play Console
under Protected with Play > Play Store protection > Manage Play App
Signing; the older Test and release > App integrity path now
redirects there. Both were added to Firebase project settings on
2026-09-18, alongside the debug and upload fingerprints.

This is worth understanding rather than following blindly, because
the obvious mental model is wrong. The certificate hashes in
`google-services.json` are **not** compiled into the app: the
google-services plugin emits only `default_web_client_id`,
`google_app_id`, `project_id`, `gcm_defaultSenderId` and
`google_api_key`. What fixes sign-in is the OAuth client that Google
creates server-side the moment the fingerprint is registered, so
registering it is sufficient and no rebuild is required. Re-download
`google-services.json` anyway to keep the local copy honest.

Symptom when the Play App Signing fingerprint is missing: sign-in
works from `flutter run` and from a sideloaded release APK, because
the debug and upload certificates are registered, and fails only on
the copy installed from Play. `google_sign_in` reports it as
"Sign-in was cancelled", which names neither the cause nor the
certificate.

`--split-debug-info` writes the Dart symbols to `build/debug-info`.
Crashlytics cannot symbolicate Dart stack traces until they are
uploaded; the Gradle plugin handles the R8 mapping only:

```bash
conda activate seed
npm run firebase -- crashlytics:symbols:upload \
  --app=1:49522523534:android:5191fb3210e7f88fadf8df build/debug-info
```

`make release-android` runs the build and this upload as one step.
The `conda activate` is load-bearing. The Crashlytics jar needs a JDK
and the `seed` env is the only one on the machine, so without it the
upload fails with an opaque "java command failed".

The `+N` build number must increase on every upload and can never be
reused, including for a bundle that was uploaded and then discarded.
It is a single counter for the life of the app, shared with iOS, and
it does not reset when the version name changes. Codes 1 and 2 are
spent; `0.1.1+3` is the current release.

---

## Order of operations

**Steps 1 to 10 are complete**, carried out between 2026-09-13 and
2026-09-20. They are kept below as the record of what was done and
in what order, not as an open list. The live remaining work is steps
11 and 12, and step 11 is the long one.

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
6. Create the app in Play Console. Target audience is 13+ per D1,
   which drives the content rating and Data safety answers.
7. Create, verify and seed the review account.
8. Complete the Console declarations above.
9. Build the signed app bundle, upload the Dart symbols, upload the
   bundle to closed testing.
10. Add the Play App Signing SHA-1 and SHA-256 to Firebase and App
    Check, then confirm Google sign-in from the Play-installed build.
    Re-download `google-services.json` to keep the local copy
    current, but no rebuild is needed: the fingerprints are not
    compiled into the app, and registering them creates the OAuth
    client server-side.
11. Recruit 12 testers and hold them for 14 unbroken days. Internal
    testing does not count towards this; only the closed track does.
12. Apply for production.

After launch, the under-13 phase: build the age step and parental
consent flow, complete the SDK audit, rewrite the Children's Privacy
section, redeploy the hosted pages, then widen the target audience in
the Console and redo the content rating and Data safety answers.

---

## Open decisions

**D1. Target audience: 13+ at launch, under-13 support planned.**
Decided. Building parental consent first would have delayed the
12-tester clock by weeks. Adding under-13 users later is a Console
change plus the following work, which is the scope of that phase:

- **Verifiable parental consent** before an under-13 user's email and
  display name are collected. Signup needs an age step; under-13 users
  must not reach account creation until a parent has consented through
  an accepted method. Design, build and operate this flow.
- **Neutral age screen.** Seed targets children and adults, so it is a
  mixed-audience app. Any SDK not approved for child-directed use may
  run only behind the age screen, for users who pass it as adults.
- **SDK audit.** Confirm each Firebase SDK in use (Auth, Firestore,
  Analytics, Crashlytics, Performance, Messaging, App Check)
  is acceptable in a child-directed context, and record the outcome.
- **No ad identifiers.** Done under D2.
- **Privacy policy rewrite.** The Children's Privacy section must
  describe what is collected from children and how a parent consents,
  reviews and deletes it.
- **Consistency on every update.** Content rating, target audience and
  Data safety must agree, and Play re-reviews if they drift.

Declaring under-13s in the target audience is separate from opting
into the Designed for Families program, which is optional and only
governs listing in the Kids section.

**D2. Advertising ID: removed.** Decided. Seed serves no ads and
nothing reads the identifier, so the permission is stripped in
`AndroidManifest.xml` and Analytics ad ID collection is disabled. This
also satisfies the Families rule on AAID should D1 include children.
The rejected alternative was declaring it as collected under Device or
other IDs, which is honest but describes collection with no purpose.

**D3. Direct APK distribution for testers outside Play.** Open. A
tester asked for an APK because they install through Aurora Store
rather than a Google account. Nothing blocks it today:

```bash
flutter build apk --release --split-per-abi --obfuscate \
  --split-debug-info=build/debug-info
```

Send `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` and
upload the Dart symbols with the same command as the bundle. Two
caveats before making it a habit. The APK carries the upload
certificate, not the Play App Signing certificate, so a device that
installs it cannot later update from Play without uninstalling first,
and sign-in works only because the upload fingerprint is registered in
Firebase. It also gets no automatic updates, so every release means
sending a new file. Decide whether to add a `release-apk` Make target
and a tester note, or to point Aurora users at the Play listing once
production is open.
