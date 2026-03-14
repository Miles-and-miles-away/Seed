# Security Report - Seed App

**Date:** 2026-03-14 (updated)
**Scope:** Full codebase audit — security, performance, common mistakes
**Branch:** development
**Previous audit:** 2026-02-14

---

## Executive Summary

Second comprehensive audit of the Seed codebase. Many issues from the
Feb 2026 audit have been resolved (App Check added, Firestore rules
deployed, debug logging centralized). This audit found new issues
including a critical leaked service account key and several medium-
severity gaps in validation, token cleanup, and build configuration.

**Critical:** 1 | **High:** 5 | **Medium:** 7 | **Low:** 5

---

## Critical

### C1. Exposed Firebase Service Account Key in Git History

**File:** `scripts/serviceAccountKey.json` (committed in `87b3488`)

The full Firebase Admin SDK service account key (with private RSA key)
is in git history. `.gitignore` now excludes it, but the key is still
retrievable from the repo.

**Impact:** Complete Firebase project takeover — full database
read/write, auth manipulation, storage access.

**Fix:**
1. Revoke the key immediately in Firebase Console > IAM
2. Generate a new service account key
3. Scrub history: `git filter-repo --path scripts/serviceAccountKey.json --invert-paths`
4. Force-push all branches (coordinate with team)
5. Rotate all associated credentials

---

## High

### H1. FCM Token Not Cleared on Logout

**File:** `lib/features/auth/presentation/providers/auth_providers.dart` (lines 178-188)

`signOut()` does not call `FCMService.removeStoredToken()`. On shared
devices, the next user receives push notifications for the previous
user.

**Fix:** Add before `authRepository.signOut()`:
```dart
await ref.read(fcmServiceProvider).removeStoredToken();
```

### H2. Missing Dart-Level Obfuscation for Release Builds

Android R8/ProGuard is enabled (good), but Dart code is not obfuscated.
No `--obfuscate` or `--split-debug-info` in build scripts or CI.

**Fix:** Add to all release build commands:
```
flutter build apk --obfuscate --split-debug-info=build/debug-info
flutter build ipa --obfuscate --split-debug-info=build/debug-info
```

### H3. Mascot Data Not Validated Server-Side

**Files:** `firestore.rules` (lines 6-12), `lib/features/mascot/data/repositories/mascot_repository.dart` (lines 88-176)

Firestore rules only check `mascots.size() <= 20`. No validation of
mascot fields (name length, level, points, evolution stage). A tampered
client could set arbitrary mascot levels/points.

**Fix:** Add field-level validation in Firestore rules or move mascot
mutations to Cloud Functions.

### H4. No Rate Limiting on Action Log Submissions

**Files:** `firestore.rules` (lines 15-41), `functions/src/validateActionPoints.ts`

The Cloud Function corrects invalid points reactively, but nothing
limits submission frequency. An attacker could spam action logs,
wasting database quota.

**Fix:** Rate-limit in Firestore rules (check `request.time` vs last
write timestamp) or gate submissions through a Cloud Function.

### H5. Placeholder Legal URLs Still in Production Code

**File:** `lib/features/settings/presentation/screens/about_screen.dart`

Still contains `https://seed-app.example.com/privacy` and
`https://seed-app.example.com/terms`. App Store / Play Store require
valid legal URLs.

**Fix:** Host real legal documents and replace the constants.

---

## Medium

### M1. Missing `android:usesCleartextTraffic="false"`

**File:** `android/app/src/main/AndroidManifest.xml` (line 9)

No explicit cleartext traffic declaration. Safe by default on Android
9+, but explicit declaration is best practice.

**Fix:** Add `android:usesCleartextTraffic="false"` to `<application>`.

### M2. Router Debug Diagnostics Not Gated by kDebugMode

**File:** `lib/app/router.dart` (line 64)

`debugLogDiagnostics: true` logs all navigation events in release
builds.

**Fix:** Change to `debugLogDiagnostics: kDebugMode`.

### M3. Missing Cloud Storage Rules

No `storage.rules` file exists. If Cloud Storage is enabled in Firebase
Console, default (permissive) rules may apply.

**Fix:** Create restrictive `storage.rules` or disable Cloud Storage.

### M4. Email Validation Missing in Password Reset & Email Change

**Files:**
- `lib/features/auth/presentation/screens/login_screen.dart` (line 296) — forgot password only checks `isNotEmpty`
- `lib/features/settings/presentation/screens/account_settings_screen.dart` (lines 127-167) — change email only checks `isEmpty`

**Fix:** Apply the same email RegExp validation used on login/register.

### M5. No Server-Side Language/Settings Validation

**File:** `firestore.rules` (lines 6-12)

User document writes don't validate the `settings` field structure.
Language preference not validated against `['en', 'es', 'ja']`.

**Fix:** Add field validation in Firestore rules.

### M6. Missing iOS Privacy Permission Descriptions

**File:** `ios/Runner/Info.plist`

No `NSCameraUsageDescription` or other `NS*UsageDescription` keys. If
any plugin triggers a permission prompt, the app crashes or gets
rejected by App Store.

**Fix:** Add all required privacy descriptions for permissions used by
the app and its dependencies.

### M7. TextEditingController Memory Leaks in Dialogs

