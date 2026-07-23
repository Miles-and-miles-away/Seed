# App Pages & Navigation Map

A page-by-page index of every screen in Seed, how users reach it, and what
it links to. Keep this in sync with `lib/app/router.dart` and the screen
files under `lib/features/*/presentation/screens/`.

## Navigation Shell

The app uses go_router with a `StatefulShellRoute.indexedStack` for the
four main tabs plus a modal Log Action button in the center of the bottom
bar.

Bottom nav (shared widget `lib/app/app_bottom_nav.dart`, used by both the
shell and the pushed Log Action screen so every primary screen shows it):

| Index | Label        | Route           | Icon              |
|-------|--------------|-----------------|-------------------|
| 0     | Home         | `/home`         | home              |
| 1     | Progress     | `/progress`     | calendar_today    |
| —     | Log Action   | `/log-action`   | add_circle (push) |
| 2     | Mascot       | `/mascot`       | pets              |
| 3     | Profile      | `/profile`      | person            |

On the Log Action screen (a pushed route outside the shell) the same bar's
tabs use `context.go` to jump straight into the chosen shell branch.

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
- Links: `/terms`, `/privacy`, `/login`
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
  - `/log-action?category=<category>` (incomplete daily challenge card)
  - External: UN SDG page (`AppConstants.sdgGoalsUrl`)
- Functionality: mascot card with streak/points, daily challenge card
  (tap when incomplete jumps to the actions for its category),
  multi-day challenge card, My Goal card (shows the user's personal
  sustainability goal or a set-goal prompt; tap opens the goal picker
  sheet), infinite SDG carousel under an "Explore the SDG Goals" header,
  "Learn more at UN.org" external link.

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

Rainbow sun daily-goal tracker plus three segmented views: Calendar,
Impact, and Eco-Dex.
- Links: `/progress/history`
- Functionality: segmented control (Calendar / Impact / Eco-Dex),
  daily target picker for first-time users, calendar grid. Supports a
  `?tab=` query parameter (`calendar` / `impact` / `ecodex`) so other
  screens can deep-link to a specific segment.

### Impact (embedded in Progress)
CO2 dashboard showing total saved across selectable time periods,
real-world equivalencies (tree-years, car km, phone charges, beef
burgers), and trend / category charts of the same window.
- Links: external source URLs from the equivalencies info sheet
  (EPA, DEFRA, Our World in Data) opened via `url_launcher`.
- Functionality: time-period selector (Today / Week / Month / All
  Time); headline kg total card with period-over-period comparison
  badge; static four-card equivalencies row with info-icon sheet showing
  per-equivalency explainer, formula, and tappable source citation;
  daily-trend scatter chart with dashed mean line; category donut
  (Top 5 + Other) with center kg total and color-dot legend. Charts
  hide themselves when the window has insufficient data.

### Eco-Dex (embedded in Progress)
Encyclopedia of planet facts organized by category, with a progress
header. The app's single milestone/collection system (the separate
Achievements feature was merged into it; discoveries award knowledge,
never points).
- Links: none
- Functionality: progress header with info icon opening a
  how-discovery-works sheet; "Next Up" cards for the
  closest-to-discovery entries (hint + progress bar, name stays
  hidden); expandable/collapsible category sections; entry cards with
  lock/unlock state — discovered entries open a fact detail sheet
  (fact + source link), locked entries open a hint sheet with unlock
  progress. A full-screen confetti celebration overlay (not a route)
  appears when logging an action discovers entries, showing the entry
  art, name, and fact with a "+N more queued" indicator.

### Action History (`/progress/history`)
Timeline of logged actions grouped by date with running points total.
- Links: none
- Functionality: read-only list, retry on error.

## Log Action (`/log-action`)

Pushed route — not a shell branch, but shows the shared bottom nav so users
navigate via the tabs. The implicit AppBar back arrow is suppressed
(`automaticallyImplyLeading: false`) so the bottom nav is the single,
unambiguous exit. Browse and log actions.
- Links: bottom nav tabs (`context.go` to Home/Progress/Mascot/Profile);
  `/transport-calculator` and `/food-calculator` — reached via the AppBar
  calculator chooser (transport / food / home energy; home energy disabled
  until it ships) and the "Compare & log a transport choice" / "Compare &
  log a food choice" cards shown only in their category views; inline
  confirmation dialog / science bottom sheet
