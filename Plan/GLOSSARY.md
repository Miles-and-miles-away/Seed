# Seed Glossary — Flutter/Dart Terminology

A reference for navigating the Seed codebase and spotting widgets in the
emulator. Examples point at real files in `lib/`.

---

## Part 1 — Flutter UI Widgets & Terminology

### Screen Structure

**Scaffold** — the top-level container for a screen (app bar + body + bottom
bar).
- `lib/features/actions/presentation/screens/action_log_screen.dart:67`
- `lib/app/main_shell.dart:77`
- *Emulator:* the overall frame of every screen (top bar, content, bottom
  nav).

**SafeArea** — keeps content clear of notches and system bars.
- `lib/features/auth/presentation/screens/login_screen.dart:81`
- *Emulator:* content that respects the iPhone notch / Android status bar.

**AppBar** — the title bar at the top of a screen.
- `lib/features/actions/presentation/screens/action_log_screen.dart:68`
- *Emulator:* the bar at the top showing the screen title and icons.

**SliverAppBar** — an AppBar that collapses/floats as you scroll.
- `lib/features/sdg/presentation/screens/home_screen.dart:32`
- *Emulator:* the Home header that shrinks as you scroll.

**BottomAppBar** — the bottom bar, often holding navigation.
- `lib/app/main_shell.dart:79`
- *Emulator:* the 5-tab navigation bar (Home, Progress, Action, Mascot,
  Profile).

**CustomScrollView + Slivers** — advanced scrolling that stitches an AppBar,
list, and padding into one scroll.
- `lib/features/sdg/presentation/screens/home_screen.dart:29`
- *Emulator:* Home screen where the header animates while the body scrolls.

### Layout

**Container** — styled box (color, border, padding, rounded corners).
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:90`
- *Emulator:* the colored header inside the log-confirmation popup.

**Column / Row** — vertical and horizontal stacks. Used everywhere.

**Stack / Positioned** — overlay widgets with absolute positioning.
- `lib/features/actions/presentation/widgets/points_animation_overlay.dart`
- *Emulator:* the floating "+X points" animation after logging an action.

### Overlays & Popups

**Dialog / AlertDialog** — a modal popup that blocks the screen.
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:82`
- *Emulator:* the confirmation popup that appears when you log an action.

**BottomSheet** (`showModalBottomSheet`) — a panel that slides up from the
bottom.
- `lib/features/progress/presentation/widgets/day_detail_bottom_sheet.dart:30`
- `lib/features/actions/presentation/widgets/action_science_bottom_sheet.dart`
- *Emulator:* tap a day on the calendar or the "science" area on an action.

**SnackBar** — a transient message at the bottom.
- `lib/features/auth/presentation/screens/login_screen.dart:69`
- *Emulator:* the error toast after a failed login.

### Lists & Grids

**ListView** — a scrollable list.
- `lib/features/eco_fact/presentation/screens/eco_fact_screen.dart:29`
- *Emulator:* the Eco-Fact Inbox.

**ListView.separated** — ListView with dividers between rows.
- `lib/features/eco_fact/presentation/screens/eco_fact_screen.dart:29`
- *Emulator:* the thin line separating facts in the Inbox.

**GridView** — multi-column scrollable grid.
- *Emulator:* collection views in the Eco-Dex.

**ListTile** — a standard row (leading icon, title, trailing widget).
- `lib/features/settings/presentation/widgets/reminder_list_tile.dart`
- `lib/features/eco_fact/presentation/widgets/mail_list_tile.dart`
- *Emulator:* every row on the Settings screen and Fact Inbox.

### Buttons & Input

**ElevatedButton / FilledButton** — solid primary-action button.
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:182`
- *Emulator:* the "Confirm" button in the log dialog.

**TextButton** — flat text button for secondary actions.
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:176`
- *Emulator:* the "Cancel" button in the log dialog.

**IconButton** — button with only an icon.
- `lib/features/actions/presentation/screens/action_log_screen.dart:87`
- *Emulator:* the X that clears the search field.