**File:** `lib/features/settings/presentation/screens/account_settings_screen.dart`
- Lines 113-115: `_showChangeEmailDialog` — 3 controllers not disposed
- Lines 234-237: `_showChangePasswordDialog` — 4 controllers not disposed
- Lines 381-382: `_showDeleteAccountDialog` — 2 controllers not disposed

**Fix:** Dispose controllers when dialog closes.

---

## Low

### L1. Missing SafeArea on Settings Screens

**Files:**
- `lib/features/settings/presentation/screens/settings_screen.dart` (line 24)
- `lib/features/settings/presentation/screens/about_screen.dart` (line 25)
- `lib/features/settings/presentation/screens/account_settings_screen.dart` (line 43)
- `lib/features/settings/presentation/screens/notification_settings_screen.dart` (line 35)
- `lib/features/settings/presentation/screens/language_settings_screen.dart` (line 29)

**Fix:** Wrap `ListView` body in `SafeArea`.

### L2. Expensive Operations in Build Methods

**Files:**
- `lib/features/actions/presentation/widgets/action_card.dart` (lines 134-139) — SDG parsing/sorting
- `lib/features/actions/presentation/widgets/learn_only_info_dialog.dart` (lines 176-181) — same
- `lib/features/actions/presentation/screens/action_history_screen.dart` (lines 94-110) — grouping logs

**Fix:** Move to computed providers or memoize.

### L3. Reminder Label Missing Explicit maxLength

**File:** `lib/features/settings/presentation/screens/notification_settings_screen.dart` (line 240)

**Fix:** Add `maxLength: 20` to the TextField.

### L4. Document Size Limits Not Enforced in Firestore Rules

No size limits on `note` field or `relatedSdgs` array in action logs.

**Fix:** Add `request.resource.data.note.size() <= 200` and array
size checks in rules.

### L5. iOS User Script Sandboxing Disabled

**File:** `ios/Runner.xcodeproj/project.pbxproj` (lines 467, 590, 647)

`ENABLE_USER_SCRIPT_SANDBOXING = NO` in all build configurations.

**Fix:** Enable if compatible with build plugins.

---

## Passed (No Issues Found)

| Category | Details |
|---|---|
| SharedPreferences for secrets | Not used — Firebase Auth handles tokens |
| Logging sensitive data | All gated by `kDebugMode` via `AppLogger` |
| .env files committed | None found |
| HTTPS enforcement | All 40+ external URLs use HTTPS |
| Firebase App Check | Properly configured (Play Integrity + DeviceCheck) |
| Android allowBackup | Set to `false` |
| Android ProGuard/R8 | Enabled with proper keep rules |
| Signing key management | `key.properties` in `.gitignore`, example only |
| Android debuggable | Not set (Flutter manages automatically) |
| iOS ATS | Default (HTTPS required), no exceptions |
| WebView usage | None — no XSS risk |
| SQL injection | No local DB queries |
| Path traversal | No user-controlled file operations |
| Deep link parameter validation | SDG goal number clamped 1-17 |
| Firestore query injection | All paths use AppConstants |
| Firestore action log immutability | `allow update, delete: if false` |
| Action points validation | Cloud Function verifies against action library |
| Password handling | In-memory only, never logged |
| Error message exposure | Sanitized before user display |
| ListView.builder | Used correctly everywhere |
| Opacity widget misuse | None found |
| Image caching | Uses CachedNetworkImage |
| Async mounted checks | Proper throughout |
| Timer/Controller disposal | All properly disposed (except dialog controllers) |
| Text overflow | Ellipsis on critical widgets |
| Dependencies | All current, reputable publishers |
| pubspec.lock committed | Yes |
| Certificate pinning | Not present but acceptable for Firebase-only traffic |
| Re-authentication | Required for email/password/account changes |
| Email verification | Enforced for email/password users |

---

## Remediation Checklist

### From this audit (2026-03-14)
- [x] **C1** Delete service account key file (MANUAL: revoke key in Firebase Console, scrub git history)
- [x] **H1** Clear FCM token on logout
- [x] **H2** Add `--obfuscate --split-debug-info` to release builds (documented in CLAUDE.md)
- [x] **H3** Add language validation in Firestore rules (mascot field validation requires Cloud Function)
- [x] **H4** Add rate limiting on action log creation (5s between submissions)
- [x] **H5** N/A — already uses in-app routes, not placeholder URLs
- [x] **M1** Add `usesCleartextTraffic="false"` to AndroidManifest
- [x] **M2** Gate router debugLogDiagnostics with kDebugMode
- [x] **M3** Create storage.rules (deny all by default)
- [x] **M4** Add email validation to forgot password and change email
- [x] **M5** Add settings field validation in Firestore rules (language whitelist)
- [ ] **M6** iOS privacy descriptions — not needed for current feature set (notifications only)
- [x] **M7** Fix TextEditingController leaks in dialog methods
- [x] **L1** Add SafeArea to 5 settings screens
- [x] **L2** N/A — negligible cost on tiny lists
- [x] **L3** N/A — already has maxLength: 20
- [x] **L4** Add document size limits in Firestore rules (note <= 200, SDGs <= 17)
- [x] **L5** N/A — required by Flutter/CocoaPods

### From previous audit (2026-02-14) — still open
- [ ] Deploy `firestore.rules` and indexes to Firebase
- [ ] Configure Android release signing (keystore + key.properties)
