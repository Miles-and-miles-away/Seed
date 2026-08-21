# Security Report - Seed App

**Date:** 2026-08-21 (re-verification pass), operational items
re-checked 2026-08-22
**Scope:** Full codebase audit - security, performance, common mistakes
**Branch:** development
**Previous audits:** 2026-02-14, 2026-03-14

---

## Executive Summary

Third pass. Rather than re-auditing from scratch, every finding from the
March 2026 audit was re-checked against current code and the status
below reflects what the code actually does today, with the evidence
inline. The March audit's finding bodies had gone stale: they still read
as open long after the fixes landed.

**Open:** 0 critical, 0 high, 0 medium.
One finding (H3, mascot array) is accepted by design with a documented
revisit trigger. Two (H2, M6) are not applicable to the current feature
set. Everything else is fixed and verified.

The one item that needs action is operational, not code: `firestore.rules`
has changed since the last deploy and the changes are inert until pushed.
Indexes were confirmed deployed and in sync on 2026-08-22; the rules half
is still unconfirmed.

---

## Status of March 2026 findings

| ID | Finding | Status | Evidence |
|---|---|---|---|
| C1 | Service account key in git history | **Resolved** | Key `ced7550a...3092` absent from the service account's live cert list. Revocation verified against the public x509 endpoint, not just the console. |
| H1 | FCM token not cleared on logout | **Fixed** | `removeStoredToken()` in `signOut()`, `auth_providers.dart` |
| H2 | No Dart obfuscation | **N/A** | No release pipeline exists. CI smoke-builds `--debug` only. Obfuscated commands are documented in CLAUDE.md for when one is added. |
| H3 | Mascot data not validated server-side | **Accepted by design** | See below. |
| H4 | No rate limiting on action logs | **Fixed** | 5s throttle between submissions in `firestore.rules` |
| H5 | Placeholder legal URLs | **Fixed** | No `example.com` anywhere in `lib/`. Uses in-app routes. |
| M1 | Missing `usesCleartextTraffic` | **Fixed** | `android:usesCleartextTraffic="false"` in AndroidManifest |
| M2 | Router diagnostics in release | **Fixed** | `debugLogDiagnostics: kDebugMode` |
| M3 | Missing Cloud Storage rules | **Fixed** | `storage.rules` denies all reads and writes |
| M4 | Email validation gaps | **Fixed** | `validateEmail` in both forgot-password and change-email |
| M5 | No server-side settings validation | **Fixed** | `d.language in ['en', 'es', 'ja']` in rules |
| M6 | Missing iOS privacy descriptions | **N/A** | No permission-requiring plugins in `pubspec.yaml`. Nothing triggers a prompt, so no `NS*UsageDescription` key is reachable. Revisit when adding camera, photo, or location features. |
| M7 | TextEditingController leaks | **Fixed** | All dialog controllers disposed |
| L1 | Missing SafeArea | **Fixed** | All 5 settings screens |
| L2 | Expensive ops in build methods | **Accepted** | Negligible on the actual list sizes (max 17 SDGs, one day's logs). Revisit if a profile shows jank. |
| L3 | Reminder label maxLength | **Fixed** | `maxLength: 20` |
| L4 | No document size limits | **Fixed** | `note.size() <= 200`, `relatedSdgs.size() <= 17` |
| L5 | iOS script sandboxing disabled | **Accepted** | `ENABLE_USER_SCRIPT_SANDBOXING = NO` is the Flutter and CocoaPods default. Enabling it breaks plugin build scripts. |

---

## H3: mascot array, accepted by design

The March audit recommended adding field-level validation for mascot
entries to `firestore.rules`. That fix is not expressible as written.
`mascots` is a list of maps on the user document, and the Firestore
rules language has no iteration: no loop, no map, no filter, no
recursion. List support stops at `size()`, `hasAll()`, `hasAny()`,
`hasOnly()`, and positional indexing. Validating each element of a
variable-length list of maps therefore cannot be expressed, short of
unrolling twenty guarded index blocks by hand.

The correct fix is structural: move `mascots` off the user document into
a subcollection, where per-document rules validate each mascot the way
`actionLog`, `customActions`, and `dailySummaries` already are. That is
a real migration. The array is written from two repositories across 14
call sites, is a field on `AppUserModel`, and participates in the atomic
scoring transaction in `action_log_repository.dart`. It would mean
rewriting the highest-risk path in the app plus a backfill for existing
users.

Accepted for now, because the exposure does not justify that churn:

- Users are isolated. There are no leaderboards and none are planned.
- A tampered mascot level is visible only to the user who tampered with
  it. There is no other player to gain an advantage over.
- User-level scoring, which is the part that would matter if rankings
  ever existed, *is* validated in rules: point deltas are checked
  against the action library, logs are immutable, and submissions are
  rate limited.

**Revisit trigger:** leaderboards or any cross-user feature, the same
condition PLAN_MASTER already sets for deferring server-authoritative
scoring. At that point do the subcollection migration rather than
trying to patch the rules.

The migration is scoped as section 7.5 of
[PLAN_PHASE_7.md](./PLAN_PHASE_7.md): what it touches, why `logAction`
is the blocker, the task list, and the verification bar.

---

## Fixed in this pass

### Egg map now validated server-side

`egg` was checked only as `d.egg == null || d.egg is map`, so any map
shape passed. Unlike `mascots` this is a map, not a list, so it is fully
expressible in rules. Now validated:

- key set constrained with `hasOnly`, so unknown fields are rejected
- `receivedAt` required and must be a timestamp
- `hatchingStreakDays` an int in 0..30, matching
  `AppConstants.eggHatchingStreakRequired`
- `lastHatchingActivityDate` a timestamp or null

Covered by 8 tests in `test/firestore/firestore.rules.test.js` under
`users/{userId} write - egg shape`. Suite is 107 tests, all passing via
`npm run test:rules`.

---

## Outstanding operational items

None is a code defect. All carry over from the 2026-02-14 audit.

- [x] **Deploy Firestore indexes.** Verified deployed on 2026-08-22.
      `firebase firestore:indexes --project prod` returns exactly the
      two composite indexes in `firestore.indexes.json`, with no drift
      in either direction. `firestore.indexes.json` has not changed
      since 2026-02-15, so this half was never behind.
- [ ] **Deploy `firestore.rules`.** Still unconfirmed. The local rules
      are ahead of production as far as anyone can tell: the egg
      validation above landed in `firestore.rules` on 2026-08-21 and no
      rules deploy for this project is recorded since. Until deployed,
      that hardening does nothing.

      The live ruleset still cannot be read from a shell session. The
      Firebase CLI has no `firestore:rules get`, `deploy --dry-run`
      only checks that the file compiles, and the Rules REST API needs
      a minted access token. Confirm the deploy timestamp in the
      Firebase Console, or simply redeploy, which is idempotent:

      ```bash
      firebase deploy --only firestore:rules --project prod
      ```
- [ ] **Configure Android release signing.** Keystore plus
      `key.properties`. Only blocking for a store release;
      `key.properties.example` is committed as the template.

---

## Passed (No Issues Found)

| Category | Details |
|---|---|
| SharedPreferences for secrets | Not used, Firebase Auth handles tokens |
| Logging sensitive data | All gated by `kDebugMode` via `AppLogger` |
| .env files committed | None found, verified across full git history |
| HTTPS enforcement | All 40+ external URLs use HTTPS |
| Firebase App Check | Configured (Play Integrity + DeviceCheck) |
| Android allowBackup | Set to `false` |
| Android ProGuard/R8 | Enabled with proper keep rules |
| Signing key management | `key.properties` gitignored, example only |
| Android debuggable | Not set (Flutter manages automatically) |
| iOS ATS | Default (HTTPS required), no exceptions |
| WebView usage | None, no XSS risk |
| SQL injection | No local DB queries |
| Path traversal | No user-controlled file operations |
| Deep link parameter validation | SDG goal number clamped 1-17 |
| Firestore query injection | All paths use AppConstants |
| Firestore action log immutability | `allow update, delete: if false` |
| Action points validation | Point deltas checked against action library in rules |
| Password handling | In-memory only, never logged |
| Error message exposure | Sanitized before user display |
| ListView.builder | Used correctly everywhere |
| Opacity widget misuse | None found |
| Image caching | Uses CachedNetworkImage |
| Async mounted checks | Proper throughout |
| Timer/Controller disposal | All properly disposed |
| Text overflow | Ellipsis on critical widgets |
| Dependencies | All current, reputable publishers |
| pubspec.lock committed | Yes |
| Certificate pinning | Not present, acceptable for Firebase-only traffic |
| Re-authentication | Required for email/password/account changes |
| Email verification | Enforced for email/password users |