**TextField / TextFormField** — text input.
- `lib/features/actions/presentation/screens/action_log_screen.dart:81` (search)
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:147` (note)
- *Emulator:* the search bar at the top of Action Log; the note field in the
  confirmation dialog.

**Switch** — on/off toggle.
- `lib/features/settings/presentation/screens/settings_screen.dart:46`
- *Emulator:* the notification / analytics toggles in Settings.

**Chip / FilterChip** — compact tag or filter pill.
- `lib/features/actions/presentation/widgets/sdg_filter_chips.dart:22`
- *Emulator:* the SDG filter chips above the action list.

**SegmentedButton** — a linked set of toggle buttons.
- `lib/features/progress/presentation/screens/progress_screen.dart:70`
- *Emulator:* the Calendar / Eco-Dex switch on the Progress screen.

**PopupMenuButton** — dropdown menu.
- `lib/features/actions/presentation/widgets/action_sort_dropdown.dart:18`
- *Emulator:* the sort menu on the Action Log.

### Cards & Rows

**Card** — rounded, slightly elevated container for grouped content.
- `lib/features/actions/presentation/widgets/action_card.dart`
- `lib/features/challenge/presentation/widgets/daily_challenge_card.dart`
- `lib/shared/widgets/stat_card.dart`
- *Emulator:* every action tile, the Daily Challenge card on Home, the
  level/points cards on the mascot screen.

### Interactions

**InkWell / GestureDetector** — adds tap handling (InkWell also shows a
ripple).
- `lib/app/main_shell.dart:156` (nav tabs)
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:268`
- *Emulator:* the water-droplet ripple when tapping nav icons.

**Dismissible** — swipe-to-dismiss row.
- *Emulator:* swipe-to-delete behavior on list rows (where used).

### Progress & Status

**CircularProgressIndicator** — spinning loader.
- `lib/features/eco_fact/presentation/screens/eco_fact_screen.dart:35`
- *Emulator:* the spinner while facts load.

**LinearProgressIndicator** — horizontal bar.
- `lib/shared/widgets/level_progress_bar.dart`
- *Emulator:* the mascot XP/level bar.

**RefreshIndicator** — pull-to-refresh gesture.
- *Emulator:* pull down on scrollable lists to reload.

### Animation

**AnimatedContainer / AnimatedSize / AnimatedOpacity / AnimatedRotation** —
animate property changes over a duration.
- `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart:277`
- *Emulator:* the chevron rotation and reveal when expanding the "Science"
  section.

**Hero** — shared-element transition between screens.
- *Emulator:* smooth image hand-off when opening an Eco-Dex entry.

**flutter_animate** — package for chained animations.
- `lib/features/mascot/presentation/widgets/egg_hatching_celebration.dart:5`
- *Emulator:* the egg-hatching celebration.

### Forms

**Form + TextFormField + GlobalKey<FormState>** — grouped inputs with
validation.
- `lib/features/auth/presentation/screens/login_screen.dart:84`
- *Emulator:* inline errors on the login form.

---

## Part 2 — Riverpod State Management

**Provider** — read-only value exposed to the widget tree.
- `lib/features/actions/presentation/providers/actions_providers.dart:31`

**`@riverpod`** — codegen annotation; produces a matching `.g.dart` file.
- `lib/app/router.dart:60`

**ConsumerWidget / ConsumerStatefulWidget** — widgets with access to `ref`.
- `lib/features/sdg/presentation/screens/home_screen.dart:18`
- `lib/features/actions/presentation/screens/action_log_screen.dart:17`

**`ref.watch` / `ref.read` / `ref.listen`** — read providers.
- `ref.watch(x)` — subscribe; rebuild when `x` changes.
- `ref.read(x)` — one-shot read (inside callbacks).
- `ref.listen(x, cb)` — react to changes without rebuilding.

**Stream provider** — returns `Stream<T>` (real-time Firestore).
- `lib/features/actions/presentation/providers/actions_providers.dart:78`

**Future provider** — returns `Future<T>` (one-shot async load).
- `lib/features/mascot/presentation/providers/mascot_providers.dart:22`

**`AsyncValue<T>`** — wraps async state (`loading` / `data` / `error`). Read
with `.when(...)`, `.whenOrNull(...)`, `.asData?.value`.
- `lib/features/eco_fact/presentation/screens/eco_fact_screen.dart:24`

**StateNotifier / `.notifier`** — mutable state with methods.
- `lib/features/actions/presentation/screens/action_log_screen.dart:93`
  (`ref.read(x.notifier).setQuery(...)`)

---

## Part 3 — Routing

**GoRouter** — the routing library (`lib/app/router.dart`).

**GoRoute / StatefulShellRoute / StatefulShellBranch** — route primitives.
StatefulShellRoute is what gives each bottom-nav tab its own back stack.

**`AppRoutes`** — typed path constants (`lib/app/router.dart:42`).

**`context.go(path)` / `context.push(path)`** — navigate.
- `lib/app/main_shell.dart:104`

---

## Part 4 — File Types You Should Recognize

### Localization

