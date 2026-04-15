# App Pages & Navigation Map

A page-by-page index of every screen in Seed, how users reach it, and what
it links to. Keep this in sync with `lib/app/router.dart` and the screen
files under `lib/features/*/presentation/screens/`.

## Navigation Shell

The app uses go_router with a `StatefulShellRoute.indexedStack` for the
four main tabs plus a modal Log Action button in the center of the bottom
bar.

Bottom nav (defined in `lib/app/main_shell.dart`):

| Index | Label        | Route           | Icon              |
|-------|--------------|-----------------|-------------------|
| 0     | Home         | `/home`         | home              |
| 1     | Progress     | `/progress`     | calendar_today    |
| —     | Log Action   | `/log-action`   | add_circle (push) |
| 2     | Mascot       | `/mascot`       | pets              |
| 3     | Profile      | `/profile`      | person            |

Auth redirect logic (in `router.dart`):
- Unauthenticated -> `/login`
- Email/password user, unverified -> `/verify-email`
- Authenticated + verified on auth/splash -> `/home`

## Auth Flow

### Splash (`/`)
Shown while auth state resolves; redirects based on user state.
- Links: none (redirect only)

### Login (`/login`)
Email/password sign-in plus social sign-in (Google, Apple on iOS).
- Links: `/register`
- Functionality: email/password fields, password visibility toggle, forgot
  password dialog, Google button, Apple button (iOS).

### Register (`/register`)
Create account with email/password and accept terms.
- Links: `/settings/terms`, `/settings/privacy`, `/login`
- Functionality: email/password/confirm fields, T&C checkbox with
  tappable inline links, Google/Apple sign-up.

### Email Verification (`/verify-email`)
Post-registration verification gate.
- Links: `/home` (on success), `/login` (sign out)
- Functionality: check verification, resend email, sign out.

### Mascot Selection (`/mascot-selection`)
One-time species pick and naming after sign-up.
- Links: `/home` (on submit)
- Functionality: species carousel, name input, confirm.

## Tab 0 — Home (`/home`)

Main hub with mascot summary, challenges, and SDG carousel.
- Links:
  - `/mascot` (tap mascot display)
  - `/mascot-selection` (if no mascot)
  - `/home/sdg/:goalNumber` (SDG carousel tap)
  - `/home/daily-fact` (mail icon in app bar)
  - `/home/challenges` (multi-day challenge card)
  - `/log-action` (bottom nav, via shell)
  - External: UN SDG page (`AppConstants.sdgGoalsUrl`)
- Functionality: mascot card with streak/points, daily challenge card,
  multi-day challenge card, infinite SDG carousel, "Learn more at UN.org"
  external link.

### SDG Detail (`/home/sdg/:goalNumber`)
Individual SDG goal with targets, resources, actions, and impact cards.
- Links:
  - `/home/sdg/{prev}` and `/home/sdg/{next}` (goal nav buttons)
  - External: SDG resource URLs
- Functionality: prev/next goal navigation, resource link tiles, action
  and impact cards.

### Eco Fact Inbox (`/home/daily-fact`)
Inbox-style list of daily eco facts; tapping marks as read.
- Links: `/home/daily-fact/:dateKey`
- Functionality: list rows, unread badges, empty state.

### Eco Fact Detail (`/home/daily-fact/:dateKey`)
Single fact display; locked until the day's challenge is complete.
- Links: none
- Functionality: fact card, auto-mark as viewed, locked state UI.

### Challenges (`/home/challenges`)
List of six multi-day challenges with state (completed / active /
available / blocked).
- Links: none (inline dialogs only)
- Functionality: start challenge confirm dialog, abandon confirm dialog,
  state badges.

## Tab 1 — Progress (`/progress`)

Rainbow sun daily-goal tracker and calendar view, with an Eco-Dex tab.
- Links: `/progress/history`
- Functionality: segmented control (Calendar / Eco-Dex), daily target
  picker for first-time users, calendar grid.

