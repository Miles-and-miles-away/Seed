# Security Report - Seed App

**Date:** 2026-02-14
**Scope:** Full client-side security audit of the Seed Flutter app
**Branch:** development (commit 00dbed8)
**Last updated:** 2026-02-14 (post-remediation)

---

## Executive Summary

The Seed app has a solid security foundation. Firebase Auth handles
credentials correctly, sensitive operations require re-authentication,
and no secrets are committed to version control. The primary risks are
operational gaps (missing Firestore rules file, no App Check, release
signing not configured) and code hygiene issues (debug logging,
hardcoded collection names, placeholder URLs).

**Critical:** 2 | **High:** 4 | **Medium:** 5 | **Low:** 4

### Remediation Status

Five issues have been fixed in the current branch:
- **H2** - Debug print statements replaced with centralized logger
- **M1** - Hardcoded collection names replaced with constants
- **M2** - Analytics/crashlytics opt-out toggle added
- **M3** - SDG route parameter bounds-checked to 1-17
- **L4** - Client-side auth attempt throttling added

---

## Critical

### C1. No Firestore Security Rules in Repository

**Risk:** Without auditable rules, there is no guarantee that
server-side access control is enforced. A misconfigured or missing
`firestore.rules` file means any authenticated user could potentially
read/write any document.

**Evidence:** No `firestore.rules` file exists in the project root.
The only copy is the default template inside
`node_modules/firebase-tools/templates/`.

**Recommendation:**
- Create `firestore.rules` in the project root
- Enforce user-scoped access (`request.auth.uid == userId`)
- Lock down read-only collections (actionLibrary, mascotSpecies,
  cosmeticItems) to authenticated reads only
- Deploy rules via `firebase deploy --only firestore:rules`
- Add rules deployment to the release checklist

### C2. Release Build Uses Debug Signing Keys

**File:** `android/app/build.gradle.kts:36-38`

```kotlin
release {
    signingConfig = signingConfigs.getByName("debug")
}
```

**Risk:** Debug-signed APKs cannot be published to Play Store and
offer no tamper protection. An attacker could resign the APK with
their own key and distribute a modified version.

**Recommendation:**
- Generate a release keystore and configure `key.properties`
- Reference the release signing config in `build.gradle.kts`
- The keystore file is already gitignored (`android/*.jks`)

---

## High

### H1. Firebase App Check Not Implemented

**Evidence:** No imports of `firebase_app_check` found anywhere in
the codebase.

**Risk:** Without App Check, anyone with the project's public API
keys can call Firebase services directly (e.g., via REST or a
custom client), bypassing the app entirely. This enables abuse of
Firestore reads/writes and Auth endpoints.

**Recommendation:**
- Add `firebase_app_check` to pubspec.yaml
- Initialize App Check in `main.dart` before other Firebase calls
- Enable enforcement in the Firebase Console for Firestore, Auth,
  and Storage

### H2. 53 Debug Print Statements in Production Code -- FIXED

**Files affected (6):**

| File | Count |
|---|---|
| `lib/shared/services/analytics_service.dart` | 18 |
| `lib/shared/services/fcm_service.dart` | 15 |
| `lib/shared/services/notification_service.dart` | 6 |
| `lib/features/progress/data/datasources/daily_summary_remote_datasource.dart` | 7 |
| `lib/features/actions/presentation/providers/actions_providers.dart` | 4 |
| `lib/main.dart` | 3 |

**Risk:** `debugPrint()` is stripped in release builds, but raw
`print()` is not. Any `print()` calls will leak information in
production logcat/console output. Mixed usage makes it easy to
accidentally use the wrong one.

**Resolution:** Created `lib/core/utils/app_logger.dart` wrapping
the `logger` package with `kDebugMode` gating. All 53 `debugPrint()`
calls replaced with `AppLogger.debug()`, `.warning()`, or `.error()`
as appropriate. `grep debugPrint lib/` returns zero results.

### H3. No Code Obfuscation for Release Builds

**Evidence:** No `--obfuscate` or `--split-debug-info` flags
configured. No ProGuard/R8 rules for Android.

**Risk:** The release binary can be trivially decompiled, exposing
business logic, Firestore paths, and internal API patterns.

**Recommendation:**
- Add to the release build command:
  `flutter build apk --obfuscate --split-debug-info=build/symbols`
- Document this in the build/release checklist

### H4. Placeholder Legal URLs in Production Code

**File:** `lib/features/settings/presentation/screens/about_screen.dart:14-16`

```dart
static const _privacyPolicyUrl =
    'https://seed-app.example.com/privacy';
static const _termsOfServiceUrl =
    'https://seed-app.example.com/terms';
static const _contactEmail =
    'support@seed-app.example.com';
```

**Risk:** App Store / Play Store submissions require valid privacy
policy and terms of service URLs. Placeholder URLs erode user trust
and may violate platform policies.

**Recommendation:**
- Host real legal documents before release
- Replace the placeholder constants

---

## Medium

### M1. Hardcoded Collection Names Bypass Constants -- FIXED

`AppConstants` defines collection name constants, but several files
used raw strings instead.

**Risk:** Inconsistency makes refactoring error-prone and makes it
harder to audit which collections are accessed where.

**Resolution:** Added `collectionDailySummaries` to `AppConstants`.
Replaced all hardcoded collection strings in `fcm_service.dart`,
`profile_providers.dart`, `progress_repository.dart`,
`daily_summary_remote_datasource.dart`, and `sdg_stats_provider.dart`
with their `AppConstants` equivalents. `grep .collection(' lib/`
returns zero hardcoded strings.