**`.arb` (Application Resource Bundle)** — JSON-like files for translated
strings.
- `lib/core/l10n/app_en.arb`, `app_es.arb`, `app_ja.arb`
- Keys you define (`pointsLabel`) become methods on `AppLocalizations`.

**`AppLocalizations.of(context).<key>`** — how UI code reads strings.
- Generated into `lib/core/l10n/generated/app_localizations.dart` by
  `flutter gen-l10n`. Never edit generated files.

**`l10n.yaml`** — config for `flutter gen-l10n`.

### Generated Files (never edit)

**`*.freezed.dart`** — generated by Freezed; provides `copyWith`, equality,
`toString`. Paired with a `*.dart` model.

**`*.g.dart`** — generated by either:
- `json_serializable` (pairs with a Freezed model for `fromJson`/`toJson`), or
- `riverpod_generator` (pairs with a file of `@riverpod` functions).

Regenerate with:
```
dart run build_runner build --delete-conflicting-outputs
```

### Models (Freezed pattern)

Example (`lib/features/actions/data/models/action_log_model.dart`):
```dart
part 'action_log_model.freezed.dart';
part 'action_log_model.g.dart';

@freezed
abstract class ActionLogModel with _$ActionLogModel {
  const factory ActionLogModel({
    required String id,
    required String actionId,
    required int points,
    @RequiredTimestampConverter() required DateTime loggedAt,
  }) = _ActionLogModel;

  factory ActionLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActionLogModelFromJson(json);
}
```

### JSON Data (bundled assets)

`data/app/` — bundled into the app via `pubspec.yaml`:
- `eco_dex_entries.json`
- `eco_facts.json`
- `mascot_species.json`
- `sdg_goals.json` / `sdg_resources.json` / `sdg_targets.json`
- `challenge_templates.json`

Loaded with `rootBundle.loadString(...)` then `jsonDecode(...)`.

### Clean Architecture Layers

Each feature in `lib/features/<name>/`:
- **data/models/** — Freezed models (Firestore + JSON shapes).
- **data/datasources/** — raw Firestore CRUD.
- **data/repositories/** — business logic combining sources.
- **domain/** — entities, services, pure logic.
- **presentation/screens/** — full-screen widgets.
- **presentation/widgets/** — reusable UI pieces.
- **presentation/providers/** — Riverpod providers exposing data to UI.
- **`<name>.dart`** — barrel file that re-exports the feature's public API.

### Config Files

- **`pubspec.yaml`** — deps, assets, fonts.
- **`analysis_options.yaml`** — lint rules (strict mode enabled).
- **`l10n.yaml`** — localization config.
- **`firebase.json` / `firestore.rules` / `firestore.indexes.json`** —
  Firebase project, security rules, query indexes.

### Core Utilities Worth Knowing

- **`lib/core/constants/ui_constants.dart`** — `Spacing`, `Radii`,
  `Durations`, `Opacities`. Use these instead of raw numbers.
- **`lib/core/theme/app_theme.dart`** — light/dark ThemeData.
- **`lib/core/theme/app_colors.dart`** — palette constants.
- **`lib/core/utils/firestore_converters.dart`** — DateTime ↔ Timestamp
  converters used in Freezed models.

---

## Quick Reference Table

| You see in emulator | Widget | File to open |
|---|---|---|
| 5-tab bottom bar | `BottomAppBar` | `lib/app/main_shell.dart` |
| Home header that shrinks | `SliverAppBar` | `lib/features/sdg/presentation/screens/home_screen.dart` |
| Log-action confirmation popup | `AlertDialog` | `lib/features/actions/presentation/widgets/action_log_confirmation_dialog.dart` |
| Sheet from bottom on day tap | `showModalBottomSheet` | `lib/features/progress/presentation/widgets/day_detail_bottom_sheet.dart` |
| Action tile in list | `Card` | `lib/features/actions/presentation/widgets/action_card.dart` |
| SDG filter pills | `FilterChip` | `lib/features/actions/presentation/widgets/sdg_filter_chips.dart` |
| Calendar / Eco-Dex toggle | `SegmentedButton` | `lib/features/progress/presentation/screens/progress_screen.dart` |
| Mascot XP bar | `LinearProgressIndicator` | `lib/shared/widgets/level_progress_bar.dart` |
| Egg-hatch celebration | `flutter_animate` | `lib/features/mascot/presentation/widgets/egg_hatching_celebration.dart` |
| Fact inbox rows | `ListTile` in `ListView.separated` | `lib/features/eco_fact/presentation/screens/eco_fact_screen.dart` |