- Query params: `category` pre-selects the matching category tab on open
  (unknown values fall back to "All").
- Functionality: AppBar calculator-chooser icon opening the calculators
  bottom sheet; search, category tabs, sort dropdown, SDG filter chips,
  action cards with log confirmation and science info; a "Compare & log
  a transport choice" card in the transport view and a "Compare & log a
  food choice" card in the food view.

## Transport Calculator (`/transport-calculator`)

Pushed full-screen route (Phase 8). Educational journey builder:
add/edit/remove legs (mode + distance + occupancy for per-vehicle
modes) and see per-leg and total CO2e.
- Reached from: the AppBar calculator chooser on the Log Action screen
  (transport tile), and the "Compare & log a transport choice" card
  shown in that screen's transport category view (kept off the bottom
  nav to hold it at five buttons).
- Links (internal Navigator pushes, not named routes): Journey
  Comparison screen; Methodology & Sources screen (AppBar science
  icon). Per-mode science sheets and external source URLs open from
  info icons / tappable links.
- Functionality: leg list with per-leg CO2e and delete; leg editor
  bottom sheet with grouped mode picker (info icon per mode opens its
  science sheet), numeric km field (rejects negative/NaN; always
  editable), occupancy stepper only for per-vehicle modes; optional
  city-pair picker prefilling editable distance estimates
  (water-blocked pairs never suggest ground/active; flights auto-pick
  the honest DEFRA band from the pair's countries + distance);
  running journey total; "Add to comparison" stages the journey (up
  to 3) and "Compare" opens the comparison.

### Journey Comparison (pushed within the feature)
Side-by-side bars for 2–3 staged journeys (8.3), scaled to the worst
option with the best highlighted. Delta line reads "emits X CO2e
less (Y% lower)" — never "saves" (data-review copy rule) — with the
Phase 6 tree-year equivalency of the difference. Electric-car rows
show the grid caveat, the private jet the radiative-forcing footnote,
active/micro modes their basis. With three options, "I took" and
"instead of" pickers (defaults greenest/worst) let the user designate
the choice they made; a "I chose {greener}" button then banks the
avoided emissions (baseline − chosen) as a real transport action
(Phase 8.6): it creates a user `customActions` template and logs it
through the standard action transaction (points from `co2^0.4`,
neutral multipliers). Banking is disabled unless the two picks differ.
No caps — users are isolated (scoring design decision).

### Methodology & Sources (pushed within the feature)
Markdown page (8.4): scope, occupancy, radiative forcing (1.7×,
DESNZ 2025), electric-grid context, why category averages, the
coach/rail close-call caveat, and a source list derived from the
dataset so it can never drift. Tappable citations.

Banked transport choices appear in the Progress calendar like any
logged action; opening one in the day-detail sheet offers "Do this
again" (reproduce), which re-logs the same template.

## Food Calculator (`/food-calculator`)

Pushed full-screen route (Phase 8, Part 2). Educational meal builder:
add/edit/remove ingredients (food item + quantity) and see per-
ingredient and total CO2e. Mirrors the transport calculator; simpler
(no occupancy). Never awards points inside the tool.
- Reached from: the AppBar calculator chooser on the Log Action screen
  (food tile), and the "Compare & log a food choice" card shown in that
  screen's food category view (kept off the bottom nav to hold it at
  five buttons).
- Links (internal Navigator pushes, not named routes): Meal Comparison
  screen; Methodology & Sources screen (AppBar science icon). Per-item
  science sheets and external source URLs open from info icons /
  tappable links.
- Functionality: ingredient list with per-ingredient CO2e and delete;
  ingredient editor bottom sheet with grouped item picker (info icon
  per item opens its science sheet), serving-preset chips over an
  editable grams field (rejects negative/NaN), numeric quantity;
  running meal total; "Add to comparison" stages the meal (up to 3)
  and "Compare" opens the comparison.

