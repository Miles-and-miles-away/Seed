# PDR: First-Login Walkthrough -- Post-Design Review

**Status:** Built. Owner decisions O1-O4 settled (Appendix A).
`lib/features/walkthrough/` and `test/features/walkthrough/` hold the
feature; section 7 records what landed.
**Purpose:** The working record for building the feature (type 4a):
standing decisions and why, the product rules, the item list, the UI
and copy requirements. No evidence base applies.
**Companion docs:** `APP_PAGES.md` (every surface the walkthrough
points at), `DOCUMENT_TYPES.md` section 4.

---

## 1. Problem

Testers open the app and do not know what it can do. The calculators,
the quiz, the eco fact inbox and the Eco-Dex are all reached from
icons or segments that nothing announces. The mascot is chosen and
then the user is dropped on Home with no direction.

## 2. Standing Decisions

- **W1. Discovery, not a tour.** No forced multi-screen carousel. The
  app stays fully usable from the first second. Unfound features
  shimmer; the character explains each one when it is opened.
- **W2. The character does the talking.** Every explanation is a
  speech bubble beside the user's own mascot, in the mascot's name.
  This is why the walkthrough starts after mascot selection and never
  before.
- **W3. Short pages, tapped through.** An explanation is an ordered
  list of pages. Each page is one to two sentences. "Next" while pages
  remain, "Got it" on the last. The checklist appears on the last page
  only, so the tick lands after the explanation, not mid-way.
- **W4. A tick is earned by arriving, not by doing.** Opening the
  surface ticks it. Logging an action, finishing a quiz round or
  building a comparison is not required. The walkthrough shows where
  things are; the features teach themselves.
- **W5. One pop per item, ever.** Once ticked, an item never pops
  again and its shimmer stops. The only way back is the Settings reset
  (W8).
- **W6. Nested surfaces fold into one item.** The three calculators
  are one item (pops on the chooser sheet, three pages). The three
  Progress segments are one item (pops on the tab, three pages). No
  shimmer inside a surface that already popped.
- **W7. Nothing is awarded.** No points, no Eco-Dex entry, no mascot
  effect for completing the checklist. Completion is a confetti page
  from the character and nothing more (O4).
- **W8. Reset lives in Settings.** A "Replay walkthrough" tile clears
  the found set and the intro flag. Existing testers use it once;
  after that it is a harmless curiosity. It stays in the build.
- **W9. State lives in `settings` on the user doc.** One field: a
  `walkthroughFound` string list of `WalkthroughItem` names, with the
  intro stored as `intro` alongside the checklist ids. The unused
  `hasSeenOnboarding` flag stays untouched: one list means one
  repository method, one reset and one provider. `firestore.rules`
  only checks `d.settings is map`, so no rules change and no rules
  test. It survives reinstall and syncs across devices, which a
  SharedPreferences flag would not.
- **W13. No user, no walkthrough.** `walkthroughFoundProvider` is null
  while signed out, so nothing shimmers or pops on the auth screens or
  in widget tests that never sign in. A settings document that fails
  to parse still keeps its found list, or the tour would replay on
  every start.
- **W14. Celebrations first, then the intro, then the items.** Nothing
  is pending until a mascot exists and any evolution or egg discovery
  celebration has been shown: the character has to be decided before
  it can talk. No checklist item shimmers or pops before the intro has
  been dismissed. After a Settings replay those celebrations are long
  gone, so the intro shows on the next Home visit.
- **W15. One explanation per tap.** A tap never produces two pops. The
  daily challenge card explains itself and then opens Log Action with
  its trigger disabled. The completed card's "See today's eco-fact"
  link ticks the card silently and lets the inbox explain itself on
  arrival.
- **W10. Existing testers get the intro automatically (O1).**
  `walkthroughFound` is absent on every existing doc, so the intro
  shows on their next Home visit with no action needed. The Settings
  reset is for replays only.
- **W11. One tick per tap (O2).** The daily challenge card ticks item
  2 only, even though it navigates to Log Action. Item 1 ticks when
  the bottom nav button is used.
- **W12. Gold sweep, not gold fill (O3).** The shimmer is a moving
  gold highlight over the anchor's own colours, so the original
  colour stays visible between sweeps. This is what
  `flutter_animate`'s `shimmer` already does: a gradient band that
  travels across the child.

## 3. The Checklist

Seven items. Order is the checklist order the user sees.