### M2. No Analytics Opt-Out -- FIXED

**File:** `lib/shared/services/analytics_service.dart`

The app tracks user properties (language, mascot species, level) and
events (action logged, category, CO2 grams) via Firebase Analytics
with no way for users to disable collection.

**Risk:** GDPR and similar regulations require user consent for
analytics in many jurisdictions. App Store review may flag this.

**Resolution:** Added `analyticsEnabled` field to `UserSettingsModel`
(defaults to true). New "Privacy" section in Settings screen with
toggle. When disabled, `FirebaseAnalytics.setAnalyticsCollectionEnabled`,
`FirebaseCrashlytics.setCrashlyticsCollectionEnabled`, and
`AnalyticsService._enabled` are all set to false. Setting syncs on
app startup from Firestore. Localized in EN, JA, ES.

### M3. SDG Route Parameter Not Bounds-Checked -- FIXED

**File:** `lib/app/router.dart`

**Risk:** Invalid values (0, -1, 999) silently default to 1 or pass
through unchecked. If deep links are ever exposed externally, this
could cause unexpected behavior.

**Resolution:** Added `sdgMinGoal` and `sdgMaxGoal` constants to
`AppConstants`. Created `_parseSdgGoalNumber()` helper in router.dart
that parses and clamps values to 1-17. Applied to both the nested
and standalone SDG routes.

### M4. No Certificate Pinning

**Risk:** Without SSL pinning, a compromised or rogue CA could issue
a valid certificate for Firebase endpoints, enabling MITM attacks on
rooted/jailbroken devices.

**Recommendation:**
- Low priority for MVP since all traffic goes through Firebase SDK
  over TLS
- Consider adding pinning before handling payment data (RevenueCat
  integration)

### M5. FCM Token Stored Unencrypted in Firestore

**File:** `lib/shared/services/fcm_service.dart:129`

The `fcmToken` field is written directly to the user's Firestore
document. If Firestore rules allow cross-user reads, another user
could harvest FCM tokens and send push notifications.

**Risk:** Dependent on Firestore rules (see C1). If rules are
correct, this is low risk.

**Recommendation:**
- Ensure Firestore rules restrict the `fcmToken` field to the
  owning user only
- Consider storing tokens in a server-side-only collection

---

## Low

### L1. No Screenshot Prevention on Auth Screens

Sensitive screens (login, registration, password change) do not
prevent screenshots or screen recording.

**Recommendation:** Implement platform-specific flags if required by
compliance (Android: `FLAG_SECURE`, iOS: secure text field overlay).

### L2. No Session/Inactivity Timeout

Firebase Auth tokens auto-refresh indefinitely. If a device is
shared or stolen, the session persists.

**Recommendation:** Consider an optional inactivity timeout that
signs the user out after a configurable period.

### L3. Crashlytics Only Gated by kDebugMode -- FIXED

**File:** `lib/main.dart:27`

This was correct for debug vs release, but there was no user-facing
toggle to disable crash reporting.

**Resolution:** Crashlytics collection is now tied to the analytics
opt-out toggle (see M2). When the user disables analytics in Settings,
`FirebaseCrashlytics.setCrashlyticsCollectionEnabled(false)` is
called alongside the analytics disable.

### L4. No Rate Limiting on Client-Side Auth Attempts -- FIXED

Firebase Auth has built-in server-side rate limiting, but the client
did not throttle repeated login attempts.

**Resolution:** Added `authCooldownSeconds = 3` constant. Both
`login_screen.dart` and `register_screen.dart` now disable the
sign-in/sign-up button and social auth buttons for 3 seconds after
any auth error. Uses a `Timer` that auto-resets `_isCooldown`.

---

## Positive Findings

These areas are already well-implemented:

| Area | Details |
|---|---|
| **Credential handling** | Firebase Auth SDK handles all passwords; no local storage of credentials |
| **Re-authentication** | Required before email change, password change, and account deletion |
| **Error mapping** | Firebase error codes mapped to generic user-facing messages (`auth_error_mapper.dart`); no stack traces or internal details exposed |
| **Email verification** | Enforced for email/password users before granting app access |
| **Input validation** | Email regex, password length, field trimming, maxLength on notes |
| **Gitignore coverage** | Firebase configs, .env files, keystores, service account keys all excluded |
| **Network security** | All traffic over TLS via Firebase SDK; no cleartext HTTP |
| **Clean sign-out** | Auth state, analytics user ID, and FCM token all cleared on logout |
| **No local secrets** | SharedPreferences only used for non-sensitive preferences (theme, language) |

---

## Pre-Release Checklist

- [ ] Create and deploy `firestore.rules` with user-scoped access
- [ ] Configure Android release signing (keystore + key.properties)
- [ ] Integrate Firebase App Check
- [x] Replace all hardcoded collection names with `AppConstants`
- [x] Add `collectionDailySummaries` constant
- [ ] Replace placeholder legal URLs with real hosted documents
- [x] Replace `debugPrint`/`print` with centralized `AppLogger`
- [ ] Add `--obfuscate --split-debug-info` to release build
- [x] Add analytics/crashlytics opt-out toggle in Settings
- [x] Bounds-check SDG route parameter (1-17)
- [x] Add client-side auth attempt throttling