### Eco-Dex (embedded in Progress)
Encyclopedia of eco-actions organized by category, with a progress
header.
- Links: none
- Functionality: expandable/collapsible category sections, entry cards
  with lock/unlock state and detail sheets.

### Action History (`/progress/history`)
Timeline of logged actions grouped by date with running points total.
- Links: none
- Functionality: read-only list, retry on error.

## Log Action (`/log-action`)

Modal push route — not in the tab stack. Browse and log actions.
- Links: none (inline confirmation dialog / science bottom sheet)
- Functionality: search, category tabs, sort dropdown, SDG filter chips,
  action cards with log confirmation and science info.

## Tab 2 — Mascot (`/mascot`)

Active mascot with evolution timeline and multi-mascot collection.
- Links: none
- Functionality: rename (edit/check/cancel), switch-mascot dialog,
  mascot thumbnails, next-evolution progress.

## Tab 3 — Profile (`/profile`)

User stats (level, streak, CO2 saved, total actions) and evolution
stage.
- Links: `/profile/settings`
- Functionality: settings icon in app bar, sign-out button, stat cards.

### Settings (`/profile/settings`)
Settings hub.
- Links:
  - `/profile/settings/notifications`
  - `/profile/settings/language`
  - `/profile/settings/account`
  - `/profile/settings/about`
- Functionality: notification toggle, language selector, analytics
  toggle, section tiles.

### Notification Settings (`.../settings/notifications`)
- Links: none
- Functionality: master notifications toggle, smart-reminders toggle,
  reminder list (up to 5) with add / edit / delete, time picker.

### Language Settings (`.../settings/language`)
- Links: none
- Functionality: English / Spanish / Japanese tiles, live app switching.

### Account Settings (`.../settings/account`)
- Links: `/login` (on account deletion)
- Functionality: change email dialog, change password dialog, delete
  account dialog with re-authentication.

### About (`.../settings/about`)
- Links:
  - `/privacy` (canonical legal route)
  - `/terms` (canonical legal route)
  - External: mailto contact, licenses page (system)
- Functionality: app version, privacy/terms tiles, licenses button,
  SDG acknowledgment.

### Privacy Policy (`/privacy`)
Canonical legal document route. Accessible while unauthenticated so the
register screen can link to it. Wraps `LegalDocumentScreen`.

### Terms of Service (`/terms`)
Canonical legal document route. Accessible while unauthenticated so the
register screen can link to it. Wraps `LegalDocumentScreen`.

### Legal Document (internal)
Reusable template for legal docs — title, sections, last-updated date.
Not routable directly.

## Route Reference

Defined in `AppRoutes` (`lib/app/router.dart`). All values are
full paths suitable for `context.push` / `context.go`.

| Constant                  | Path                              |
|---------------------------|-----------------------------------|
| `splash`                  | `/`                               |
| `login`                   | `/login`                          |
| `register`                | `/register`                       |
| `privacy`                 | `/privacy`                        |
| `terms`                   | `/terms`                          |
| `emailVerification`       | `/verify-email`                   |
| `mascotSelection`         | `/mascot-selection`               |
| `actionLog`               | `/log-action`                     |
| `home`                    | `/home`                           |
| `progress`                | `/progress`                       |
| `mascot`                  | `/mascot`                         |
| `profile`                 | `/profile`                        |
| `dailyFact`               | `/home/daily-fact`                |
| `challenges`              | `/home/challenges`                |
| `sdgDetail(n)`            | `/home/sdg/{n}`                   |
| `dailyFactDetail(key)`    | `/home/daily-fact/{key}`          |
| `actionHistory`           | `/progress/history`               |
| `settings`                | `/profile/settings`               |
| `settingsNotifications`   | `/profile/settings/notifications` |
| `settingsLanguage`        | `/profile/settings/language`      |
| `settingsAccount`         | `/profile/settings/account`       |
| `settingsAbout`           | `/profile/settings/about`         |