| # | Id | Find | Shimmer on | Ticks when | Pages |
|---|----|------|-----------|-----------|-------|
| 1 | `logAction` | Log your first action | Bottom nav `+` (`AppBottomNav`) | `/log-action` opens | 1 |
| 2 | `dailyChallenge` | Today's challenge | `DailyChallengeCard` on Home | Card tapped | 1 |
| 3 | `sdg` | Explore an SDG | `SdgCarousel` on Home | Any `/home/sdg/:goalNumber` opens | 1 |
| 4 | `ecoFact` | Your daily eco fact | `MailIconButton` in Home app bar | `/home/daily-fact` opens | 1 |
| 5 | `calculators` | Meet the calculators | `calculate_outlined` icon on Log Action | `CalculatorChooserSheet.show` | 3 |
| 6 | `quiz` | Play Higher or Lower | `quiz_outlined` icon on Log Action | `/quiz` opens | 1 |
| 7 | `progress` | Track your progress | Progress tab in bottom nav | `/progress` opens | 3 |

Considered and left out:

- Multi-day challenges: on Home already, gated behind the daily
  challenge, discovers itself.
- Where your energy goes (`/energy-explore`): sits beside the quiz
  icon. Two shimmering icons side by side dilute both. Mentioned in
  the energy page of item 5 instead.
- Mascot tab, Profile tab, My Goal, action history, Settings: low
  discovery value for a first session, or self-explanatory.

## 4. Flow

1. User completes `/mascot-selection`. `context.go(appRoutes.home)`
   fires as today.
2. Home builds. If `intro` is not in `walkthroughFound`, the intro
   overlay shows: the character greets by name, two pages, then the
   full checklist with nothing ticked. "Let's go" dismisses and adds
   `intro` to the list. The overlay is modal, so nothing is tappable
   while it is up.
3. From then on every unticked item's anchor shimmers.
4. Opening an anchored surface with its id unticked shows that item's
   overlay: character, pages, checklist on the last page with the new
   tick. The underlying surface is already built underneath, so
   dismissing lands the user on it.
