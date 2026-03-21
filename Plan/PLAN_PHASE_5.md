# Phase 5: Gamification & Daily Engagement

**Version:** 2.0
**Created:** February 2026
**Updated:** March 20, 2026
**Status:** In Progress (5.1 complete, 5.2 nearly complete)

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Reward System Design](#reward-system-design)
3. [Implementation Order](#implementation-order)
4. [Daily Eco-Fact](#daily-eco-fact)
5. [Daily Challenges](#daily-challenges)
6. [Eco-Dex](#eco-dex)
7. [Growing Ecosystem (Garden)](#growing-ecosystem-garden)
8. [Art Asset Strategy](#art-asset-strategy)
9. [Testing Strategy](#testing-strategy)
10. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 5 adds four interlocking engagement systems that give users a
reason to open Seed every day. Each feature reinforces the others:
challenges motivate action, actions grow the garden and unlock
Eco-Dex entries, and completing the challenge reveals the daily
eco-fact.

### Design Philosophy

| Lever | Feature | Effect |
|-------|---------|--------|
| Progress visualization | Growing Ecosystem | "I can see my impact" |
| Variable rewards | Daily Challenges | "What's today's mission?" |
| Completion drive | Eco-Dex | "I want to fill the album" |
| Curiosity / learning | Daily Eco-Fact | "What will I learn today?" |

### Key Objectives

- Add a personal garden where the mascot lives, growing with actions
- Add 1 daily challenge per user that unlocks the daily eco-fact
- Add a milestone-driven collection album (Eco-Dex, ~50 entries)
- Curate 365 sustainability facts, gated behind daily challenges

### Feature Summary

| Feature | Description | Priority | Complexity | Status |
|---------|-------------|----------|------------|--------|
| 5.1 Daily Eco-Fact | 365 facts, mail icon, gated behind challenge | P0 | Low | Done |
| 5.2 Daily Challenges | 1 pseudorandom daily mission per user | P0 | Medium | Nearly Done |
| 5.3 Eco-Dex | ~50 collectible entries, milestone/streak triggers | P0 | Medium | Planned |
| 5.4 Growing Ecosystem | Personal garden with mascot, ~15 plants | P0 | High | Planned |

---

## Reward System Design

### Core Principle: No Fake Points

Points represent real CO2 savings. They cannot be inflated by
challenges, streaks, or any other engagement mechanic. Every point
earned corresponds to an actual eco-friendly action taken.

### How Everything Connects

```
CORE LOOP (real impact)
  Log action -> earn CO2-based points (real data)
  Points -> level -> mascot evolution
  Category action counts -> garden plants appear and grow
  Streak -> streak bonus multiplier on points (existing)

DAILY ENGAGEMENT (knowledge reward, not points)
  Complete daily challenge -> unlocks today's eco-fact
  Missed fact is gone forever (strict -- gaps in your calendar)
  Challenge streak tracked (consecutive days completing)

MULTI-DAY CHALLENGES (special achievements)
  User-initiated extended challenges (Veganuary, Zero Waste Week)
  Completion -> special Eco-Dex entries

META-COLLECTION (completionist hook)
  Eco-Dex entries unlock from ALL progress types:
    - Action milestones (total actions logged)
    - Streak milestones (consecutive days)
    - Level milestones (levels reached)
    - SDG breadth (unique SDGs supported)
    - Category mastery (actions per category)
    - Challenge streak milestones (consecutive challenges completed)
    - Multi-day challenge completion
    - Garden milestones (plants unlocked)
```

### The Daily Loop

```
Open app
  |
  v
See daily challenge on home screen
  |
  v
Log actions to complete it
  |                        |
  v                        v
Actions grow garden    Actions drive Eco-Dex discoveries
  |
  v
Challenge complete -> mail icon unlocks -> read daily fact
  |
  v
Challenge streak grows -> more Eco-Dex entries
  |
  v
Come back tomorrow
```

### What Rewards What

| Action | Reward | Type |
|--------|--------|------|
| Log an action | CO2 points (real) | Currency |
| Accumulate points | Level up, mascot evolution | Progression |
| Log category actions | Garden plants grow | Visual |
| Hit milestones | Eco-Dex entries unlock | Collection |
| Complete daily challenge | Today's eco-fact revealed | Knowledge |
| Maintain challenge streak | Eco-Dex entries unlock | Collection |
| Complete multi-day challenge | Special Eco-Dex entries | Collection |

---

## Implementation Order

Build order is driven by code dependencies between features:

```
5.1  Daily Eco-Fact       (standalone, creates mail icon + fact system)
 |
5.2  Daily Challenges     (hooks into action logging, gates eco-fact)
 |
5.3  Eco-Dex              (triggered by actions, streaks, challenges)
 |
5.4  Growing Ecosystem    (visual capstone, needs art assets)
```

**Rationale:**

1. **Eco-Fact first** -- simplest feature. Establishes the mail icon
   and fact data infrastructure. No dependencies on other Phase 5
   features.
2. **Challenges second** -- hooks into action logging and gates the
   eco-fact. Once challenges work, the daily engagement loop is
   complete.
3. **Eco-Dex third** -- benefits from having both action logging and
   challenge completion as trigger sources for unlocking entries.
4. **Garden last** -- most complex, requires art assets (which take
   time to create). Visually ties everything together.

---

## Daily Eco-Fact

### 5.1 Daily Eco-Fact

**Priority:** P0 | **Complexity:** Low | **Status:** Done

365 curated sustainability facts, one per day. A mail icon in the
app bar shows a red notification dot when the daily fact is available.
Fact is locked behind daily challenge completion via
`isEcoFactLockedProvider`. The `isLocked` parameter on `EcoFactCard`
is driven by the challenge completion state. Viewed dates are tracked in `viewedFactDates` on the user doc.

#### Design

```
Home Screen app bar:
+----------------------------------------------+
|  Seed                              [mail]    |
+----------------------------------------------+
                                        ^
                                   red dot when
                                   fact available

Before challenge complete (tapping mail):
+----------------------------------------------+
|          Today's Eco-Fact                    |
|                                              |
|  +----------------------------------------+ |
|  |                                        | |
|  |  Complete today's challenge to         | |
|  |  unlock this fact!                     | |
|  |                                        | |
|  |  [padlock icon]                        | |
|  |                                        | |
|  +----------------------------------------+ |
|                                              |
|  -- Fact Calendar --                         |
|                                              |
|  Mar 2026                                    |
|  M  T  W  T  F  S  S                        |
|  .  .  .  .  .  .  1                        |
|  2  3  4  5  x  7  8     <- x = missed      |
|  9  10 11 12 13 [14]     <- today            |
|                                              |
+----------------------------------------------+

After challenge complete:
+----------------------------------------------+
|          Today's Eco-Fact                    |
|                                              |
|  +----------------------------------------+ |
|  |  "Did you know?"                       | |
|  |                                        | |
|  |  Skipping one beef meal saves ~3 kg    | |
|  |  of CO2 -- the same as not driving     | |
|  |  for 15 km.                            | |
|  |                                        | |
|  |  Source: Poore & Nemecek, Science 2018 | |
|  +----------------------------------------+ |
|                                              |
|  -- Fact Calendar --                         |
|  (tap past dates to re-read earned facts)    |
|  (missed dates show as gaps)                 |
|                                              |
+----------------------------------------------+
```

#### Data Model

Facts are baked into the app as a const list. Updated once a year.

```dart
class EcoFact {
  final int dayOfYear;        // 1-365
  final String category;      // mythBuster, comparison,
                              // positiveNews, individual,
                              // natureWonder
  final String factEn;
  final String factEs;
  final String factJa;
  final String sourceEn;
  final String? sourceUrl;
  final List<int> relatedSdgs;
}
```

#### Fact Categories

| Category | Count | Style |
|----------|-------|-------|
| Myth Busters | ~80 | "Actually, [common belief] is wrong because..." |
| Surprising Comparisons | ~80 | "Doing X saves the same CO2 as Y" |
| Positive News | ~80 | "Renewable energy now powers X% of..." |
| Individual Impact | ~60 | "If everyone did X, it would save..." |
| Nature Wonders | ~65 | "Did you know that [natural fact]..." |

#### Sample Facts

**Myth Busters:**
- "Rinsing recyclables is unnecessary. A quick scrape
  is enough -- recycling facilities wash everything.
  Save water, still recycle." (EPA)

**Surprising Comparisons:**
- "Skipping one beef meal saves ~3 kg of CO2 -- the
  same as not driving for 15 km." (Poore & Nemecek,
  Science 2018)

**Positive News:**
- "The ozone layer is on track for full recovery by
  2066, proving that global environmental action works."
  (UN Environment Programme)

**Individual Impact:**
- "If every household in the US replaced one beef meal
  per week with a plant-based alternative, it would
  save the equivalent CO2 of taking 7.6 million cars
  off the road." (WRI)

**Nature Wonders:**
- "A single mature tree can absorb 48 pounds of CO2 per
  year and release enough oxygen for two people." (USDA
  Forest Service)

#### Storage

- **Fact definitions:** JSON asset (`data/app/eco_facts.json`),
  loaded via `rootBundle.loadString()`, cached in FutureProvider
- **Fact selection:** `dayOfYear(DateTime.now())` determines fact.
  Same fact for all users on the same day. Leap-year day 366 wraps
  to day 1.
- **Viewed facts:** Firestore `users/{uid}` document
  - `viewedFactDates`: List<String> (date strings, e.g. "2026-03-14")
  - Written via `FieldValue.arrayUnion` on screen open
- **Mail icon state:** Derived from whether today's date is in
  `viewedFactDates` AND whether the daily challenge is complete
  (via `isEcoFactLockedProvider`)

All 365 facts are complete and audited.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create EcoFact model | Plain immutable class with locale-aware getters | Done |
| Write 365 eco-facts | All 365 curated with sources, EN only (JA/ES deferred) | Done |
| Create eco_facts_data.dart | JSON asset loader + dayOfYear helper | Done |
| Create EcoFactScreen | Fact card + calendar, auto-marks viewed | Done |
| Create MailIconButton widget | Icon with Badge red dot | Done |
| Create EcoFactCard widget | Category chip, source, SDG icons, locked state | Done |
| Create FactCalendar widget | Month grid with viewed/today/future styling | Done |
| Create eco_fact_providers | 7 providers: facts, today, viewed, calendar, notifier | Done |
| Add viewedFactDates to AppUserModel | Freezed field + codegen | Done |
| Add mail icon to home screen app bar | Red dot when unread | Done |
| Add route | `/home/daily-fact` nested under home tab | Done |
| Localize strings | 11 keys in EN/JA/ES (5 categories + 6 UI) | Done |
| Write tests | 57 tests across 7 files, all passing | Done |

#### Files Created

```
lib/features/eco_fact/
+-- eco_fact.dart                        # Barrel file
+-- data/
|   +-- models/
|   |   +-- eco_fact_model.dart          # Plain immutable class
|   +-- eco_facts_data.dart              # JSON loader + helpers
+-- presentation/
    +-- providers/
    |   +-- eco_fact_providers.dart       # 7 providers + notifier
    |   +-- eco_fact_providers.g.dart     # Generated
    +-- screens/
    |   +-- eco_fact_screen.dart          # Main screen
    +-- widgets/
        +-- eco_fact_card.dart            # Fact display + locked state
        +-- fact_calendar.dart            # Month grid
        +-- mail_icon_button.dart         # Badge icon button
```

#### Files Modified

- `lib/features/auth/data/models/app_user_model.dart` -- added
  `viewedFactDates` field
- `lib/features/sdg/presentation/screens/home_screen.dart` -- added
  `MailIconButton` to app bar actions
- `lib/app/router.dart` -- added `dailyFact` route under home tab
- `lib/core/l10n/app_en.arb` -- 11 new localization keys
- `lib/core/l10n/app_ja.arb` -- 11 new localization keys
- `lib/core/l10n/app_es.arb` -- 11 new localization keys

#### Test Files

```
test/features/eco_fact/
+-- data/
|   +-- models/eco_fact_model_test.dart       # 11 tests
|   +-- eco_facts_data_test.dart              # 15 tests
+-- presentation/
    +-- providers/eco_fact_providers_test.dart # 11 tests
    +-- screens/eco_fact_screen_test.dart      # 4 tests
    +-- widgets/
        +-- eco_fact_card_test.dart            # 8 tests
        +-- fact_calendar_test.dart            # 4 tests
        +-- mail_icon_button_test.dart         # 4 tests
```

---

## Daily Challenges

### 5.2 Daily Challenges

**Priority:** P0 | **Complexity:** Medium | **Status:** Nearly Done

One daily challenge per user. Pseudorandom, different per user,
avoids recent repeats. Completing the challenge unlocks the daily
eco-fact. No bonus points awarded -- the reward is knowledge, not
currency inflation.

Includes a multi-day challenge framework for extended challenges
like Veganuary or Zero Waste Week.

#### Design

```
Home Screen:
+----------------------------------------------+
|                                              |
|  +----------------------------------------+ |
|  |  Today's Challenge                     | |
|  |                                        | |
|  |  "Log a Food action today"            | |
|  |                                        | |
|  |  [ ] Not yet completed                | |
|  |  -- or --                             | |
|  |  [x] Complete! Eco-fact unlocked      | |
|  +----------------------------------------+ |
|                                              |
|  +----------------------------------------+ |
|  |  Active: Veganuary (Day 12/30)        | |
|  |  =================>........  12/30    | |
|  +----------------------------------------+ |
|                                              |
+----------------------------------------------+
```

#### Daily Challenge Templates

~30 templates covering different action categories and engagement
patterns. No difficulty tiers -- each challenge is roughly equal
effort (log 1-2 actions of a specific type).

| Type | Example | Condition |
|------|---------|-----------|
| Category | "Log a Food action" | Log any action in category X |
| SDG | "Log an action for SDG 13 (Climate)" | Log action with SDG X |
| Any action | "Log any action today" | Log 1 action |
| Multiple | "Log 2 actions today" | Log N actions |
| New action | "Try an action you haven't logged before" | Log new action |
| Streak | "Keep your streak alive!" | Log at least 1 action |
| High impact | "Log an action worth 20+ points" | Log high-CO2 action |
| Multi-category | "Log in 2 different categories" | Category breadth |

```dart
class ChallengeTemplate {
  final String id;
  final ChallengeType type;
  final String titleEn;
  final String titleEs;
  final String titleJa;
  final Map<String, dynamic> params; // category, sdgNumber, count
}
```

#### Selection Algorithm

Pseudorandom, deterministic per user per day, avoids recent repeats:

```dart
int _dailySeed(String userId, DateTime date) {
  final dateKey = '${date.year}-${date.month}-${date.day}';
  return '$userId:$dateKey'.hashCode;
}

ChallengeTemplate selectDailyChallenge(
  String userId,
  DateTime date,
  List<String> recentIds,
) {
  final rng = Random(_dailySeed(userId, date));
  final available = TEMPLATES.where(
    (t) => !recentIds.contains(t.id),
  ).toList();
  return available[rng.nextInt(available.length)];
}
```

- Different users get different challenges on the same day
- Exclude last 7 completed challenge template IDs
- Store recent IDs in SharedPreferences

#### Multi-Day Challenge Framework

Extended challenges that span multiple days. User-initiated from
a challenges detail screen.

| ID | Template | Duration | Eco-Dex Reward |
|----|----------|----------|----------------|
| `md_vegan_week` | Log vegan_day for 7 consecutive days | 7 days | "Plant Pioneer" entry |
| `md_veganuary` | Log vegan_day for 30 consecutive days | 30 days | "Veganuary Champion" entry |
| `md_zero_waste_week` | Log refuse_disposables + reusable actions daily | 7 days | "Zero Waste Warrior" entry |
| `md_transport_week` | Log only non-car transport for 7 days | 7 days | "Green Commuter" entry |
| `md_streak_14` | Log any action for 14 consecutive days | 14 days | "Fortnight Force" entry |
| `md_streak_30` | Log any action for 30 consecutive days | 30 days | "Monthly Momentum" entry |

Multi-day challenges require a streak counter that persists across
days and resets on a missed day. Stored in Firestore user doc.

```dart
class MultiDayChallenge {
  final String templateId;
  final DateTime startDate;
  final int currentDay;       // consecutive days completed
  final int targetDays;
  final bool completed;
}
```

#### Data Storage

- **Challenge templates:** Const list in app code
- **Recent daily challenge IDs:** SharedPreferences (last 7 IDs)
- **Daily completion state:** Firestore `users/{uid}` document
  - `challengeCompletedDate`: Timestamp (last completion date)
  - `challengeStreak`: int (consecutive days completing challenges)
  - `challengesCompleted`: int (lifetime count, for Eco-Dex)
- **Active multi-day challenge:** Firestore `users/{uid}` document
  - `activeMultiDayChallenge`: Map (templateId, startDate,
    currentDay, targetDays)
  - `completedMultiDayChallenges`: List<String> (template IDs)

#### Completion Detection

Evaluated reactively via Riverpod providers that watch the user's
action log stream. When a newly logged action satisfies the
challenge condition, the challenge is marked complete and the
daily eco-fact is unlocked.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create ChallengeTemplate model | DailyChallengeTemplate + MultiDayChallengeTemplate classes | Done |
| Create DailyChallenge model | Today's resolved challenge with state (via providers) | Done |
| Create MultiDayChallenge model | Extended challenge state (Map on user doc) | Done |
| Write ~30 daily challenge templates | 27 daily templates (3 per category), localized EN/ES/JA | Done |
| Define ~6 multi-day challenge templates | 6 templates with category + duration | Done |
| Create challenge_templates_data.dart | Const list in challenge_templates.dart | Done |
| Create challenge_selection_service.dart | Deterministic selection with recent-ID exclusion | Done |
| Create challenge_providers | 6 providers: today, completion, streak, multi-day, dialog, notifier | Done |
| Add challenge fields to AppUserModel | challengeCompletedDate, streak, recentIds, activeMultiDayChallenge | Done |
| Integrate with action logging | Category match detection + streak update in action_log_repository | Done |
| Challenge completion snackbar | Shown in handle_action_tap after logging | Done |
| Store challenge streak in Firestore | Consecutive completions tracked | Done |
| Store recent challenge IDs | Firestore recentChallengeIds (last 7) | Done |
| Create DailyChallengeCard widget | Home screen card with status | Done |
| Create MultiDayChallengeCard widget | Progress bar for active | Done |
| Create ChallengesScreen | Start/view multi-day challenges | Done |
| Gate eco-fact unlock on completion | isEcoFactLocked provider watches challenge state | Done |
| Add challenge card to home screen | Daily challenge + multi-day progress | Done |
| Add route for challenges screen | go_router route under home tab | Done |
| Localize strings | Challenge UI text (card, screen, dialog) | Done |
| Write tests | Widget tests for cards + screen, eco-fact gating, day change | Done |
| Add day change provider | Detects midnight rollover for reactive updates | Done |

#### Files Created

```
lib/features/challenge/
+-- challenge.dart                         # Barrel file (exports all)
+-- data/
|   +-- challenge_templates.dart           # 27 daily + 6 multi-day templates
|   +-- challenge_selection_service.dart   # Deterministic selection algorithm
+-- presentation/
    +-- providers/
    |   +-- challenge_providers.dart        # 6 providers + notifier
    |   +-- challenge_providers.g.dart      # Generated
    +-- screens/
    |   +-- challenges_screen.dart          # Multi-day start/view
    +-- widgets/
        +-- daily_challenge_card.dart       # Home screen card
        +-- multi_day_challenge_card.dart   # Progress bar card

lib/shared/providers/
+-- day_change_provider.dart               # Midnight rollover detection
```

#### Files Modified

- `lib/features/auth/data/models/app_user_model.dart` -- added
  challengeCompletedDate, challengeStreak, challengesCompleted,
  recentChallengeIds, activeMultiDayChallenge fields
- `lib/features/actions/data/repositories/action_log_repository.dart`
  -- challenge completion detection + streak tracking in logAction
- `lib/features/actions/presentation/utils/handle_action_tap.dart`
  -- challenge completion snackbar
- `lib/core/constants/app_constants.dart` -- recentChallengeIdsLimit
- `lib/features/sdg/presentation/screens/home_screen.dart` -- added
  DailyChallengeCard and MultiDayChallengeCard to home screen
- `lib/features/eco_fact/presentation/providers/eco_fact_providers.dart`
  -- added isEcoFactLocked provider gating fact on challenge completion,
  updated hasUnreadFact to respect lock state
- `lib/app/router.dart` -- added challenges route under home tab
- `lib/app/main_shell.dart` -- updated for challenge navigation
- `lib/shared/providers/providers.dart` -- exports day_change_provider
- `lib/core/l10n/app_en.arb` -- challengeLocked key
- `lib/core/l10n/app_ja.arb` -- challengeLocked key
- `lib/core/l10n/app_es.arb` -- challengeLocked key

#### Test Files

```
test/features/challenge/
+-- presentation/
    +-- screens/challenges_screen_test.dart
    +-- widgets/
        +-- daily_challenge_card_test.dart
        +-- multi_day_challenge_card_test.dart

test/features/eco_fact/
+-- presentation/
    +-- providers/eco_fact_gating_test.dart

test/shared/providers/
+-- day_change_provider_test.dart
```

---

## Eco-Dex

### 5.3 Eco-Dex

**Priority:** P0 | **Complexity:** Medium | **Status:** Planned

A collection album of ~50 discoverable entries unlocked by reaching
milestones, maintaining streaks, and completing challenges. Framed
as "discovery" rather than "achievement" -- users are explorers
uncovering knowledge about the natural world.

Lives under the **Progress tab** alongside the calendar. Later
phases add Achievements (Phase 7) and CO2 Dashboard (Phase 7) to
make Progress a comprehensive "My Progress" hub.

#### Difference from Achievements (Phase 7)

| Aspect | Eco-Dex | Achievements |
|--------|---------|-------------|
| Frame | Discovery / exploration | Accomplishment / badge |
| Content | Real-world knowledge | Congratulatory |
| Visual | Cards with facts | Badge icons |
| Feel | "I learned something" | "I did something" |
| Count | ~50 entries | ~19 badges |

#### Design

```
Progress tab (segmented control at top):

  [Calendar]  [Eco-Dex]

Eco-Dex view:
+----------------------------------------------+
|                                              |
|  23 of 50 discovered                         |
|  ==================>..........  46%          |
|                                              |
|  -- Flora (6/10) --                          |
|  [Oak] [Bamboo] [Mangrove] [???]             |
|  [???] [???]    [Fern]     [???]             |
|  [???] [???]                                 |
|                                              |
|  -- Fauna (4/10) --                          |
|  [Bee] [Otter] [???] [Whale]                 |
|  [???] [???]   [???] [???]                   |
|  [???] [???]                                 |
|                                              |
|  -- Milestones (3/8) --                      |
|  [1kg] [10acts] [???] [???]                  |
|  [???] [???]    [???] [???]                  |
|                                              |
|  (more categories below...)                  |
+----------------------------------------------+

Tapping a discovered entry (bottom sheet):
+----------------------------------------------+
|                                              |
|         [Tree icon]                          |
|                                              |
|            Mighty Oak                        |
|            Flora                             |
|                                              |
|  ------------------------------------------ |
|                                              |
|  A single oak tree absorbs ~22 kg of CO2     |
|  per year and can live for 500+ years.       |
|  Ancient oak forests are among the most      |
|  biodiverse habitats in temperate regions.   |
|                                              |
|  Source: UK Forestry Commission              |
|                                              |
|  ------------------------------------------ |
|                                              |
|  Discovered: March 14, 2026                 |
|  Unlocked by: 5 recycling actions           |
|                                              |
+----------------------------------------------+

Tapping a locked entry (bottom sheet):
+----------------------------------------------+
|                                              |
|         [??? silhouette]                     |
|                                              |
|            ???                               |
|            Flora                             |
|                                              |
|  ------------------------------------------ |
|                                              |
|  Log 5 more recycling actions to discover    |
|  this entry.                                 |
|                                              |
+----------------------------------------------+
```

#### Entry Categories (~50 entries)

| Category | Count | Trigger Types |
|----------|-------|---------------|
| Flora | 10 | Category actions (food, recycling) |
| Fauna | 10 | Category actions (water, consumption) |
| Elements | 8 | Category actions (energy, transport) |
| SDG World | 8 | SDG breadth (support N different SDGs) |
| Eco-Pioneers | 7 | Level milestones |
| Milestones | 7 | Total actions, CO2 saved, streaks |
| Challenge | ~6 | Challenge streak, multi-day completion |
| Garden | ~4 | Garden plant milestones |

#### Sample Entries

**Flora (unlocked by Food/Recycling actions):**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `flora_01` | Mighty Oak | 5 recycling actions | A single oak tree absorbs ~22 kg of CO2 per year and can live for 500+ years. |
| `flora_02` | Bamboo Sprint | 10 food actions | Bamboo can grow up to 91 cm in a single day, making it the fastest-growing plant on Earth. |
| `flora_03` | Mangrove Shield | Save 5 kg CO2 | Mangrove forests store up to 4x more carbon per hectare than rainforests. |

**Fauna (unlocked by Water/Consumption actions):**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `fauna_01` | Honeybee | 5 consumption actions | Bees pollinate ~75% of the world's flowering plants and 35% of food crops. |
| `fauna_02` | Sea Otter | 10 water actions | Sea otters maintain kelp forests that absorb 12x more CO2 than open ocean. |

**Challenge (unlocked by challenge engagement):**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `chal_01` | Steady Hand | 7-day challenge streak | Consistency beats intensity: small daily actions compound to massive impact over time. |
| `chal_02` | Plant Pioneer | Complete Vegan Week | A plant-based diet reduces food-related emissions by up to 73%. (Poore & Nemecek, 2018) |
| `chal_03` | Veganuary Champion | Complete Veganuary (30 days) | If everyone went plant-based, global farmland use would drop 75%. |

**Garden (unlocked by garden growth):**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `garden_01` | First Bloom | 3 garden plants unlocked | Even small green spaces in cities reduce local temperatures by up to 5C. |
| `garden_02` | Thriving | 10 garden plants unlocked | Urban gardens support up to 35% of local pollinator populations. |

#### Data Models

```dart
@freezed
class EcoDexEntry with _$EcoDexEntry {
  const factory EcoDexEntry({
    required String id,
    required String category,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required String factEn,
    required String factJa,
    required String factEs,
    String? sourceUrl,
    required String iconName,        // Material icon or asset
    required EcoDexCondition condition,
  }) = _EcoDexEntry;
}

@freezed
class EcoDexCondition with _$EcoDexCondition {
  // By total actions logged
  const factory EcoDexCondition.totalActions({
    required int count,
  }) = TotalActionsCondition;

  // By actions in a specific category
  const factory EcoDexCondition.categoryActions({
    required String category,
    required int count,
  }) = CategoryActionsCondition;

  // By total CO2 saved (grams)
  const factory EcoDexCondition.co2Saved({
    required int grams,
  }) = Co2SavedCondition;

  // By streak length
  const factory EcoDexCondition.streakDays({
    required int days,
  }) = StreakDaysCondition;

  // By level reached
  const factory EcoDexCondition.levelReached({
    required int level,
  }) = LevelReachedCondition;

  // By unique SDGs supported
  const factory EcoDexCondition.sdgBreadth({
    required int count,
  }) = SdgBreadthCondition;

  // By challenge streak (consecutive days)
  const factory EcoDexCondition.challengeStreak({
    required int days,
  }) = ChallengeStreakCondition;

  // By multi-day challenge completion
  const factory EcoDexCondition.multiDayChallenge({
    required String templateId,
  }) = MultiDayChallengeCondition;

  // By garden plants unlocked
  const factory EcoDexCondition.gardenPlants({
    required int count,
  }) = GardenPlantsCondition;
}
```

#### Discovery Detection

Evaluated reactively after each action log. The provider compares
user stats (from Firestore user doc) against entry conditions:

- `totalActions >= threshold`
- `categoryCount[X] >= threshold`
- `totalCo2Grams >= threshold`
- `currentStreak >= threshold`
- `level >= threshold`
- `uniqueSdgsLogged >= threshold`
- `challengeStreak >= threshold`
- `completedMultiDayChallenges.contains(templateId)`
- `gardenPlantsUnlocked >= threshold`

Most stats already exist in the user document from Phases 1-4.
The provider diffs current discoveries against stored list and
surfaces newly unlocked entries.

#### Data Storage

- **Entry definitions:** Const list in app code
- **Discovered entries:** Firestore `users/{uid}` document
  - `ecodexDiscovered`: List<String> (entry IDs)
  - `ecodexLastDiscoveryDate`: Timestamp (for "new" indicator)

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create EcoDexEntry model | Freezed entry + condition | Planned |
| Create EcoDexCondition model | Freezed union type | Planned |
| Define ~50 entries | Categorized, localized EN/ES/JA | Planned |
| Create eco_dex_entries_data.dart | Const list of entries | Planned |
| Create eco_dex_providers | Discovery evaluation, unlocked list | Planned |
| Create EcoDexScreen | Grid with categories, segmented control | Planned |
| Create EcoDexEntrySheet | Detail bottom sheet for entry | Planned |
| Create EcoDexLockedSheet | Hint for undiscovered entry | Planned |
| Discovery celebration | Toast when new entry found | Planned |
| Add ecodexDiscovered to user doc | Firestore field | Planned |
| Integrate with action logging | Evaluate after each log | Planned |
| Update Progress screen | Add segmented control (Calendar / Eco-Dex) | Planned |
| Localize strings | Screen title, categories, entry text | Planned |
| Write tests | Condition evaluation, discovery logic | Planned |

#### Files to Create

```
lib/features/eco_dex/
+-- eco_dex.dart                          # Barrel file
+-- data/
|   +-- models/
|   |   +-- eco_dex_entry_model.dart
|   |   +-- eco_dex_condition_model.dart
|   +-- eco_dex_entries_data.dart          # ~50 const entries
+-- presentation/
    +-- providers/
    |   +-- eco_dex_providers.dart
    +-- screens/
    |   +-- eco_dex_screen.dart
    +-- widgets/
        +-- eco_dex_entry_card.dart
        +-- eco_dex_entry_sheet.dart
        +-- eco_dex_locked_sheet.dart
        +-- eco_dex_progress_header.dart
        +-- eco_dex_category_section.dart
```

#### Files to Modify

- `lib/features/progress/presentation/screens/progress_screen.dart`
  -- add segmented control for Calendar / Eco-Dex
- `lib/app/router.dart` -- add eco-dex route if needed

---

## Growing Ecosystem (Garden)

### 5.4 Growing Ecosystem

**Priority:** P0 | **Complexity:** High | **Status:** Planned

A personal garden where the user's mascot lives. Plants appear and
grow as users log eco-friendly actions. The mascot stands in the
garden, and in future phases could walk around and interact with
the plants.

Lives under the **Mascot tab** (renamed to "Garden" or "My World").
The mascot is rendered inside the garden scene.

#### Design

```
Bottom nav: Mascot tab -> "Garden" / "My World"

+----------------------------------------------+
|  Your Garden                   Level 12      |
|                                              |
|      [tree]    [flower]                      |
|        |         |       [sunflower]         |
|   [bush]  [fern]    [herb]                   |
|  ~~~~ [mascot] ~~~~~~~~~~~~                  |
|  ~~~~~~~~~ ground/grass ~~~~~~~~~~           |
|                                              |
|  Plants: 8/15  |  Tap a plant for info       |
|                                              |
+----------------------------------------------+
```

#### Plant System

~15 plant types. Each tied to an action category or milestone.
Each plant has 3 growth stages (sprout, growing, full).

| Plant | Trigger | Growth Driver |
|-------|---------|---------------|
| Oak tree | 5 transport actions | More transport: 15 -> 30 |
| Sunflower | 5 energy actions | More energy: 15 -> 30 |
| Herb garden | 5 food actions | More food: 15 -> 30 |
| Coral | 5 water actions | More water: 15 -> 30 |
| Fern | 5 waste actions | More waste: 15 -> 30 |
| Wildflowers | 5 community actions | More community: 15 -> 30 |
| Bamboo | 5 advocacy actions | More advocacy: 15 -> 30 |
| Mushrooms | 5 learning actions | More learning: 15 -> 30 |
| Vine | 5 shopping actions | More shopping: 15 -> 30 |
| Cactus | 7-day streak | 14-day streak -> 30-day |
| Pond | 25 total actions | 50 actions -> 100 |
| Butterfly | Level 10 | Level 25 -> 50 |
| Bird | 10 Eco-Dex entries | 25 entries -> 40 |
| Bench | 10 challenges completed | 25 -> 50 |
| Birdhouse | 10 unique SDGs | 14 SDGs -> 17 |

**Growth stage thresholds (category plants):**
- Stage 1 (sprout): 5 actions in category
- Stage 2 (growing): 15 actions in category
- Stage 3 (full): 30 actions in category

#### Garden State

Garden state is **derived** from user stats, not stored separately.
The provider reads category action counts, streaks, level, etc.
from the user doc and computes which plants are visible and at
what stage. This avoids sync issues -- the garden always reflects
reality.

```dart
class GardenState {
  final Map<String, int> plantStages; // plantId -> 0-3 (0=locked)
  final int totalPlantsUnlocked;
}
```

#### Layout

Simple positioned layout on a fixed-size canvas. Each plant has a
predefined (x, y) position. Plants fade in with a brief animation
when they first appear. The mascot is rendered at a fixed position
in the scene.

Rendered with `flutter_svg` for static plant assets. Growth stage
transitions use crossfade animations between SVG variants.

#### Mascot Integration

The mascot is placed at a fixed position in the garden scene,
rendered at an appropriate scale. Uses the existing mascot SVG
assets. The mascot's evolution stage (from the existing system)
determines which mascot SVG is shown.

**Future vision (post-Phase 5):** Mascot walks around the garden,
pauses near plants, reacts to new growth. This is a Rive animation
opportunity for later phases.

#### Interaction

- Tap a plant to see: name, growth stage, progress to next stage,
  which actions drive it
- Tap the mascot for existing mascot detail screen

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Define plant data | ~15 plants with triggers, positions, stages | Planned |
| Create GardenState provider | Derive state from user stats | Planned |
| Create GardenScreen | Main garden visualization | Planned |
| Create PlantWidget | Renders a single plant at position | Planned |
| Create garden layout | Positioned plants on canvas with mascot | Planned |
| Create ~45 plant SVGs | 15 plants x 3 stages | Planned |
| Create ground/background SVG | Garden base scene | Planned |
| Add growth animations | Crossfade between stages | Planned |
| Add plant detail tap | Bottom sheet with name + progress | Planned |
| Rename Mascot tab | "Garden" or "My World" | Planned |
| Update navigation | Garden screen replaces mascot screen | Planned |
| Localize strings | Plant names, garden title, progress text | Planned |
| Write tests | State derivation, plant visibility, stages | Planned |

#### Files to Create

```
lib/features/garden/
+-- garden.dart                           # Barrel file
+-- data/
|   +-- models/
|   |   +-- plant_model.dart
|   +-- garden_plants_data.dart           # ~15 const plant defs
+-- presentation/
    +-- providers/
    |   +-- garden_providers.dart
    +-- screens/
    |   +-- garden_screen.dart
    +-- widgets/
        +-- plant_widget.dart
        +-- garden_canvas.dart
        +-- plant_detail_sheet.dart

assets/garden/
+-- ground.svg
+-- oak_1.svg, oak_2.svg, oak_3.svg
+-- sunflower_1.svg, sunflower_2.svg, sunflower_3.svg
+-- ... (15 plants x 3 stages + ground = ~46 SVGs)
```

#### Files to Modify

- `lib/app/router.dart` -- update mascot tab to garden screen
- `lib/app/main_shell.dart` -- rename tab, update icon
- `pubspec.yaml` -- register assets/garden/ directory

---

## Art Asset Strategy

### Overview

Phase 5 needs ~46 garden SVGs (15 plants x 3 stages + ground).
Eco-Dex uses Material icons (no custom art needed).

### Option 1: AI Generation + Cleanup (fastest for MVP)

1. **Generate** base designs with [Recraft](https://recraft.ai) --
   text prompts like "simple flat vector seedling, minimal style."
   Outputs true editable SVG (not rasterized-then-traced).
   Free tier: 30-50 daily credits. Pro ($20/mo) for commercial use.
2. **Clean up** in [Inkscape](https://inkscape.org) (free, desktop) or [Boxy SVG](https://boxy-svg.com) (browser) -- normalize
   style, match app color palette, consistent sizing.
3. **Optimize** with [SVGO](https://svgo.dev) for minimal file size
   (under 5KB per SVG).

### Option 2: Rive (best for future animation)

[Rive](https://rive.app) is a vector animation tool with first-class
Flutter support (`rive` package). State machines map directly to
plant growth stages.

- **Free plan:** Full editor access for creation and testing
- **Cadet plan ($9/mo):** Required to export .riv files for Flutter
- **Pros:** Interactive state-driven animations (seed -> sprout ->
  plant -> bloom driven by Riverpod state), GPU-accelerated, tiny
  file sizes. Perfect for mascot walking in garden later.
- **Cons:** Learning curve for editor and state machines. Overkill if only doing static crossfade between growth stages.

### Option 3: SVGator (animated SVGs to Dart)

[SVGator](https://svgator.com) can export animated SVGs directly
as Flutter .dart files. Good middle ground for simple growth
animations without Rive's complexity. Free plan available;
Pro at $24/mo.

### Recommendation

Start with **Option 1** (Recraft + Inkscape) for the MVP. Gets
functional assets in hours rather than days. Consider upgrading
to **Option 2** (Rive) when adding mascot garden interactions --
Rive's state machines are ideal for an animated mascot walking
between plants.

### Art Style Guidelines

- Simple flat/geometric shapes, consistent across all plants
- Earthy natural color palette matching app theme
- Small file size: under 5KB per SVG
- 3 growth stages should be visually distinct at a glance
- Mascot should look natural at the same scale as the plants

---

## Testing Strategy

### Unit Tests

| Component | Key Scenarios |
|-----------|---------------|
| Eco-fact provider | Correct fact for day of year, unlock gating |
| Fact calendar | Gaps for missed days, unlocked dates |
| Challenge selection | Deterministic per user+date, avoids repeats |
| Challenge completion | Condition evaluation per challenge type |
| Multi-day challenge | Streak tracking, reset on miss, completion |
| Eco-Dex conditions | Each trigger type evaluates correctly |
| Eco-Dex discovery | Detects newly unlocked, ignores already found |
| Garden state | Correct plant visibility and stages from stats |
| Garden plants | Threshold logic for all 15 plants |

### Widget Tests

| Screen | Key Scenarios |
|--------|---------------|
| EcoFactScreen | Locked state, unlocked state, calendar gaps |
| MailIconButton | Dot visible/hidden based on state |
| DailyChallengeCard | Challenge text, completion state |
| MultiDayChallengeCard | Progress bar, day count |
| EcoDexScreen | Grid renders, locked vs unlocked cards |
| EcoDexEntrySheet | Detail content, discovered date |
| EcoDexLockedSheet | Hint text for locked entry |
| GardenScreen | Plants at correct positions and stages |
| PlantDetailSheet | Plant name, growth progress |

### Integration Tests

| Flow | Scenarios |
|------|-----------|
| Daily loop | Log action -> challenge complete -> fact unlocks |
| Eco-Dex discovery | Action -> milestone hit -> entry unlocked |
| Multi-day challenge | Start -> daily progress -> completion -> Eco-Dex |
| Garden growth | Log actions -> plant appears -> grows stages |

---

## Acceptance Criteria

### 5.1 Daily Eco-Fact -- COMPLETE
- [x] Mail icon visible in home screen app bar
- [x] Red dot appears when daily fact is available
- [x] Tapping shows locked state before challenge completion
- [x] Tapping shows fact after challenge completion
- [x] Fact changes each day (based on day of year)
- [x] Fact calendar shows unlocked dates and gaps
- [x] Missed facts are gone forever (gaps remain)
- [x] Previously earned facts can be re-read from calendar
- [x] All facts localized (EN/ES/JA)
- Note: Fact gating is now active via `isEcoFactLockedProvider`,
  which watches `isTodayChallengeCompletedProvider`.

### 5.2 Daily Challenges -- NEARLY DONE
- [x] One challenge shown on home screen each day
- [x] Challenge differs per user (pseudorandom with user ID)
- [x] Does not repeat within last 7 challenges for same user
- [x] Completing challenge unlocks daily eco-fact
- [x] Completion detected automatically after logging action
- [x] Challenge streak tracked (consecutive days completing)
- [x] Challenge text localized (EN/ES/JA)
- [x] Multi-day challenges can be started from challenges screen
- [x] Multi-day progress persists across days
- [x] Multi-day challenge resets on missed day
- [ ] Completed multi-day challenges unlock Eco-Dex entries
  (deferred to 5.3 -- requires Eco-Dex system)

### 5.3 Eco-Dex
- [ ] Grid of ~50 entries with categories
- [ ] Undiscovered entries show as locked with hint
- [ ] Discovered entries show name and icon
- [ ] Tapping discovered entry shows detail sheet with fact
- [ ] New discoveries triggered by actions, streaks, challenges
- [ ] Discovery celebration toast on new unlock
- [ ] Discovery count shown (e.g., "23/50")
- [ ] Accessible from Progress tab (segmented control)
- [ ] All entry text localized (EN/ES/JA)

### 5.4 Growing Ecosystem
- [ ] Garden screen shows positioned plant elements
- [ ] Mascot rendered inside the garden scene
- [ ] Plants appear when trigger conditions are met
- [ ] Plants progress through 3 visible growth stages
- [ ] Growth stage matches actual action history
- [ ] Crossfade animation on stage transitions
- [ ] Tapping plant shows info (name, progress to next stage)
- [ ] ~15 plant types covering all categories + milestones
- [ ] Garden state is derived (always accurate, no sync issues)
- [ ] Mascot tab renamed to "Garden" or "My World"

---

## Dependencies

### External
- SVG assets (generated or hand-drawn, ~46 files)
- 50-365 curated eco-facts with scientific sources
- ~50 Eco-Dex entry facts with sources

### Internal
- Phase 4 complete (action logging, points, streaks, analytics)
- User doc contains category counts, streak, level, SDG stats
- SharedPreferences for local state (recent challenge IDs)
- Existing mascot SVG assets for garden rendering

### New Package Dependencies

None required. Existing packages cover all needs:
- `flutter_svg` for garden element rendering (already in project)
- `share_plus` may be needed if fact sharing is added later

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Art assets take too long | Medium | High | Use AI generation (Recraft) for MVP, polish later |
| 365 facts is a lot of content | Medium | Medium | Start with 50-100, cycle on shorter period |
| Challenge feels pointless without points | Low | Medium | Eco-fact reward + challenge streak are motivating |
| Garden layout looks cluttered | Medium | Medium | Fixed positions, careful spacing, start with fewer |
| Eco-Dex unlock pacing | Low | Medium | Tune thresholds with simulated user data |
| Strict fact gating frustrates users | Low | Medium | Challenges are achievable (log 1-2 actions) |

---

## Notes

- Start with Daily Fact and Challenges for immediate engagement
  impact (both are zero-art features)
- The garden is the crown jewel but ships last since it requires
  art assets
- All 4 features reinforce each other through the coherent reward
  system -- no fake points, no currency inflation
- Challenge difficulty should be accessible: most challenges
  require logging just 1-2 actions. The point is daily engagement,
  not frustration.
- 365 facts is aspirational; 50-100 is a solid MVP that cycles
  every 2-3 months until the full set is written
- The mascot-in-garden vision sets up beautifully for Rive
  animations in future phases (mascot walking, reacting to plants)

---

*This plan will be updated as implementation progresses.*