### Meal Comparison (pushed within the feature)
Side-by-side bars for 2–3 staged meals (8.9), scaled to the worst
option with the best highlighted. Delta line reads "emits X CO2e less
(Y% lower)" — never "saves" (data-review copy rule) — with the Phase 6
driving (car-km) equivalency of the difference. With three options,
"I ate" and "instead of" pickers (defaults greenest/worst) let the
user designate the meal they had; a "I chose {greener}" button then
banks the avoided emissions (baseline − chosen) as a real food action
(Phase 8.12): it reuses the category-agnostic `customActions` template
+ rules the transport bridge established and logs through the standard
action transaction (points from `co2^0.4`, neutral multipliers).
Banking is disabled unless the two picks differ. No caps — users are
isolated (scoring design decision).

### Methodology & Sources (pushed within the feature)
Markdown page (8.10): cradle-to-retail scope incl. land-use change
(not summable with the transport calculator), the mean-vs-median
explainer ("you may have seen beef = 60"), producer spread, the
no organic/local modifier rationale, and a source list derived from
the dataset so it can never drift. Tappable citations.

Banked food choices appear in the Progress calendar like any logged
action; the day-detail "Do this again" reproduce path applies to them
too.

## Tab 2 — Mascot (`/mascot`)

Active mascot with evolution timeline and multi-mascot collection.
- Links: none
- Functionality: rename (edit/check/cancel), switch-mascot dialog,
  mascot thumbnails, next-evolution progress.

## Tab 3 — Profile (`/profile`)

User stats (level, streak, CO2 saved, total actions) and evolution
stage.
- Links: `/profile/settings`, `/progress?tab=ecodex`
- Functionality: settings icon in app bar, sign-out button, stat
  cards, Eco-Dex preview card (up to 3 most recent discoveries + "+N
  more" chip and a "X / Y discovered" counter; thumbnail tap opens
  the entry fact sheet, card tap deep-links to the Eco-Dex segment
  on the Progress tab).

### Settings (`/profile/settings`)
Settings hub.
- Links:
  - `/profile/settings/language`
  - `/profile/settings/account`
  - `/profile/settings/feedback` (Send Feedback)
  - `/profile/settings/about`
- Functionality: language selector, analytics toggle, section tiles.
- Note: the Notifications section is hidden while the reminder feature
  is postponed (the route below still exists but is unreachable from
  the UI).

### Notification Settings (`.../settings/notifications`) — hidden
Feature postponed; no UI entry points to this route.
- Links: none
- Functionality: master notifications toggle, smart-reminders toggle,
  reminder list (up to 5) with add / edit / delete, time picker.
  Settings are persisted but no notification is ever scheduled (see
  notes in `lib/shared/providers/notification_providers.dart`).

### Language Settings (`.../settings/language`)
- Links: none
- Functionality: English / Spanish / Japanese tiles, live app switching.

### Account Settings (`.../settings/account`)
- Links: `/login` (on account deletion)
- Functionality: profile section (display name dialog, My Goal picker
  sheet with presets + free text), change email dialog, change password
  dialog, delete account dialog with re-authentication.

### About (`.../settings/about`)
- Links:
  - `/privacy` (canonical legal route)
  - `/terms` (canonical legal route)
  - External: licenses page (system)
- Functionality: app version, privacy/terms tiles, licenses button,
  SDG acknowledgment.

### Feedback (`.../settings/feedback`)
- Functionality: structured form with category chips (Bug / Feature /
  General), description text field, app+device metadata footer. Submit
  launches the user's mail client with a pre-populated `mailto:` URI
  (subject prefixed by category, body bundles description + metadata),
  then pops back with a confirmation SnackBar.

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

Exposed via the `appRoutes` singleton (`lib/app/router.dart`).
All values are full paths suitable for `context.push` / `context.go`.

| Member                    | Path                              |
|---------------------------|-----------------------------------|
| `splash`                  | `/`                               |
| `login`                   | `/login`                          |
| `register`                | `/register`                       |
| `privacy`                 | `/privacy`                        |
| `terms`                   | `/terms`                          |
| `emailVerification`       | `/verify-email`                   |
| `mascotSelection`         | `/mascot-selection`               |
| `actionLog`               | `/log-action`                     |
| `transportCalculator`     | `/transport-calculator`           |
| `foodCalculator`          | `/food-calculator`                |
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
| `settingsFeedback`        | `/profile/settings/feedback`      |