5. When the last item ticks, the last page of that item is followed by
   one extra completion page with confetti ("You've found
   everything").
6. Settings > "Replay walkthrough" empties the list. The intro shows
   again the next time Home is on screen: a trigger only fires while
   its subtree is visible (`TickerMode`), so a reset made from Settings
   does not pop the intro over the Settings screen.

Existing users (rolled out mid-test): see W10.

## 5. UI / Copy Requirements

- **Overlay.** Reuse `CelebrationOverlay` from
  `lib/shared/widgets/celebration_overlay.dart` (full-screen scrim,
  children column) under a `PopScope` that ignores system back, so the
  buttons are the only way out. Character via `MascotDisplay` (its gaze
  follows the pointer, which suits a character that talks), name from
  `activeMascotProvider`. The page count is frozen when the overlay
  opens so a found-set change from another device cannot pull a page
  out from under the user. No new overlay primitive.
- **Bubble.** One `Card` with the page text. No tail, no animation
  beyond the overlay's own.
- **Shimmer.** `flutter_animate` is already a dependency and
  `max_evolution_card.dart` already does
  `.animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(...)`.
  One wrapper widget `WalkthroughShimmer(item, child)` that sweeps
  `AppColors.gold` at `opacityModerate` for 1.5 s with a 2 s gap while
  the item is pending, inside its own `RepaintBoundary`, and returns
  `child` untouched otherwise. The sweep leaves the anchor's own colour
  visible between passes (W12). Anchors wrap their existing widget; no
  anchor changes its own code.
- **Confetti.** The completion page reuses `TimedConfettiLayer` in
  `lib/shared/widgets/confetti_painter.dart`: the Eco-Dex
  celebration's run-then-fade layer, moved to shared so both use one
  widget. No new painter.
- **Checklist.** Plain `Column` of rows: check icon (filled when
  found), label. The current item's row is highlighted. Ticked rows
  keep their tick in every later pop.
- **Copy.** EN/JA/ES in the ARB files under a `walkthrough` prefix.
  UK spelling. One to two sentences per page, under about 140
  characters, so a page never wraps past four lines at the largest
  text scale. Draft EN copy in section 6; JA and ES written natively
  once EN is signed off.
- **Accessibility.** The overlay traps focus and is dismissible by
  its buttons only. The shimmer is decorative and carries no
  semantics. Under Android's remove-animations or iOS Reduce Motion
  the shimmer is off and a static gold border is drawn instead.
- **Analytics.** `walkthrough_item_found` with `item` param,
  `walkthrough_completed`, `walkthrough_reset`. Three new
  `AnalyticsService` methods following `_log`.

## 6. Copy (EN)

The ARB is the source; this is a readable mirror. `{name}` is the
mascot's name. Feature names follow the app's existing terms
(eco-fact, SDGs, daily goal, "Higher or lower?").

**Intro (after mascot selection)**
1. "Hi, I'm {name}. Seed turns small everyday choices into a habit, and I grow as you go."
2. "There's more here than meets the eye. I've made a list of things to find. Anything glowing gold is still waiting for you."

**1. Log your first action**
1. "This is the heart of Seed. Pick something you did today and I'll count the carbon it saved."

**2. Today's challenge**
1. "One fresh challenge every day. Complete it to unlock today's eco-fact and keep your challenge streak alive."

**3. Explore an SDG**
1. "The 17 SDGs are the world's to-do list. Each one shows you the targets, the progress so far, and actions that help."

**4. Your daily eco-fact**
1. "A new eco-fact lands here every day. Complete today's challenge to open it."

**5. Meet the calculators**
1. "Three calculators compare two choices side by side. Transport: two routes, any mix of modes. Took the greener one? Log it as a custom action."
2. "Food: two meals, ingredient by ingredient. Chose the lighter plate? Log that as a custom action too."
3. "Home energy: two routines, from showers to tumble drying. It teaches but never scores. The lightning icon beside it ranks your whole home."

**6. Play Higher or lower**
1. "Two things, one question: which has the bigger footprint? Build a streak. No points, just bragging rights."

**7. Track your progress**
1. "Calendar: every day you logged something, and your daily goal."
2. "Impact: the carbon you've saved, translated into trees, car kilometres and phone charges."
3. "Eco-Dex: planet facts you discover by logging actions. Each one is a small piece of knowledge, never points."

**Completion**
1. "That's everything. You know Seed better than most now. Let's grow."

## 7. What Landed

- `UserSettingsModel.walkthroughFound` (list of item names) and
  `AppConstants.fieldWalkthroughFound`. Regenerated freezed output.
- `SettingsRepository.markWalkthroughFound` (arrayUnion) and
  `resetWalkthrough`; the matching `SettingsNotifier` methods; and
  `walkthroughFoundProvider`, null while signed out or loading (W13).
- `lib/features/walkthrough/`: `WalkthroughItem` (ids, labels and page
  keys; the single source of the section 3 table),
  `walkthroughPendingProvider(item)`, `WalkthroughShimmer` (gold sweep
  with a two-second gap, static gold border under reduced motion),
  `WalkthroughOverlay` (mascot, one card per page, checklist on the
  last page, confetti on the completion page) and `WalkthroughTrigger`
  (fires the overlay once, post-frame, while visible and pending;
  re-arms after a reset).
- Seven shimmer anchors: the Progress and Log Action nav items, the
  daily challenge card and SDG carousel on Home, the mail icon, and
  the calculator and quiz icons on Log Action.
- Seven triggers: Log Action (only when opened without a category, so
  the challenge card ticks item 2 alone, W11), the calculator chooser
  sheet, the eco fact inbox, SDG detail, the quiz, Progress, and the
  Home intro (only once a mascot exists). The daily challenge card
  explains itself on tap, then navigates.
- Settings > Preferences > "Replay walkthrough" with a confirm dialog.
- `walkthrough_item_found`, `walkthrough_completed` and
  `walkthrough_reset` analytics events.
- ARB strings under `walkthrough*` and `settingsReplayWalkthrough*` in
  EN, JA and ES.
- `TimedConfettiLayer` carries the shared `celebrationConfettiColors`
  palette, so the Eco-Dex and egg-hatching celebrations share it too.
- Tests: item invariants across all three locales; ARB key parity
  across EN, JA and ES; repository arrayUnion and reset; the notifier
  methods and their analytics; the found and pending providers under
  every gate (signed out, loading, no mascot, celebration pending,
  before the intro); the shimmer sweeping, resting once found and
  drawing a border under reduced motion; the trigger popping exactly
  once, waiting while offstage, re-arming after a reset and ignoring
  system back; the overlay's paging, checklist ticks, completion page
  with confetti and analytics, and intro variant; the daily challenge
  card on both paths (W15); the Log Action, Home and bottom nav
  wiring; and the Settings replay tile's confirm and cancel paths.
  Test note: never read the found list through `watchSettings().first`
  under the fake clock, a fake Firestore snapshot stream cancelled
  there never lets the tree dispose; use a one-shot get.

## 8. Open Decisions

None. O1-O4 resolved, see Appendix A.

## Appendix A: Decision History

| Id | Question | Decision | Rule |
|----|----------|----------|------|
| O1 | Existing testers: automatic intro or reset only? | Automatic | W10 |
| O2 | Daily challenge card tap also ticks item 1? | No | W11 |
| O3 | Shimmer colour | Gold sweep over the anchor's own colour | W12 |
| O4 | Completion page offers anything? | Confetti only, no action | W7 |
