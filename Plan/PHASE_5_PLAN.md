# Phase 5: Gamification & Daily Engagement

**Version:** 1.0
**Created:** February 2026
**Status:** Planning

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [Growing Ecosystem](#growing-ecosystem)
5. [Daily Challenges](#daily-challenges)
6. [Eco-Dex](#eco-dex)
7. [Daily Eco-Fact](#daily-eco-fact)
8. [Data Models](#data-models)
9. [Implementation Order](#implementation-order)
10. [Testing Strategy](#testing-strategy)
11. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 5 adds four interlocking engagement systems designed to
give users a compelling reason to return every day. These
features are deliberately low-art and data-driven, making them
feasible for a solo developer without dedicated design resources.

### Design Philosophy

The best habit apps combine multiple psychological levers:

| Lever | Feature | Effect |
|-------|---------|--------|
| Progress visualization | Growing Ecosystem | "I can see my impact" |
| Variable rewards | Daily Challenges | "What's today's mission?" |
| Completion drive | Eco-Dex | "I want to fill the album" |
| Curiosity / learning | Daily Eco-Fact | "What will I learn today?" |

Together these create a daily engagement loop:
1. Open app, see today's fact and challenges
2. Log actions to complete challenges and grow garden
3. Discover new Eco-Dex entries along the way
4. Come back tomorrow for new fact and challenges

### Key Objectives

- Build a personal ecosystem that visualizes cumulative impact
- Rotate 3 daily challenges that expire at midnight
- Create a collection album with ~50 discoverable entries
- Curate 365 scientifically backed sustainability facts
- All features work with minimal art (SVGs, icons, text)

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| Growing Ecosystem | Personal garden rendered from action history |
| 10-15 Garden SVGs | Simple plant/animal/element assets |
| Biome System | 4 unlockable garden themes |
| Daily Challenge Engine | Deterministic daily mission generator |
| ~30 Challenge Templates | Parameterized challenge definitions |
| Challenge UI | Home screen challenge cards with progress |
| Eco-Dex Album | Collection screen with ~50 entries |
| Eco-Dex Entries | Categorized discoverable knowledge cards |
| Daily Eco-Fact | 365 curated sustainability facts |
| Fact Display Widget | Home screen fact card with source |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 5.1 Growing Ecosystem | P0 | Medium | Pending |
| 5.2 Garden Assets | P0 | Medium | Pending |
| 5.3 Biome System | P1 | Low | Pending |
| 5.4 Daily Challenge Engine | P0 | Medium | Pending |
| 5.5 Challenge Templates | P0 | Low | Pending |
| 5.6 Challenge UI | P0 | Medium | Pending |
| 5.7 Eco-Dex Data Layer | P0 | Medium | Pending |
| 5.8 Eco-Dex Entries | P0 | Low | Pending |
| 5.9 Eco-Dex UI | P0 | Medium | Pending |
| 5.10 Daily Eco-Fact Data | P0 | Low | Pending |
| 5.11 Daily Eco-Fact UI | P0 | Low | Pending |

---

## Growing Ecosystem

### 5.1 Core Ecosystem Feature

**Priority:** P0 | **Complexity:** Medium

A personal garden/terrarium that grows as users log actions.
Each logged action plants an element. Over time, a barren plot
fills with trees, flowers, and wildlife -- visual proof of the
user's impact.

#### Design Principles

- **Derived, not stored:** Garden state is computed from the
  user's action log. No extra Firestore collection needed.
- **Deterministic:** Each action maps to a specific element
  type, size, and position based on its category, CO2 value,
  and timestamp. Same data always renders the same garden.
- **Minimal assets:** 10-15 simple SVGs with color tinting
  and size variation create hundreds of visual combinations.

#### How Actions Map to Garden Elements

| Action Category | Element Types | Examples |
|----------------|---------------|---------|
| Recycling | Flowers, ground cover | Daisy, clover, moss |
| Transport | Birds, butterflies | Sparrow, monarch |
| Food | Fruit trees, bushes | Apple tree, berry bush |
| Energy | Sun rays, wind swirls | Sunbeam, breeze lines |
| Water | Pond features, fish | Pond, lily pad, koi |
| Consumption | Mushrooms, stones | Toadstool, river rock |
| Community | Paths, benches | Stepping stone, birdhouse |

#### Element Size by CO2 Impact

| CO2 Saved | Size | Example |
|-----------|------|---------|
| < 100g | Small | Single flower, butterfly |
| 100-500g | Medium | Bush, small bird |
| 500-2000g | Large | Small tree, pond |
| > 2000g | Extra large | Full tree, large feature |

#### Garden Layout

- Canvas rendered with Flutter `Stack` + `Positioned`
- Grid-based placement to prevent overlap
- Ground level at bottom, elements placed upward
- Taller elements (trees) in back, smaller in front
- Slight randomized offset within grid cells for
  natural look (seeded from action ID for determinism)

#### UI Design

```
+-----------------------------------------+
|  <-       My Ecosystem        [Biome v] |
|-----------------------------------------|
|                                         |
|      [tree]    [tree]                   |
|         [bird]      [bush]              |
|    [flower] [flower]   [mushroom]       |
|  [moss] [pond]  [stone] [flower]        |
|  [path]  [bench]  [moss]  [clover]      |
|                                         |
|  ~~~~~~~ ground texture ~~~~~~~~~~~~~~  |
|                                         |
|  127 elements | 45.2 kg CO2 saved       |
|                                         |
+-----------------------------------------+
```

#### Interaction

- Tap an element to see which action planted it and when
- Pinch to zoom in/out
- Scroll/pan if garden exceeds screen
- Screenshot button for sharing

#### Data Model

The garden is derived from the action log, not stored
separately. A local cache speeds up rendering.

```dart
// Computed from action log, not a Firestore model
class GardenElement {
  final String actionId;
  final String elementType;  // tree, flower, bird, etc.
  final String svgAsset;     // asset path
  final double x;            // 0.0-1.0 normalized position
  final double y;            // 0.0-1.0 normalized position
  final double scale;        // size multiplier
  final Color tint;          // color variation
  final DateTime plantedAt;
}

// Deterministic mapping function
GardenElement mapActionToElement(ActionLogEntry action) {
  // Category -> element type
  // CO2 grams -> scale
  // Hash of action ID -> position within grid cell
  // Hash of action ID -> color tint variation
}
```

#### Performance Considerations

- Cache rendered garden elements locally
  (SharedPreferences or in-memory)
- Only recompute when new actions are logged
- For large gardens (500+ elements), render visible
  area only and virtualize off-screen elements
- SVG rendering is efficient with flutter_svg (already
  in project dependencies)

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create GardenElement model | Computed element class | Pending |
| Create garden mapping service | Action -> element logic | Pending |
| Create GardenCanvas widget | Stack-based renderer | Pending |
| Create GardenScreen | Full garden view with controls | Pending |
| Add element tap interaction | Show source action info | Pending |
| Add zoom/pan controls | Pinch to zoom, drag to pan | Pending |
| Add screenshot/share button | Capture and share garden | Pending |
| Create garden stats footer | Element count, CO2 total | Pending |
| Add garden entry to home screen | Preview card or button | Pending |
| Create garden providers | Riverpod state management | Pending |
| Cache garden state locally | Performance optimization | Pending |
| Localize strings | EN/ES/JA | Pending |
| Write unit tests | Mapping logic, positioning | Pending |
| Write widget tests | Canvas rendering, interactions | Pending |

#### Files to Create

```
lib/features/garden/
+-- garden.dart                         # Barrel file
+-- data/
|   +-- models/
|   |   +-- garden_element.dart
|   |   +-- biome.dart
|   +-- services/
|       +-- garden_mapping_service.dart  # Action -> element
+-- presentation/
    +-- providers/
    |   +-- garden_providers.dart
    +-- screens/
    |   +-- garden_screen.dart
    +-- widgets/
        +-- garden_canvas.dart
        +-- garden_element_widget.dart
        +-- garden_stats_footer.dart
        +-- element_info_tooltip.dart
```

---

### 5.2 Garden Assets

**Priority:** P0 | **Complexity:** Medium

Create 10-15 simple SVG assets for garden elements.

#### Required Assets

| Asset | Variants | Notes |
|-------|----------|-------|
| Small tree | 2 | Deciduous silhouettes |
| Large tree | 2 | Fuller canopy shapes |
| Flower | 3 | Different petal shapes |
| Bush/shrub | 2 | Round and spread shapes |
| Ground cover | 2 | Moss, clover patches |
| Bird | 2 | Perched and flying poses |
| Butterfly | 1 | Simple wing shape |
| Mushroom | 1 | Classic toadstool |
| Pond | 1 | Oval water shape |
| Stone/rock | 1 | Rounded boulder |
| Birdhouse | 1 | On a post |
| **Total** | **~18** | |

#### Art Style

- **Simple flat/geometric shapes** - no detail needed
- **Single color per element** - tinting adds variety
- **Small file size** - under 5KB per SVG
- **Consistent style** - all elements feel cohesive

#### Creation Approach

1. AI-generate concepts (simple flat illustration style)
2. Trace/recreate as clean SVGs in a vector editor
3. Or source from open-source SVG libraries
   (e.g., SVGRepo, Undraw, OpenClipart)
4. Optimize with SVGO for minimal file size

#### Color Tinting Strategy

Each SVG is a single neutral color. At render time, apply
a color tint based on a hash of the action ID:

```dart
// 6 tint variations per element type
const GARDEN_TINTS = [
  Color(0xFF4CAF50), // green
  Color(0xFF66BB6A), // light green
  Color(0xFF2E7D32), // dark green
  Color(0xFF81C784), // pale green
  Color(0xFF388E3C), // forest green
  Color(0xFF43A047), // medium green
];
```

Flowers and butterflies use a broader palette (pinks,
yellows, purples). Trees and ground cover use greens.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Source/create tree SVGs | 4 variants (2 small, 2 large) | Pending |
| Source/create flower SVGs | 3 variants | Pending |
| Source/create bush SVGs | 2 variants | Pending |
| Source/create ground cover | 2 variants (moss, clover) | Pending |
| Source/create bird SVGs | 2 variants (perched, flying) | Pending |
| Source/create butterfly SVG | 1 variant | Pending |
| Source/create mushroom SVG | 1 variant | Pending |
| Source/create pond SVG | 1 variant | Pending |
| Source/create stone SVG | 1 variant | Pending |
| Source/create birdhouse SVG | 1 variant | Pending |
| Optimize all SVGs | SVGO compression | Pending |
| Add to assets folder | pubspec.yaml declarations | Pending |

#### File Structure

```
assets/garden/
+-- elements/
|   +-- tree_small_1.svg
|   +-- tree_small_2.svg
|   +-- tree_large_1.svg
|   +-- tree_large_2.svg
|   +-- flower_1.svg
|   +-- flower_2.svg
|   +-- flower_3.svg
|   +-- bush_1.svg
|   +-- bush_2.svg
|   +-- ground_moss.svg
|   +-- ground_clover.svg
|   +-- bird_perched.svg
|   +-- bird_flying.svg
|   +-- butterfly.svg
|   +-- mushroom.svg
|   +-- pond.svg
|   +-- stone.svg
|   +-- birdhouse.svg
+-- biomes/
    +-- meadow_bg.svg
    +-- forest_bg.svg
    +-- coast_bg.svg
    +-- desert_bg.svg
```

---

### 5.3 Biome System

**Priority:** P1 | **Complexity:** Low

Unlockable garden themes that change the background and
color palette of garden elements.

#### Biomes

| Biome | Unlock | Background | Palette |
|-------|--------|------------|---------|
| Meadow | Free (default) | Green grass gradient | Greens, warm yellows |
| Forest | 500 pts | Dense tree canopy | Deep greens, browns |
| Coast | 1,000 pts | Sandy shore + ocean | Blues, sandy tones |
| Desert Oasis | 1,500 pts | Arid with water feature | Warm oranges, teal |

#### Implementation

- Each biome is a background SVG/gradient + a color
  palette that tints the garden elements
- Same elements render in all biomes, just with
  different colors
- Biome selection stored in user document
- Purchase flow reuses existing points deduction logic

#### Data Model

```dart
@freezed
class Biome with _$Biome {
  const factory Biome({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required int pointsCost,  // 0 for meadow
    required String backgroundAsset,
    required List<Color> elementPalette,
  }) = _Biome;
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Define biome data | Static list of 4 biomes | Pending |
| Create biome backgrounds | 4 SVG/gradient backgrounds | Pending |
| Create biome color palettes | Tint sets per biome | Pending |
| Create biome selector widget | Dropdown or bottom sheet | Pending |
| Implement biome purchase flow | Points deduction | Pending |
| Store selected biome | In user Firestore document | Pending |
| Apply biome to garden render | Background + tints | Pending |
| Localize biome names | EN/ES/JA | Pending |
| Write tests | Purchase flow, rendering | Pending |

---

## Daily Challenges

### 5.4 Challenge Engine

**Priority:** P0 | **Complexity:** Medium

Generate 3 daily challenges that rotate at midnight. Users
earn bonus points for completing them.

#### Design Principles

- **Deterministic:** Challenges are generated from a hash of
  the current date. All users see the same challenges on the
  same day, creating shared experience.
- **No server needed:** Challenge generation runs client-side.
- **Balanced difficulty:** Each day has 1 easy, 1 medium,
  1 hard challenge.
- **Category variety:** Consecutive days should not repeat
  the same category focus.

#### Challenge Generation Algorithm

```dart
List<Challenge> generateDailyChallenges(DateTime date) {
  // Seed from date for determinism
  final seed = date.year * 10000
      + date.month * 100
      + date.day;
  final rng = Random(seed);

  // Pick 1 from each difficulty tier
  final easy = _pickFromTier(
    EASY_TEMPLATES, rng,
  );
  final medium = _pickFromTier(
    MEDIUM_TEMPLATES, rng,
  );
  final hard = _pickFromTier(
    HARD_TEMPLATES, rng,
  );

  return [easy, medium, hard];
}
```

#### Challenge Completion Tracking

```
users/{userId}/dailyChallenges/
+-- {dateString}/         # e.g. "2026-02-14"
    +-- challenges: [     # Array of 3 challenge states
    |   { templateId, completed, progress, completedAt }
    | ]
    +-- allCompleted: bool
    +-- bonusClaimed: bool
```

Alternatively, store as a single document per day to
minimize reads. Old documents auto-expire or are cleaned
up periodically.

#### Bonus Rewards

| Completion | Reward |
|-----------|--------|
| 1 of 3 challenges | Individual bonus (varies by tier) |
| 2 of 3 challenges | No extra bonus |
| All 3 challenges | Completion bonus (+25 pts) |

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create Challenge model | Template + instance models | Pending |
| Create ChallengeEngine | Deterministic generation | Pending |
| Create challenge tracker | Progress + completion | Pending |
| Integrate with action log | Update progress on log | Pending |
| Implement bonus point award | On challenge completion | Pending |
| Store daily state in Firestore | Per-user per-day doc | Pending |
| Handle midnight rollover | Reset challenges at midnight | Pending |
| Add analytics events | Challenge started/completed | Pending |
| Write unit tests | Generation, tracking, rewards | Pending |

#### Files to Create

```
lib/features/challenges/
+-- challenges.dart                     # Barrel file
+-- data/
|   +-- models/
|   |   +-- challenge_model.dart
|   |   +-- challenge_template.dart
|   |   +-- daily_challenge_state.dart
|   +-- repositories/
|       +-- challenges_repository.dart
+-- domain/
|   +-- services/
|       +-- challenge_engine.dart       # Generation
|       +-- challenge_tracker.dart      # Progress
+-- presentation/
    +-- providers/
    |   +-- challenges_providers.dart
    +-- widgets/
        +-- daily_challenges_card.dart
        +-- challenge_progress_tile.dart
        +-- challenge_complete_banner.dart
```

---

### 5.5 Challenge Templates

**Priority:** P0 | **Complexity:** Low

Define ~30 parameterized challenge templates across 3
difficulty tiers.

#### Easy Tier (bonus: +5 pts each)

| ID | Template | Parameters |
|----|----------|------------|
| `e_log_n` | Log {n} actions today | n: 1, 2 |
| `e_category` | Log a {category} action | any category |
| `e_any_action` | Log any action today | -- |
| `e_points_n` | Earn {n}+ points today | n: 5, 10 |
| `e_specific` | Log a specific action type | random action |
| **Total** | **~10 variants** | |

#### Medium Tier (bonus: +10 pts each)

| ID | Template | Parameters |
|----|----------|------------|
| `m_log_n` | Log {n} actions today | n: 3, 4 |
| `m_categories_n` | Log in {n} different categories | n: 2, 3 |
| `m_co2_n` | Save {n}+ grams of CO2 today | n: 500, 1000 |
| `m_sdg_n` | Support {n} different SDGs | n: 2, 3 |
| `m_points_n` | Earn {n}+ points today | n: 20, 30 |
| `m_high_impact` | Log an action worth 20+ points | -- |
| **Total** | **~12 variants** | |

#### Hard Tier (bonus: +20 pts each)

| ID | Template | Parameters |
|----|----------|------------|
| `h_log_n` | Log {n} actions today | n: 5, 7 |
| `h_categories_n` | Log in {n}+ categories | n: 4, 5 |
| `h_co2_n` | Save {n}+ grams of CO2 | n: 2500, 5000 |
| `h_sdg_n` | Support {n}+ different SDGs | n: 4, 5 |
| `h_all_categories` | Log in every category | -- |
| `h_points_n` | Earn {n}+ points today | n: 50, 75 |
| `h_high_impact_n` | Log {n} actions worth 20+ pts | n: 2, 3 |
| **Total** | **~10 variants** | |

#### Template Data Structure

```dart
@freezed
class ChallengeTemplate with _$ChallengeTemplate {
  const factory ChallengeTemplate({
    required String id,
    required String tier,     // easy, medium, hard
    required String type,     // actionCount, categoryCount,
                              // co2Saved, sdgCount, points
    required String nameKeyEn,
    required String nameKeyJa,
    required String nameKeyEs,
    required int bonusPoints,
    required Map<String, dynamic> params,
    // e.g. {"count": 3, "category": "transport"}
  }) = _ChallengeTemplate;
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Define easy templates | ~10 variants | Pending |
| Define medium templates | ~12 variants | Pending |
| Define hard templates | ~10 variants | Pending |
| Create template data file | Static Dart definitions | Pending |
| Localize template strings | EN/ES/JA with placeholders | Pending |
| Write unit tests | Template instantiation | Pending |

---

### 5.6 Challenge UI

**Priority:** P0 | **Complexity:** Medium

Display daily challenges on the home screen.

#### Home Screen Integration

Challenges appear as a card on the home screen, below the
mascot and above the action quick-log area.

#### UI Design

```
+-----------------------------------------+
|  Today's Challenges          Resets: 6h |
|-----------------------------------------|
|                                         |
|  [x] Log a Transport action      +5    |
|      Completed!                         |
|                                         |
|  [ ] Log in 2 different categories +10  |
|      =======>........  1/2              |
|                                         |
|  [ ] Save 2500g+ CO2 today       +20   |
|      ==>................  800/2500      |
|                                         |
|  ---- All 3 complete: +25 bonus ----   |
|                                         |
+-----------------------------------------+
```

#### States

| State | Display |
|-------|---------|
| Pending | Empty checkbox, progress bar at 0 |
| In progress | Empty checkbox, partial progress |
| Completed | Filled checkbox, "Completed!" |
| All complete | Banner with bonus points + confetti |

#### Countdown Timer

Show time remaining until midnight reset in the card
header. Updates every minute.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create DailyChallengesCard | Main container widget | Pending |
| Create ChallengeProgressTile | Single challenge row | Pending |
| Create ChallengeCompleteBanner | All-3-complete celebration | Pending |
| Add countdown timer | Time until reset | Pending |
| Add to home screen | Below mascot card | Pending |
| Animate completion | Checkbox + confetti for all-3 | Pending |
| Localize all strings | EN/ES/JA | Pending |
| Write widget tests | All states, timer, progress | Pending |

---

## Eco-Dex

### 5.7 Eco-Dex Data Layer

**Priority:** P0 | **Complexity:** Medium

A collection album where users discover entries by hitting
milestones. Framed as "discovery" rather than "achievement"
for a different psychological feel -- users are explorers
uncovering knowledge about the natural world.

#### Difference from Achievements (Phase 7)

| Aspect | Eco-Dex | Achievements |
|--------|---------|-------------|
| Frame | Discovery / exploration | Accomplishment / badge |
| Content | Real-world knowledge | Congratulatory |
| Visual | Cards with facts | Badge icons |
| Feel | "I learned something" | "I did something" |
| Count | ~50 entries | ~19 badges |

#### Unlock Criteria Types

Similar to achievement criteria but with different triggers:

```dart
@freezed
class EcoDexCriteria with _$EcoDexCriteria {
  // Unlock by logging N actions in a category
  const factory EcoDexCriteria.categoryActions({
    required String category,
    required int count,
  }) = CategoryActionsCriteria;

  // Unlock by total CO2 saved
  const factory EcoDexCriteria.co2Threshold({
    required int grams,
  }) = Co2ThresholdCriteria;

  // Unlock by reaching a streak
  const factory EcoDexCriteria.streakDays({
    required int days,
  }) = StreakDaysCriteria;

  // Unlock by supporting N different SDGs
  const factory EcoDexCriteria.sdgBreadth({
    required int count,
  }) = SdgBreadthCriteria;

  // Unlock by total actions logged
  const factory EcoDexCriteria.totalActions({
    required int count,
  }) = TotalActionsCriteria;

  // Unlock by reaching a level
  const factory EcoDexCriteria.levelReached({
    required int level,
  }) = LevelReachedCriteria;

  // Unlock by completing N daily challenges
  const factory EcoDexCriteria.challengesCompleted({
    required int count,
  }) = ChallengesCompletedCriteria;

  // Unlock by garden size
  const factory EcoDexCriteria.gardenElements({
    required int count,
  }) = GardenElementsCriteria;
}
```

#### Firestore Structure

```
users/{userId}/ecoDex/
+-- discovered/
    +-- {entryId}: { discoveredAt: timestamp }
```

Definitions are stored locally (static Dart data), only
user discovery state is in Firestore.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create EcoDexEntry model | Freezed definition model | Pending |
| Create EcoDexCriteria model | Union type for criteria | Pending |
| Create UserEcoDexState model | Discovery tracking | Pending |
| Create EcoDexRepository | Firestore CRUD | Pending |
| Create EcoDexChecker service | Check unlock criteria | Pending |
| Integrate with action logging | Check after each action | Pending |
| Integrate with streak/level | Check on updates | Pending |
| Run code generation | Freezed models | Pending |
| Write unit tests | Criteria checking, repository | Pending |

#### Files to Create

```
lib/features/eco_dex/
+-- eco_dex.dart                        # Barrel file
+-- data/
|   +-- models/
|   |   +-- eco_dex_entry.dart
|   |   +-- eco_dex_criteria.dart
|   |   +-- user_eco_dex_state.dart
|   +-- repositories/
|   |   +-- eco_dex_repository.dart
|   +-- eco_dex_definitions.dart        # Static entries
+-- domain/
|   +-- services/
|       +-- eco_dex_checker.dart
+-- presentation/
    +-- providers/
    |   +-- eco_dex_providers.dart
    +-- screens/
    |   +-- eco_dex_screen.dart
    |   +-- eco_dex_entry_screen.dart
    +-- widgets/
        +-- eco_dex_card.dart
        +-- eco_dex_category_section.dart
        +-- eco_dex_progress_header.dart
        +-- discovery_celebration.dart
```

---

### 5.8 Eco-Dex Entries

**Priority:** P0 | **Complexity:** Low

Define ~50 Eco-Dex entries across 6 categories. Each entry
contains a real sustainability fact, making discovery both
rewarding and educational.

#### Categories

| Category | Entries | Theme | Color |
|----------|---------|-------|-------|
| Flora | 10 | Plants and trees | Green |
| Fauna | 10 | Animals and insects | Amber |
| Elements | 8 | Weather, geology, water | Blue |
| SDG World | 8 | One per SDG cluster | Teal |
| Eco-Pioneers | 7 | Notable environmentalists | Purple |
| Milestones | 7 | Personal impact markers | Gold |

#### Sample Entries

**Flora (unlocked by Food/Recycling actions)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `flora_01` | Mighty Oak | 5 recycling actions | A single oak tree absorbs ~22 kg of CO2 per year and can live for 500+ years. |
| `flora_02` | Bamboo Sprint | 10 food actions | Bamboo can grow up to 91 cm in a single day, making it the fastest-growing plant on Earth. |
| `flora_03` | Mangrove Shield | Save 5 kg CO2 | Mangrove forests store up to 4x more carbon per hectare than rainforests. |

**Fauna (unlocked by Water/Consumption actions)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `fauna_01` | Honeybee | 5 consumption actions | Bees pollinate ~75% of the world's flowering plants and 35% of food crops. |
| `fauna_02` | Sea Otter | 10 water actions | Sea otters maintain kelp forests that absorb 12x more CO2 than open ocean. |

**Elements (unlocked by Energy/Transport actions)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `elem_01` | Solar Wind | 5 energy actions | The sun provides more energy to Earth in one hour than humanity uses in an entire year. |
| `elem_02` | Ocean Current | 5 transport actions | Oceans absorb ~30% of human-produced CO2, acting as a massive carbon sink. |

**SDG World (unlocked by SDG breadth)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `sdg_01` | Global Goals | Support 3 SDGs | The 17 SDGs were adopted by all 193 UN member states in 2015 as a shared blueprint for peace and prosperity. |

**Eco-Pioneers (unlocked by level milestones)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `pioneer_01` | Wangari Maathai | Reach level 3 | Nobel Prize winner who founded the Green Belt Movement, planting over 51 million trees across Kenya. |

**Milestones (unlocked by personal impact)**

| ID | Name | Unlock Criteria | Fact |
|----|------|----------------|------|
| `mile_01` | First Kilogram | Save 1 kg CO2 | 1 kg of CO2 is equivalent to driving a car about 5 km. You just undid that! |

#### Entry Data Structure

```dart
@freezed
class EcoDexEntry with _$EcoDexEntry {
  const factory EcoDexEntry({
    required String id,
    required String category,   // flora, fauna, etc.
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required String factEn,
    required String factJa,
    required String factEs,
    String? sourceUrl,          // Citation link
    required String iconName,   // Material icon
    required EcoDexCriteria criteria,
  }) = _EcoDexEntry;
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Write Flora entries (10) | Facts + criteria | Pending |
| Write Fauna entries (10) | Facts + criteria | Pending |
| Write Elements entries (8) | Facts + criteria | Pending |
| Write SDG World entries (8) | Facts + criteria | Pending |
| Write Eco-Pioneers entries (7) | Facts + criteria | Pending |
| Write Milestones entries (7) | Facts + criteria | Pending |
| Research and verify all facts | Scientific sources | Pending |
| Localize all entries | EN/ES/JA | Pending |
| Create definitions file | Static Dart data | Pending |
| Write unit tests | Data integrity checks | Pending |

---

### 5.9 Eco-Dex UI

**Priority:** P0 | **Complexity:** Medium

The Eco-Dex screen displays discovered and undiscovered
entries in a visually appealing collection format.

#### UI Design - Main Screen

```
+-----------------------------------------+
|  <-         Eco-Dex                     |
|-----------------------------------------|
|                                         |
|  23 of 50 discovered                    |
|  ==================>..........  46%     |
|                                         |
|  ------- Flora (6/10) --------         |
|  [Oak] [Bamboo] [Mangrove] [???]       |
|  [???] [???]    [Fern]     [???]       |
|  [???] [???]                            |
|                                         |
|  ------- Fauna (4/10) --------         |
|  [Bee] [Otter] [???] [Whale]           |
|  [???] [???]   [???] [???]             |
|  [???] [???]                            |
|                                         |
|  ------- Elements (3/8) ------         |
|  [Solar] [Ocean] [???] [Wind]          |
|  [???]   [???]   [???] [???]           |
|                                         |
|  (more categories below...)             |
+-----------------------------------------+
```

#### UI Design - Entry Detail

```
+-----------------------------------------+
|  <-     Mighty Oak                      |
|-----------------------------------------|
|                                         |
|         [Large tree icon]               |
|                                         |
|            Mighty Oak                   |
|            Flora                        |
|                                         |
|  ------------------------------------- |
|                                         |
|  A single oak tree absorbs ~22 kg of   |
|  CO2 per year and can live for 500+     |
|  years. Ancient oak forests are among   |
|  the most biodiverse habitats in        |
|  temperate regions.                     |
|                                         |
|  Source: UK Forestry Commission         |
|                                         |
|  ------------------------------------- |
|                                         |
|  Discovered: Feb 14, 2026              |
|  Unlocked by: 5 recycling actions      |
|                                         |
+-----------------------------------------+
```

#### Undiscovered Entry Display

- Show "???" placeholder with category color
- Show unlock hint on tap: "Log 5 more recycling
  actions to discover this entry"
- Silhouette/dimmed version of the icon

#### Discovery Celebration

When a new entry is discovered, show a brief toast or
bottom sheet:

```
+-----------------------------------------+
|                                         |
|  New Discovery!                         |
|                                         |
|  [Oak icon]  Mighty Oak                |
|              Tap to read                |
|                                         |
+-----------------------------------------+
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create EcoDexScreen | Main collection view | Pending |
| Create EcoDexCategorySection | Category header + grid | Pending |
| Create EcoDexCard widget | Discovered/undiscovered card | Pending |
| Create EcoDexEntryScreen | Detail view with fact | Pending |
| Create EcoDexProgressHeader | Overall progress bar | Pending |
| Create DiscoveryCelebration | Toast/bottom sheet | Pending |
| Add unlock hint on tap | "Log N more to discover" | Pending |
| Add navigation route | From profile or home | Pending |
| Localize all strings | EN/ES/JA | Pending |
| Write widget tests | All display states | Pending |

---

## Daily Eco-Fact

### 5.10 Daily Eco-Fact Data

**Priority:** P0 | **Complexity:** Low

A curated collection of 365 sustainability facts -- one for
each day of the year. Facts are scientifically backed,
surprising, and designed to reinforce the value of everyday
sustainable actions.

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
- "Paper bags aren't automatically better than plastic.
  They require 4x more energy to produce. The best bag
  is the reusable one you already own." (UK Environment
  Agency)

**Surprising Comparisons:**
- "Skipping one beef meal saves ~3 kg of CO2 -- the
  same as not driving for 15 km." (Poore & Nemecek,
  Science 2018)
- "Air-drying one load of laundry instead of using a
  dryer saves ~2.4 kg of CO2 -- equivalent to leaving
  a light off for 80 hours." (DEFRA 2024)
- "A single long-haul return flight emits more CO2 than
  the average person in 50+ countries produces in an
  entire year." (Our World in Data)

**Positive News:**
- "Global renewable energy capacity hit a record in
  2024, with solar growing faster than all other power
  sources combined." (IRENA)
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

#### Fact Selection Algorithm

```dart
String getDailyFactId(DateTime date) {
  // Day of year (1-366) determines the fact
  final dayOfYear = date.difference(
    DateTime(date.year, 1, 1),
  ).inDays + 1;
  // Cycle through 365 facts
  return 'fact_${(dayOfYear - 1) % 365 + 1}';
}
```

All users see the same fact on the same day.

#### Data Structure

```dart
@freezed
class EcoFact with _$EcoFact {
  const factory EcoFact({
    required int id,            // 1-365
    required String category,   // mythBuster, comparison,
                                // positiveNews, individual,
                                // natureWonder
    required String factEn,
    required String factJa,
    required String factEs,
    required String sourceEn,   // Citation text
    String? sourceUrl,          // Optional link
  }) = _EcoFact;
}
```

#### Data Storage

Facts are stored as static Dart data (not Firestore) to
avoid unnecessary reads. Shipped with the app binary.

Consider a separate Dart file per category or a single
`eco_facts_data.dart` with all 365 entries.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Research Myth Buster facts (~80) | With scientific sources | Pending |
| Research Comparison facts (~80) | With calculations | Pending |
| Research Positive News facts (~80) | With recent data | Pending |
| Research Individual Impact facts (~60) | With scale data | Pending |
| Research Nature Wonder facts (~65) | With citations | Pending |
| Create EcoFact model | Freezed data class | Pending |
| Create eco_facts_data.dart | Static fact definitions | Pending |
| Localize all facts | EN/ES/JA | Pending |
| Verify all sources | Cross-reference citations | Pending |
| Write unit tests | Selection logic, data integrity | Pending |

**Note:** Curating 365 quality facts is the largest content
task. Consider starting with 30-50 well-researched facts
and expanding incrementally. Facts can cycle on a shorter
period initially.

---

### 5.11 Daily Eco-Fact UI

**Priority:** P0 | **Complexity:** Low

Display the daily fact on the home screen.

#### Home Screen Integration

The daily fact appears as a card on the home screen. It
is visible immediately when the user opens the app.

#### UI Design

```
+-----------------------------------------+
|  Today's Eco-Fact                       |
|-----------------------------------------|
|                                         |
|  "Skipping one beef meal saves ~3 kg    |
|  of CO2 -- the same as not driving      |
|  for 15 km."                            |
|                                         |
|  Source: Poore & Nemecek, Science 2018  |
|                                         |
|  [Share]                    [Archive]   |
+-----------------------------------------+
```

#### Features

- **Category badge:** Small colored label (e.g., "Myth
  Buster", "Surprising Comparison")
- **Source citation:** Always shown for credibility
- **Share button:** Share fact as text to social media
- **Archive/bookmark:** Save favorite facts (optional,
  stored locally)
- **Swipe gesture:** Swipe to dismiss/minimize card

#### Fact History

Optional: "Past Facts" screen accessible from the fact
card, showing previously displayed facts. Since facts are
deterministic by day, this is just a reverse-date lookup.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create DailyFactCard widget | Home screen card | Pending |
| Create fact category badge | Colored label widget | Pending |
| Add share functionality | Share fact text | Pending |
| Add to home screen layout | Below challenges card | Pending |
| Create FactHistoryScreen | Optional past facts view | Pending |
| Create daily fact provider | Select fact by date | Pending |
| Localize UI strings | EN/ES/JA | Pending |
| Write widget tests | Display, share, category | Pending |

#### Files to Create

```
lib/features/daily_fact/
+-- daily_fact.dart                     # Barrel file
+-- data/
|   +-- models/
|   |   +-- eco_fact.dart
|   +-- eco_facts_data.dart             # Static 365 facts
+-- presentation/
    +-- providers/
    |   +-- daily_fact_provider.dart
    +-- screens/
    |   +-- fact_history_screen.dart
    +-- widgets/
        +-- daily_fact_card.dart
        +-- fact_category_badge.dart
```

---

## Data Models

### Summary of New Models

| Model | Type | Storage |
|-------|------|---------|
| GardenElement | Computed class | Derived from action log |
| Biome | Freezed | Static Dart data + user selection in Firestore |
| ChallengeTemplate | Freezed | Static Dart data |
| DailyChallengeState | Freezed | Firestore per-user per-day |
| EcoDexEntry | Freezed | Static Dart data |
| UserEcoDexState | Firestore doc | Firestore per-user |
| EcoFact | Freezed | Static Dart data |

### Firestore Impact

This phase adds minimal Firestore usage:

| Collection | Reads/Day | Writes/Day | Notes |
|------------|-----------|------------|-------|
| dailyChallenges | 1-3 | 1-5 | Per user, daily doc |
| ecoDex/discovered | 0-1 | 0-3 | Only on new discoveries |
| users (biome field) | 0 | Rare | Only on biome change |

All definition data (templates, entries, facts) is static
Dart code shipped with the app. This keeps Firestore costs
near zero for these features.

---

## Implementation Order

### Recommended Sequence

```
Stage 5.1: Daily Eco-Fact (Quick Win)
+-- Create EcoFact model
+-- Curate initial 30-50 facts
+-- Create DailyFactCard widget
+-- Add to home screen
+-- Write tests
    Effort: ~2-3 days

Stage 5.2: Daily Challenges Engine
+-- Create challenge models
+-- Define ~30 templates
+-- Create ChallengeEngine
+-- Create challenge tracker
+-- Integrate with action logging
+-- Write unit tests
    Effort: ~3-4 days

Stage 5.3: Daily Challenges UI
+-- Create DailyChallengesCard
+-- Create ChallengeProgressTile
+-- Add to home screen
+-- Add completion animations
+-- Write widget tests
    Effort: ~2-3 days

Stage 5.4: Eco-Dex Data Layer
+-- Create models (Freezed)
+-- Define ~50 entries with facts
+-- Create repository
+-- Create checker service
+-- Integrate with action logging
+-- Write unit tests
    Effort: ~3-4 days

Stage 5.5: Eco-Dex UI
+-- Create EcoDexScreen
+-- Create entry cards and detail view
+-- Create discovery celebration
+-- Add navigation route
+-- Write widget tests
    Effort: ~3-4 days

Stage 5.6: Garden Foundation
+-- Create garden mapping service
+-- Create GardenCanvas widget
+-- Create GardenScreen
+-- Add element interactions
+-- Write tests
    Effort: ~4-5 days

Stage 5.7: Garden Assets & Biomes
+-- Create/source 15-18 SVGs
+-- Create biome backgrounds
+-- Implement biome selection
+-- Implement biome purchase
+-- Write tests
    Effort: ~3-4 days

Stage 5.8: Polish & Integration
+-- Home screen layout with all new cards
+-- Performance optimization
+-- Localization (EN/ES/JA)
+-- End-to-end testing
+-- Documentation updates
    Effort: ~2-3 days
```

**Total estimated effort: ~22-30 days**

Start with the quick wins (Daily Fact, Challenges) that
immediately create daily engagement hooks. Save the garden
for last since it's the most complex but also the most
visually impressive payoff.

---

## Testing Strategy

### Unit Tests

| Component | Test File | Key Scenarios |
|-----------|-----------|---------------|
| Garden mapping | `garden_mapping_service_test.dart` | Category mapping, size scaling, determinism |
| Challenge engine | `challenge_engine_test.dart` | Deterministic generation, difficulty balance |
| Challenge tracker | `challenge_tracker_test.dart` | Progress tracking, completion |
| Eco-Dex checker | `eco_dex_checker_test.dart` | All criteria types |
| Eco-Dex repository | `eco_dex_repository_test.dart` | Discovery CRUD |
| Daily fact selection | `daily_fact_provider_test.dart` | Date-based selection, cycling |
| Biome purchase | `biome_purchase_test.dart` | Points deduction, unlock |

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| GardenCanvas | `garden_canvas_test.dart` | Element rendering, interactions |
| DailyChallengesCard | `daily_challenges_card_test.dart` | Progress, completion, timer |
| ChallengeProgressTile | `challenge_progress_tile_test.dart` | States, progress bar |
| EcoDexScreen | `eco_dex_screen_test.dart` | Categories, discovered/locked |
| EcoDexCard | `eco_dex_card_test.dart` | Discovered vs locked display |
| DailyFactCard | `daily_fact_card_test.dart` | Fact display, share |

### Integration Tests

| Flow | Test File | Scenarios |
|------|-----------|-----------|
| Challenge flow | `challenge_flow_test.dart` | Log action -> progress -> complete |
| Eco-Dex discovery | `eco_dex_flow_test.dart` | Action -> unlock -> view entry |
| Garden growth | `garden_flow_test.dart` | Log action -> new element appears |

---

## Acceptance Criteria

### 5.1-5.2 Growing Ecosystem
- [ ] Garden renders elements from action history
- [ ] Each action category maps to distinct element types
- [ ] Element size reflects CO2 impact
- [ ] Tap element shows source action info
- [ ] Garden is deterministic (same data = same render)

### 5.3 Biome System
- [ ] 4 biomes defined (1 free, 3 purchasable)
- [ ] Biome purchase deducts points correctly
- [ ] Biome changes garden background and element colors
- [ ] Selected biome persists across sessions

### 5.4-5.5 Daily Challenges
- [ ] 3 challenges generated per day (easy/medium/hard)
- [ ] Same challenges for all users on same day
- [ ] Progress updates when actions are logged
- [ ] Bonus points awarded on completion
- [ ] Extra bonus for completing all 3
- [ ] Challenges reset at midnight

### 5.6 Challenge UI
- [ ] Challenge card visible on home screen
- [ ] Progress bars show accurate progress
- [ ] Countdown timer shows time until reset
- [ ] Completion animation plays

### 5.7-5.8 Eco-Dex
- [ ] ~50 entries defined across 6 categories
- [ ] Entries unlock when criteria are met
- [ ] Each entry contains a verified fact with source
- [ ] Undiscovered entries show "???" with unlock hint
- [ ] Discovery celebration appears on new unlock

### 5.9 Eco-Dex UI
- [ ] Collection screen shows all categories
- [ ] Progress bar shows overall completion
- [ ] Entry detail screen shows fact and source
- [ ] Navigation accessible from profile or home

### 5.10-5.11 Daily Eco-Fact
- [ ] Different fact shown each day
- [ ] Same fact for all users on same day
- [ ] Source citation always visible
- [ ] Share button works
- [ ] Category badge displayed
- [ ] Fact card visible on home screen

---

## Dependencies

### External Dependencies

- SVG creation tools (for garden assets)
- Scientific sources for facts and Eco-Dex entries

### Internal Dependencies

- Phase 4 complete (action library, points system)
- Action log infrastructure (for garden derivation)
- Points system (for biome purchases)
- Streak/level systems (for Eco-Dex criteria)

### New Package Dependencies

None required. Existing packages cover all needs:
- `flutter_svg` for garden element rendering
- `share_plus` for fact sharing (may need to add)

---

## Risk Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Garden performance with many elements | Medium | Medium | Virtualize off-screen elements, cache renders |
| Content quality (365 facts) | Medium | High | Start with 50 verified facts, expand over time |
| Garden SVG art quality | Medium | Low | Use simple flat style, iterate with AI tools |
| Challenge balance | Low | Medium | Playtest, adjust template parameters |
| Eco-Dex unlock pacing | Low | Medium | Test with simulated user data, adjust thresholds |

---

## Notes

- Start with Daily Fact and Challenges for immediate
  engagement impact (both are zero-art features)
- The garden is the crown jewel but can ship last since
  it requires art assets
- Eco-Dex entries double as educational content -- align
  facts with the app's sustainability mission
- All 4 features reinforce each other: challenges drive
  actions, actions grow the garden, milestones unlock
  Eco-Dex entries, facts educate and motivate
- Consider a "daily digest" home screen card that
  combines the fact + challenges in one glanceable view
- 365 facts is aspirational; 50-100 is a solid MVP that
  cycles every 2-3 months

---

*This plan will be updated as implementation progresses.*
