# App Store Deployment

**Created:** 2026-09-20
**Status:** Not started. No Apple Developer Program membership, no
signing identity on any machine, no App Store Connect record, and no
`.ipa` has ever been built. Enrolment is the critical path.
**Purpose:** The Apple release track: the identifiers that cannot
change, the enrolment gate, the TestFlight tracks, the App Store
Connect declarations, and the order to do them in.
**Companion docs:** `PLAY_STORE_DEPLOYMENT.md` is the Google Play
sibling and holds the 12-tester production gate, the Console
declarations and the Android signing model, none of which apply here.
`DEPLOYMENT_STRATEGY.md` holds Firebase environments and deploy
commands. `SETUP_IOS.md` holds local toolchain setup, and is stale:
it still describes CocoaPods, which this project no longer uses, and
Flutter 3.44.1.

**Not here:** the Play Console path, the Firebase project setup, and
the shared privacy policy text, which lives in `legal_content.dart`
and is published from `public/`.

---

## Table of Contents

1. [Bundle identifier](#bundle-identifier)
2. [Enrolment gate](#enrolment-gate)
3. [TestFlight tracks](#testflight-tracks)
4. [App access and the review account](#app-access-and-the-review-account)
5. [App Store Connect declarations](#app-store-connect-declarations)
6. [Build and signing](#build-and-signing)
7. [Order of operations](#order-of-operations)
8. [Open decisions](#open-decisions)

---

## Bundle identifier

`com.seedahabit.app`, matching Android. It is carried in:

- `ios/Runner.xcodeproj/project.pbxproj`, as
  `PRODUCT_BUNDLE_IDENTIFIER` for Runner. RunnerTests carries
  `com.seedahabit.app.RunnerTests` and is not shipped.
- `ios/Runner/GoogleService-Info.plist`, as `BUNDLE_ID`
- the Firebase iOS app registration
  (`1:49522523534:ios:680280a3eb42d871adf8df`)

`ios/Runner/Info.plist` also holds the reversed iOS OAuth client ID
under `CFBundleURLSchemes`. It currently agrees with
`REVERSED_CLIENT_ID` in `GoogleService-Info.plist`. If the iOS app is
ever re-registered in Firebase, a new client is issued and this scheme
must be replaced, or Google sign-in fails on iOS with no error.

**Permanent from the first upload.** Apple cannot rename a published
bundle identifier, and a new one is a new app with no update path.

Minimum deployment target is iOS 16.0, set in three build
configurations in `project.pbxproj`.

---

## Enrolment gate

Nothing can be built for a device, uploaded, or distributed without a
paid Apple Developer Program membership. This is the whole critical
path; see decision A1 for the Individual versus Organisation choice
and why Individual was taken.

There is a free Apple Developer account. It allows a seven-day
provisioning profile for running on your own device, and nothing
else: no TestFlight, no App Store. It does not shorten this path.

**What Apple does not impose.** There is no equivalent of Google's
12-tester, 14-day continuous-opt-in gate. TestFlight internal testing
needs no review of any kind. This is the single biggest difference
between the two release tracks, and it means iOS can reach real
testers faster than Android can reach production, despite starting
later.

---

## TestFlight tracks

| | Internal | External |
|---|---|---|
| Who | Up to 100 team members | Up to 10,000, email or link |
| Review | None | Beta App Review, first build |
| Time to testers | Minutes after processing | Usually 24-48 hours |
| Build lifetime | 90 days | 90 days |

Internal testers are App Store Connect users on your team, so they
need a role on the account. External testers do not.

Internal testers must be given an App Store Connect role, so they are
collaborators rather than members of the public. External testing is
where the equivalent of an Android closed test happens.

Builds expire after 90 days. A test running longer than that needs a
fresh upload, which is a live constraint for any extended beta.

---

## App access and the review account

Seed is fully login-gated, with no anonymous or guest path, so a
reviewer who opens the app sees a sign-in screen and nothing else.
App Store Connect has a **Sign-In Required** section under App Review
Information that takes a username and password, plus free-text notes.

The same account used for the Play review satisfies this. It must be
email-verified before it is entered: the router sends unverified
password users to the verification screen and nowhere else, so an
unverified review account is a dead end on both platforms.

Apple additionally expects the demo account to be seeded with enough
activity that a reviewer sees logged actions, a levelled mascot and
populated progress screens rather than an empty first-run state.

**Sign in with Apple is mandatory here, not optional.** App Store
Review Guideline 4.8 requires it wherever a third-party sign-in is
offered, and Seed offers Google. The entitlement is already present
in `ios/Runner/Runner.entitlements` as
`com.apple.developer.applesignin`, and the flow is implemented. It
must keep working; losing it is a rejection, not a warning.

---

## App Store Connect declarations

**Privacy nutrition labels.** These are answered in App Store Connect
and must agree with `ios/Runner/PrivacyInfo.xcprivacy`, which is
already populated and is the better source of truth because it ships
in the binary. It currently declares `NSPrivacyTracking` false, no
tracking domains, and nine collected types:

| Type | Linked to user | Purpose |
|---|---|---|
| Email address | yes | App functionality |
| Name | yes | App functionality |
| User ID | yes | App functionality |
| Device ID (FCM token) | yes | App functionality |
| Other user content (custom action text, notes) | yes | App functionality |
| Coarse location (IP-derived, Analytics) | no | Analytics |
| Crash data | no | App functionality |
| Performance data | no | App functionality |
| Other usage data | no | Analytics |

Answer the Console questionnaire from that table. It must also stay
consistent with the Play Data safety answers and the privacy policy
text in `legal_content.dart`; three places now describe the same
collection, and Apple re-reviews when they drift.

**App Tracking Transparency is not required.** Nothing tracks across
apps or websites, `NSPrivacyTracking` is false, and there are no
tracking domains. Do not add the prompt: asking for permission the
app does not use is itself a rejection reason.

**Account deletion.** Apple requires in-app account deletion for any
app that supports account creation, and it must be reachable from
inside the app rather than only from a web page. The
`deleteUserAccount` callable and the hosted deletion page already
exist; confirm the in-app route to it is present before submitting.

**Age rating.** 13+ to match the Play answer under D1 in
`PLAY_STORE_DEPLOYMENT.md`. Apple's questionnaire is worded
differently from Google's but must reach the same outcome, or the two
listings disagree.

**Export compliance.** Asked on every single upload. Seed uses only
HTTPS and platform-standard cryptography, which is exempt. Setting
`ITSAppUsesNonExemptEncryption` to false in `Info.plist` answers it
once and stops the per-build prompt. It is set.

**Screenshots.** Required per device size and are not the same
dimensions as the Play assets, so the Play screenshots cannot be
reused directly.

---

## Build and signing

```bash
flutter build ipa --release --obfuscate \
  --split-debug-info=build/debug-info
```

Signing is `CODE_SIGN_STYLE = Automatic` in all three build
configurations, and `DEVELOPMENT_TEAM` is absent from
`project.pbxproj`. Opening the project in Xcode and selecting the team
once will add it. Automatic signing means Xcode manages certificates
and profiles, so there is no upload keystore to back up, unlike
Android. The signing identity lives in the login keychain and is
re-issuable from the developer account, which makes the loss scenario
far less severe than losing `seed-release.keystore`.

**`aps-environment` is set to `development`** in
`Runner.entitlements`. Push notifications will not work on a
TestFlight or App Store build until it is `production`. Notifications
are deliberately deferred and the UI is hidden, so this is not
blocking, but it is a trap waiting for whoever turns them on.

Two different kinds of symbol reach Crashlytics and they are easy to
confuse. Native iOS dSYMs are uploaded automatically by the
`FlutterFire: "flutterfire upload-crashlytics-symbols"` build phase
in `project.pbxproj`; nothing manual is needed. **Dart** symbols are separate,
written to `build/debug-info` by `--split-debug-info`, and must be
uploaded by hand or Dart stack traces stay unreadable. That upload
needs a JDK on `PATH`:

```bash
conda activate seed
npm run firebase -- crashlytics:symbols:upload \
  --app=1:49522523534:ios:680280a3eb42d871adf8df build/debug-info
```

The build number in `pubspec.yaml` is shared with Android. Apple
requires it to increase within a version string, so the single
counter already in use satisfies both stores; do not fork it per
platform.

App Check uses `AppleDeviceCheckProvider` in release and
`AppleDebugProvider` in debug, set in `main.dart`. DeviceCheck needs
the app registered in the Firebase App Check console before enforced
APIs will accept it, exactly as Play Integrity did on Android.

---

## Order of operations

1. Enrol in the Apple Developer Program as an Individual (A1). Have
   photo ID ready; verification is the slow step.
2. Open `ios/Runner.xcodeproj` in Xcode, select the team, let
   automatic signing issue the certificate and profile.
3. ~~Set `ITSAppUsesNonExemptEncryption` to false in `Info.plist`.~~ Done.
4. Run `flutter build ipa` and fix what it surfaces. This has never
   been run; CI only builds `--simulator --debug`, so the release
   path is entirely unproven.
5. Create the app record in App Store Connect with bundle ID
   `com.seedahabit.app` and the 13+ age rating.
6. Register the app for App Check DeviceCheck in Firebase.
7. Upload the build, either from Xcode Organizer or with
   `xcrun altool`. Upload the Dart symbols.
8. Enter the review account under Sign-In Required.
9. Answer the privacy nutrition labels from the table above.
10. Add internal testers and confirm the build installs and signs in
    with Google and with Apple.
11. Submit for Beta App Review to open external testing.
12. Submit for App Store review when the beta is stable.

Steps 5 through 9 can be done while step 4 is still being fought
with, and step 1 blocks everything.

---

## Open decisions

**A1. Enrolment type: Individual.** Decided 2026-09-20. An
Organisation membership requires a D-U-N-S number and a registered
legal entity, which pushes enrolment from roughly two days to one to
three weeks. The Play developer account is already a personal one, so
an Apple Organisation would not match it. Both cost the same.

The accepted cost is that an Individual membership publishes the
holder's legal name as the seller on the public App Store listing.
Moving to an Organisation later is possible through an app transfer,
but it is tedious and best avoided, so this is effectively permanent.

**A2. In-app account deletion: already satisfied.** Verified
2026-09-20. Apple requires deletion to be initiated from inside the
app, not only from a hosted page, and it is a common rejection.
`account_settings_screen.dart` renders the
`accountSettingsDeleteAccount` tile with its warning string, and the
confirmed flow calls `AuthRepository.deleteAccount`, which invokes
the `deleteUserAccount` callable through `user_remote_datasource.dart`.
The Cloud Function removes the subcollections and the Auth user
server-side.

No work is needed. Recorded because the requirement is easy to
assume is met by the hosted page alone, which would not pass.
