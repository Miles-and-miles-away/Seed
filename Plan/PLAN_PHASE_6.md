# Phase 6: CO₂ Dashboard & Achievement System

**Version:** 1.0
**Created:** January 2026
**Status:** Planning

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [CO₂ Dashboard](#co2-dashboard)
5. [Achievement System](#achievement-system)
6. [User Feedback](#user-feedback)
7. [Data Models](#data-models)
8. [Implementation Order](#implementation-order)
9. [Testing Strategy](#testing-strategy)
10. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 6 adds two major engagement features and a user feedback channel:

1. **CO₂ Dashboard** - Visualize environmental impact with charts, trends, and relatable equivalencies
2. **Achievement System** - Gamify the experience with unlockable badges and bonus point rewards
3. **User Feedback** - In-app feedback form so users can report issues and suggest features

These features deepen user engagement by making progress tangible, rewarding consistent behavior, and giving users a voice.

### Key Objectives

- Add CO₂ dashboard section to Progress screen
- Display impact across multiple time periods with comparisons
- Show relatable equivalencies ("equals X trees planted")
- Implement ~15-20 achievements across multiple categories
- Award bonus points for achievement completion
- Show accomplishments on Profile with "next up" suggestions

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| CO₂ Dashboard UI | Charts, trends, and totals within Progress screen |
| Time Period Selector | Today, this week, this month, all time, custom range |
| Period Comparisons | "20% more than last month" style insights |
| Impact Equivalencies | Trees, car miles, flights, phone charges |
| Achievement System | ~15-20 unlockable achievements |
| Achievement Categories | Action, streak, level, SDG, milestone, special |
| Achievement Rewards | Bonus points + celebration screen |
| Achievement Display | Profile section with badges and "next up" |
| Feedback Form | In-app form with category, description, and device info |
| Feedback Submission | mailto-based delivery with auto-populated metadata |

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 6.1 CO₂ Dashboard UI | P0 | Medium | **Done** |
| 6.2 Time Period Analytics | P0 | Medium | **Done** (custom range dropped) |
| 6.3 Impact Equivalencies | P1 | Low | **Done** |
| 6.4 CO₂ Charts | P1 | Medium | **Done** |
| 6.5 Achievement Data Layer | P0 | Medium | **Done** |
| 6.6 Achievement Definitions | P0 | Low | **Done** |
| 6.7 Achievement Tracking | P0 | Medium | **Done** |
| 6.8 Achievement UI | P0 | Medium | **Done** |
| 6.9 Achievement Celebrations | P1 | Low | **Done** |
| 6.10 User Feedback | P1 | Low | Pending |
| 6.11 UX Polish & Tech Debt | P2 | Low | Pending |

---

## CO₂ Dashboard

### 6.1 Dashboard UI

**Priority:** P0 | **Complexity:** Medium

Add a CO₂ impact section to the Progress screen as the third
segment alongside Calendar and Eco-Dex. §6.1 owns the scaffold,
the time-period selector, the headline total card with
period-over-period comparison, and the foundational schema
change that §6.3 (equivalencies) and §6.4 (charts) build on.

#### Placement

The Progress screen's `SegmentedButton` currently has two values
(`calendar`, `ecoDex`). Add a third: `impact`. The `_segment`
enum and `SegmentedButton` in `progress_screen.dart` gain one
new value and one new `ButtonSegment`; the body switches between
the existing `ProgressCalendar` / `EcoDexScreen` / new
`ImpactDashboard` widgets.

```
[Calendar]  [Impact]  [Eco-Dex]
```

#### UI Design (Impact segment, §6.1 only)

```
+-----------------------------------------+
|  Progress              [Cal][Imp][Dex]  |
+-----------------------------------------+
|                                         |
|  [Today] [Week] [Month] [All Time]      |
|                                         |
|  +-----------------------------------+  |
|  |                                   |  |
|  |       2.5 kg                      |  |
|  |       CO2 saved today             |  |
|  |                                   |  |
|  |   ^ 15% vs. yesterday             |  |
|  |                                   |  |
|  +-----------------------------------+  |
|                                         |
|  (6.3 Equivalencies row -- placeholder) |
|  (6.4 Trend chart -- placeholder)       |
|  (6.4 Category chart -- placeholder)    |
|                                         |
+-----------------------------------------+
```

The container reserves vertical space for the §6.3 and §6.4
sections so they slot in without re-layout. The four time
periods are the canonical set; **custom date range is dropped
from §6.1** (low value vs. the date-picker complexity).

#### Schema Change (foundation for §6.1, §6.4)

`DailySummaryModel` gains one field:

```dart
@Default({}) Map<String, int> categoryCo2Grams,
```

Stored in Firestore as a flat dotted-path field map so partial
updates work via `FieldValue.increment` on a specific key
(e.g., `categoryCo2Grams.transport`).

`DailySummaryRemoteDataSource.incrementDailySummary` gains a
`required String category` parameter and writes:

```dart
'categoryCo2Grams.$category': FieldValue.increment(co2Grams),
```

on both branches (new-summary creation and existing-summary
update). The caller in `ActionLogRepository` already has the
category in scope from the `ActionLogModel` -- one extra
argument to thread through.

**Backfill:** not required. Existing daily summaries simply
have an empty `categoryCo2Grams` map; the dashboard will treat
that as "no category breakdown available for this day". §6.4
will surface this gracefully ("category data unavailable for
older days").

#### Stats Provider Design

```dart
enum TimePeriod { today, thisWeek, thisMonth, allTime }

@freezed
class Co2Stats with _$Co2Stats {
  const factory Co2Stats({
    required int totalGrams,
    required int previousTotalGrams,
    required double percentChange,
    required TimePeriod period,
  }) = _Co2Stats;
}

@riverpod
Future<Co2Stats> co2Stats(Ref ref, TimePeriod period) async {
  // Today / Week / Month: read dailySummaries in [start, end] and sum.
  // All Time: read user.totalCo2Grams (already aggregated).
  // Previous period: read [prevStart, prevEnd] for the same duration.
  // percentChange = (current - previous) / previous * 100, or 0 if prev=0.
}
```

- `today` -> sum of today's daily summary; previous = yesterday's.
- `thisWeek` -> Mon-Sun in device timezone (week starts Monday); previous = last week.
- `thisMonth` -> calendar month; previous = previous calendar month.
- `allTime` -> `user.totalCo2Grams`; previous = 0 -> badge hidden.

Date math lives in a pure helper (`time_period_range.dart`) for
unit-test clarity; it must respect device timezone (matches
existing `StreakService` convention).

#### Components

| Widget | Responsibility |
|--------|----------------|
| `ImpactDashboard` | Top-level Impact segment body; owns the selected `TimePeriod` state and slots in 6.3/6.4 sections later. |
| `TimePeriodSelector` | `SegmentedButton<TimePeriod>` with four values, localized labels. |
| `Co2TotalCard` | Big-number kg display + period label + `PeriodComparisonBadge`. Always shows kilograms with one decimal (e.g. `0.4 kg`, `2.5 kg`, `42.0 kg`). |
| `PeriodComparisonBadge` | Up/down arrow + percent + "vs. yesterday / last week / last month" (terse form, e.g. `▲ 15% vs. yesterday`). Hidden for `allTime` and when previous total is 0. |

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Add `categoryCo2Grams` to `DailySummaryModel` | Freezed field + codegen | Pending |
| Update `incrementDailySummary` write path | Accept `category`, write dotted-path increment | Pending |
| Thread `category` through `ActionLogRepository` call | Pass from `ActionLogModel.category` | Pending |
| Update existing `DailySummaryRemoteDataSource` tests | Cover new field on create and update branches | Pending |
| Create `time_period_range.dart` helper | Pure date math; today / week / month / all-time + previous-period | Pending |
| Create `Co2Stats` Freezed model | Total, previous, percent change, period | Pending |
| Create `co2StatsProvider` | Reads dailySummaries in range; falls back to `user.totalCo2Grams` for all-time | Pending |
| Add `_ProgressSegment.impact` to `progress_screen.dart` | Third segmented-button value | Pending |
| Create `ImpactDashboard` widget | Segment body, owns selected period, mounts §6.1 widgets and 6.3/6.4 placeholders | Pending |
| Create `TimePeriodSelector` widget | 4-value SegmentedButton, localized | Pending |
| Create `Co2TotalCard` widget | Big number in kg (one decimal) + period label + comparison badge | Pending |
| Create `PeriodComparisonBadge` widget | Arrow + percent + terse "vs." reference (e.g. `▲ 15% vs. yesterday`) | Pending |
| Localize strings | EN/ES/JA: 4 period names, 3 comparison references (yesterday / last week / last month), "CO2 saved" header, "kg" unit | Pending |
| Unit tests | `time_period_range` (timezone, Mon-Sun week boundary, month rollovers, leap years), `co2StatsProvider` | Pending |
| Widget tests | `Co2TotalCard` (zero state, sub-kg formatting, large numbers); `PeriodComparisonBadge` (up/down/zero/all-time hidden); `ImpactDashboard` (period switch updates total) | Pending |

#### Files to Create

```
lib/features/progress/domain/
+-- entities/
|   +-- time_period.dart                  # enum
|   +-- co2_stats.dart                    # Freezed model
+-- services/
    +-- time_period_range.dart            # Date-range helper

lib/features/progress/presentation/
+-- providers/
|   +-- co2_stats_provider.dart           # @riverpod Future<Co2Stats>
+-- widgets/
    +-- impact_dashboard.dart             # Segment body
    +-- time_period_selector.dart
    +-- co2_total_card.dart
    +-- period_comparison_badge.dart
```

#### Files to Modify

- `lib/features/progress/data/models/daily_summary_model.dart`
  -- add `categoryCo2Grams` field
- `lib/features/progress/data/datasources/daily_summary_remote_datasource.dart`
  -- accept `category`, write dotted-path increment
- `lib/features/actions/data/repositories/action_log_repository.dart`
  -- pass category through to `incrementDailySummary`
- `lib/features/progress/presentation/screens/progress_screen.dart`
  -- add `_ProgressSegment.impact`, third `ButtonSegment`, body branch
- `lib/core/l10n/app_en.arb` / `app_ja.arb` / `app_es.arb`
  -- new keys for periods, comparison phrases, dashboard header

#### Acceptance for §6.1

- [ ] Impact segment renders alongside Calendar / Eco-Dex
- [ ] All four periods (Today, Week, Month, All Time) compute correct totals against seeded daily summaries
- [ ] Comparison badge shows up/down arrow + percent for non-zero previous totals
- [ ] Comparison badge hidden for All Time and when previous = 0
- [ ] `categoryCo2Grams` increments on every action log (verified by repository test)
- [ ] Total displays in kilograms with one decimal (e.g. `0.4 kg`, `2.5 kg`)
- [ ] All strings localized in EN/JA/ES
- [ ] Unit + widget tests pass

---

### 6.2 Time Period Analytics

**Priority:** P0 | **Complexity:** Medium

Calculate and display CO₂ totals across different time periods.

#### Time Periods

| Period | Definition | Comparison |
|--------|------------|------------|
| Today | Current calendar day | vs. yesterday |
| This Week | Current week (Mon-Sun or Sun-Sat) | vs. last week |
| This Month | Current calendar month | vs. last month |
| All Time | Since account creation | vs. previous equivalent period |
| Custom | User-selected date range | vs. same duration before range |

#### Provider Logic

```dart
@riverpod
class CO2StatsNotifier extends _$CO2StatsNotifier {

  Future<CO2Stats> getStats(TimePeriod period) async {
    final userId = ref.watch(currentUserProvider).value?.uid;
    if (userId == null) return CO2Stats.empty();

    final (startDate, endDate) = _getDateRange(period);
    final (prevStart, prevEnd) = _getPreviousDateRange(period);

    final currentTotal = await _calculateTotal(userId, startDate, endDate);
    final previousTotal = await _calculateTotal(userId, prevStart, prevEnd);

    final percentChange = previousTotal > 0
        ? ((currentTotal - previousTotal) / previousTotal * 100)
        : 0;

    return CO2Stats(
      totalGrams: currentTotal,
      previousTotalGrams: previousTotal,
      percentChange: percentChange,
      period: period,
    );
  }
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create TimePeriod enum | Today, thisWeek, thisMonth, allTime, custom | Pending |
| Create CO2Stats model | Total, previous, change, period | Pending |
| Implement date range calculation | For each period type | Pending |
| Implement comparison calculation | Previous period logic | Pending |
| Create custom date picker | For custom range selection | Pending |
| Handle timezone correctly | Use device timezone | Pending |
| Cache calculations | Avoid recalculating on every rebuild | Pending |
| Write unit tests | Test all period calculations | Pending |

---

### 6.3 Impact Equivalencies

**Priority:** P1 | **Complexity:** Low

Convert CO₂ savings into relatable real-world comparisons.

#### Equivalency Formulas

| Equivalency | Formula | Source |
|-------------|---------|--------|
| Trees planted | CO₂ (kg) / 21 kg per tree/year | EPA |
| Car km avoided | CO₂ (g) / 200 g per km | DEFRA |
| Flights avoided | CO₂ (kg) / 255 kg per hour flight | DEFRA |
| Phone charges | CO₂ (g) / 8 g per charge | EPA |
| Showers saved | CO₂ (g) / 500 g per 8-min shower | Carbon Trust |
| Burgers not eaten | CO₂ (g) / 3,000 g per beef burger | Our World in Data |

*Note: These are approximate values for illustration. Document exact sources in code.*

#### UI Design

```
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐
│  🌳    │ │  🚗    │ │  📱    │ │  🍔    │
│  2.4   │ │  125   │ │  3,125 │ │  8     │
│ trees  │ │  km    │ │charges │ │burgers │
│ /year  │ │not     │ │        │ │        │
│        │ │driven  │ │        │ │        │
└────────┘ └────────┘ └────────┘ └────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create ImpactEquivalency model | Type, value, icon, label | Pending |
| Create equivalency calculator | Convert CO₂ to each type | Pending |
| Create EquivalencyCard widget | Single equivalency display | Pending |
| Create EquivalencyRow widget | Horizontal scrollable row | Pending |
| Select best equivalencies per total | Show most relevant 3-4 | Pending |
| Localize labels | EN/ES/JA | Pending |
| Write unit tests | Test calculations | Pending |

#### Files to Create

```
lib/features/progress/data/
└── impact_equivalencies.dart

lib/features/progress/presentation/widgets/
├── equivalency_card.dart
└── equivalency_row.dart
```

---

### 6.4 CO₂ Charts

**Priority:** P1 | **Complexity:** Medium

Visualize CO₂ trends with interactive charts.

#### Chart Types

| Chart | Purpose | Library |
|-------|---------|---------|
| Line/Area Chart | Daily trend over time | fl_chart |
| Bar Chart | Daily/weekly breakdown | fl_chart |
| Pie/Donut Chart | Category distribution | fl_chart |

#### Chart Package

Recommend `fl_chart` - popular, well-maintained, good Flutter integration.

```yaml
dependencies:
  fl_chart: ^0.69.0
```

#### UI Specifications

**Trend Chart (Line/Area)**
- Default: Last 7 days
- Options: 7 days, 30 days, 90 days
- Y-axis: CO₂ in grams/kg (auto-scale)
- X-axis: Date labels
- Touch interaction: Show value on tap

**Category Chart (Pie/Donut)**
- Show top 4-5 categories
- Group small categories as "Other"
- Legend with percentages
- Touch interaction: Highlight segment

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Add fl_chart dependency | `fl_chart: ^0.69.0` | Done |
| Create `Co2TrendChart` widget | Scatter (dot-only) + dashed mean line, days-since-windowStart x-axis | Done |
| Create `Co2CategoryChart` widget | Donut with center kg label, Top 5 + Other, color-dot legend with % | Done |
| Create chart data provider | `co2TrendDataProvider(period)` + `co2CategoryDataProvider(period)` with pure `buildCategoryData()` for unit testing | Done |
| ~~Add chart range selector~~ | ~~7/30/90 days~~ — **dropped:** range tied to dashboard `TimePeriod` (`Today`/`This Week`→7d, `This Month`→30d, `All Time`→90d) | Done |
| Style charts to match theme | `surfaceContainerLow` card, primary for dots, `onSurfaceVariant` for mean, per-category colors via `ActionCategory.color` | Done |
| Handle empty data state | Each chart hides itself when not plottable (`<2` trend points / `0` category grams); `_ChartsSection` collapses entirely when both empty | Done |
| Localize chart labels | EN/JA/ES (`trendChartTitle`, `trendChartAverageLabel`, `categoryChartTitle`, `categoryOther`) | Done |
| Write tests | Unit (`buildCategoryData` aggregation + Top 5 rollup + unknown-category handling) + widget (`Co2TrendChart`, `Co2CategoryChart`, dashboard wiring) | Done |

#### Files Created

```
lib/features/progress/
+-- domain/entities/co2_chart_data.dart        # Freezed Co2TrendData / Co2CategoryData
+-- presentation/
    +-- providers/co2_chart_data_provider.dart # @riverpod data sources
    +-- widgets/co2_trend_chart.dart           # Scatter + mean line
    +-- widgets/co2_category_chart.dart        # Donut + legend

lib/features/progress/presentation/widgets/impact_dashboard.dart
  -- new `_ChartsSection` consumer mounts both charts and self-hides

lib/features/progress/domain/services/time_period_range.dart
  -- added `trendWindowDays()` and `trendWindow()` helpers

test/features/progress/
+-- presentation/providers/co2_chart_data_provider_test.dart
+-- presentation/widgets/co2_trend_chart_test.dart
+-- presentation/widgets/co2_category_chart_test.dart
```

#### Notes vs original plan

- `ProgressRepository.getSummariesForDateRange` already existed from §6.1
  -- no new data-source method was needed.
- "Bar Chart" listed as a third chart type was treated as redundant with
  the scatter trend chart and dropped per the consolidated design.
- Independent 7/30/90 range selector dropped in favour of tying to the
  dashboard's `TimePeriod` selector -- one source of period truth.

---

## Achievement System

### 6.5 Achievement Data Layer

**Priority:** P0 | **Complexity:** Medium

Define data models and storage for achievements.

#### Data Model

```dart
@freezed
class AchievementDefinition with _$AchievementDefinition {
  const factory AchievementDefinition({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required String descriptionEn,
    required String descriptionJa,
    required String descriptionEs,
    required String category,        // action, streak, level, sdg, milestone, special
    required String iconName,        // Material icon or custom asset
    required int bonusPoints,        // Points awarded on unlock
    required AchievementCriteria criteria,
  }) = _AchievementDefinition;
}

@freezed
class AchievementCriteria with _$AchievementCriteria {
  // Different criteria types
  const factory AchievementCriteria.actionCount({
    required int count,
    String? category,      // Optional: specific category
    String? actionId,      // Optional: specific action
  }) = ActionCountCriteria;

  const factory AchievementCriteria.streakDays({
    required int days,
  }) = StreakDaysCriteria;

  const factory AchievementCriteria.levelReached({
    required int level,
  }) = LevelReachedCriteria;

  const factory AchievementCriteria.sdgCount({
    required int count,    // Number of different SDGs supported
  }) = SdgCountCriteria;

  const factory AchievementCriteria.co2Saved({
    required int grams,
  }) = Co2SavedCriteria;

  const factory AchievementCriteria.special({
    required String type,  // e.g., "first_action", "account_created"
  }) = SpecialCriteria;
}

@freezed
class UserAchievement with _$UserAchievement {
  const factory UserAchievement({
    required String odefinitionId,
    required DateTime unlockedAt,
  }) = _UserAchievement;
}
```

> **Note (§6.9):** the originally-spec'd `pointsClaimed` flag was dropped
> -- celebration is tap-only and no UI consumes an "unclaimed badge"
> state. Re-add the field when such a UX actually needs it.

#### Firestore Structure

```
users/{userId}/achievements/
├── {achievementId}/
│   └── unlockedAt: timestamp

# Achievement definitions stored locally (not in Firestore)
# This keeps them fast and avoids unnecessary reads
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AchievementDefinition model | Hand-written class (matches `EcoDexEntry` pattern); JSON parser + locale fallback helpers | Done |
| Create AchievementCriteria model | Freezed `sealed` union with `unionKey: 'type'`; 7 variants (actionCount, streakDays, levelReached, sdgCount, co2Saved, categoriesCovered, special) | Done |
| Create UserAchievement model | Freezed model with `RequiredTimestampConverter`; doc id = achievement id | Done |
| Create AchievementRepository | Read-only catalog + Firestore CRUD; idempotent unlock; cached definitions | Done |
| Create achievement definitions file | `data/app/achievements.json` (19 entries, EN/JA/ES) loaded via bundled-asset pattern | Done |
| Run code generation | Freezed + JSON serializable + Riverpod generators | Done |
| Write unit tests | Criteria round-trip, definition parser + l10n fallback, JSON loader, remote datasource CRUD, repository end-to-end (36 tests) | Done |

#### Files Created

```
data/app/achievements.json                                    # 19 entries

lib/features/achievements/
+-- achievements.dart                                         # Barrel
+-- data/
|   +-- achievement_definitions_data.dart                     # rootBundle loader
|   +-- datasources/achievements_remote_datasource.dart       # Firestore CRUD
|   +-- models/
|   |   +-- achievement_category.dart                         # Enum
|   |   +-- achievement_criteria_model.dart                   # Freezed sealed union
|   |   +-- achievement_definition_model.dart                 # Hand-written
|   |   +-- user_achievement_model.dart                       # Freezed
|   +-- repositories/achievements_repository.dart
+-- presentation/providers/achievement_providers.dart         # @riverpod
```

#### Notes vs original plan

- Achievement definitions ship as bundled JSON (`data/app/achievements.json`)
  rather than a static Dart constant list. Matches the existing
  catalog convention (`eco_dex_entries.json`, `challenge_templates.json`,
  `impact_equivalencies.json`) and keeps copy edits out of code.
- `AchievementDefinition` is hand-written (not Freezed) to mirror
  `EcoDexEntry`: it is read-only, one-shot loaded, and avoids ~37 KB of
  generated `.freezed.dart` boilerplate.
- Added `categoriesCovered` as a first-class criterion variant for
  `try_all_categories` instead of overloading `actionCount`.

---

### 6.6 Achievement Definitions

**Priority:** P0 | **Complexity:** Low

Define the ~15-20 achievements for launch.

#### Achievement List

**Special (2)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `first_action` | First Step | Log your first action | special: first_action | 50 |
| `joined_seed` | Welcome to Seed | Create your account | special: account_created | 25 |

**Action-Based (5)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `actions_10` | Getting Started | Log 10 actions | actionCount: 10 | 100 |
| `actions_50` | Making Progress | Log 50 actions | actionCount: 50 | 250 |
| `actions_100` | Century Club | Log 100 actions | actionCount: 100 | 500 |
| `actions_500` | Dedicated | Log 500 actions | actionCount: 500 | 1000 |
| `try_all_categories` | Explorer | Log an action in every category | actionCount: 1, each category | 200 |

**Streak-Based (4)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `streak_7` | One Week Strong | Maintain a 7-day streak | streakDays: 7 | 150 |
| `streak_30` | Monthly Master | Maintain a 30-day streak | streakDays: 30 | 500 |
| `streak_100` | Unstoppable | Maintain a 100-day streak | streakDays: 100 | 1500 |
| `streak_365` | Year of Impact | Maintain a 365-day streak | streakDays: 365 | 5000 |

**Level-Based (3)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `level_5` | Rising Star | Reach level 5 | levelReached: 5 | 100 |
| `level_10` | Eco Warrior | Reach level 10 | levelReached: 10 | 250 |
| `level_25` | Sustainability Champion | Reach level 25 | levelReached: 25 | 750 |

**SDG-Based (2)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `sdg_5` | Diverse Impact | Support 5 different SDGs | sdgCount: 5 | 200 |
| `sdg_all` | Global Citizen | Support all 17 SDGs | sdgCount: 17 | 1000 |

**Milestone-Based (3)**
| ID | Name | Description | Criteria | Points |
|----|------|-------------|----------|--------|
| `co2_1kg` | First Kilogram | Save 1 kg of CO₂ | co2Saved: 1000 | 100 |
| `co2_100kg` | Carbon Cutter | Save 100 kg of CO₂ | co2Saved: 100000 | 500 |
| `co2_1000kg` | Climate Hero | Save 1,000 kg of CO₂ | co2Saved: 1000000 | 2000 |

**Total: 19 achievements**

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Define all achievements in JSON | 19 entries in `data/app/achievements.json` (2 special, 5 action, 4 streak, 3 level, 2 sdg, 3 milestone) | Done |
| Localize achievement names | EN / JA / ES per entry | Done |
| Localize achievement descriptions | EN / JA / ES per entry | Done |
| Select icons for each achievement | Material icons (`rocket_launch`, `local_fire_department`, `military_tech`, ...) | Done |
| Balance point rewards | Range 25 - 5000; total bonus pool 14,175 pts | Done |

---

### 6.7 Achievement Tracking

**Priority:** P0 | **Complexity:** Medium

Check for achievement completion and award points.

#### Tracking Logic

Achievements should be checked at these trigger points:

| Trigger | Achievements to Check |
|---------|----------------------|
| Action logged | action-based, sdg-based, co2-based, special (first_action) |
| Streak updated | streak-based |
| Level up | level-based |
| Account created | special (joined_seed) |

#### Achievement Checker Service

```dart
class AchievementChecker {
  final AchievementsRepository _repository;
  final List<AchievementDefinition> _definitions;

  /// Check all relevant achievements after an action is logged
  Future<List<AchievementDefinition>> checkAfterActionLogged({
    required String userId,
    required int totalActions,
    required int totalCo2Grams,
    required Set<String> categoriesUsed,
    required Set<String> sdgsSupported,
  }) async {
    final unlockedIds = await _repository.getUnlockedIds(userId);
    final newlyUnlocked = <AchievementDefinition>[];

    for (final definition in _definitions) {
      if (unlockedIds.contains(definition.id)) continue;

      final isUnlocked = _checkCriteria(
        definition.criteria,
        totalActions: totalActions,
        totalCo2Grams: totalCo2Grams,
        categoriesUsed: categoriesUsed,
        sdgsSupported: sdgsSupported,
      );

      if (isUnlocked) {
        await _repository.unlockAchievement(userId, definition.id);
        await _awardPoints(userId, definition.bonusPoints);
        newlyUnlocked.add(definition);
      }
    }

    return newlyUnlocked;
  }
}
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AchievementChecker service | Pure sync function over `AchievementUserState`; switch-expression over the 7 criterion variants | Done |
| Integrate with action logging | Pre-txn unlocked-ids read + in-txn evaluation, all atomic with the existing action-log transaction | Done |
| Integrate with streak service | Folded into the action-log flow (streak update happens in the same txn) | Done |
| Integrate with level up | Folded into the action-log flow; bonus points retrigger `calculateLevel` so unlocks that push a level threshold update both fields | Done |
| Create achievement unlock logic | `transaction.set` on `users/{uid}/achievements/{id}`; per-candidate `transaction.get` race check skips concurrent duplicates | Done |
| Create point award logic | Bonus points accumulate into `newPoints` inside the same txn that increments the rest of the user-state | Done |
| Return newly unlocked list | `ActionLogResult.newlyUnlockedAchievements` (consumed by §6.9 celebration screen, defaults to `[]`) | Done |
| Write unit tests | 18 pure-checker tests + 5 action-log integration tests covering first-action, multi-unlock, idempotency, bonus level recalc, empty catalog | Done |

#### Files Created

```
lib/features/achievements/domain/services/achievement_checker.dart
  -- AchievementUserState snapshot + pure AchievementChecker

test/features/achievements/domain/services/
  +-- achievement_checker_test.dart
```

#### Files Modified

- `lib/features/actions/data/repositories/action_log_repository.dart`
  -- threads `achievementsDataSource` + `achievementDefinitions`;
     pre-txn `getUserAchievements` read; in-txn evaluator + unlock
     writes + bonus-point accumulation
- `lib/features/actions/data/repositories/action_log_repository.dart`
  -- `ActionLogResult.newlyUnlockedAchievements` field + `didUnlockAchievement` getter
- `lib/features/actions/presentation/providers/actions_providers.dart`
  -- wires the new repo dependencies via existing achievement providers
- `test/features/actions/data/repositories/action_log_repository_test.dart`
  -- updated existing setUps + appended a new `achievement unlocks
     inside logAction txn` group

#### Notes vs original plan

- `joined_seed` ("Welcome to Seed") **was dropped** in favour of a new
  `first_streak_3` ("Spark", 3-day streak, 75 pts). Rationale: a signup
  unlock would require a second integration hook in `AuthRepository`
  while adding no demonstrable value -- `first_action` already shows
  the user the achievement system on action #1. `first_streak_3`
  bridges the gap between `first_action` and `streak_7` and reinforces
  early-week retention. Catalog now has 19 entries (1 special / 5
  action / **5** streak / 3 level / 2 sdg / 3 milestone).
- Account-creation hook in `AuthRepository._createNewUser` is no
  longer needed; the action-log txn is the sole integration site.

---

### 6.8 Achievement UI

**Priority:** P0 | **Complexity:** Medium

Display achievements in the app.

#### Locations

1. **Profile Screen** - "Achievements" section showing earned badges
2. **Achievements Detail Screen** - Full list with "next up" section

#### Profile Section Design

```
┌─────────────────────────────────────────┐
│  ─────── Achievements ───────           │
│                                         │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ [→]  │
│  │ 🌟  │ │ 🔥  │ │ 🎯  │ │ +12 │       │
│  │     │ │     │ │     │ │more │       │
│  └─────┘ └─────┘ └─────┘ └─────┘       │
│                                         │
│  12 of 19 unlocked                      │
│                                         │
└─────────────────────────────────────────┘
```

#### Achievements Screen Design

```
┌─────────────────────────────────────────┐
│  ←         Achievements                 │
├─────────────────────────────────────────┤
│                                         │
│  12 of 19 unlocked                      │
│  ████████████░░░░░░░ 63%               │
│                                         │
│  ─────── Next Up ───────                │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🎯 Century Club                 │   │
│  │ Log 100 actions                 │   │
│  │ ████████░░░░ 78/100            │   │
│  └─────────────────────────────────┘   │
│  ┌─────────────────────────────────┐   │
│  │ 🔥 Monthly Master               │   │
│  │ Maintain a 30-day streak        │   │
│  │ ██████░░░░░░ 18/30 days        │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── Unlocked ───────               │
│                                         │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ 🌟  │ │ 🔥  │ │ 🎯  │ │ 🌍  │      │
│  │First│ │7-day│ │ 50  │ │5 SDG│      │
│  │Step │ │strk │ │acts │ │     │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐      │
│  │ ... │ │ ... │ │ ... │ │ ... │      │
│  └─────┘ └─────┘ └─────┘ └─────┘      │
│                                         │
└─────────────────────────────────────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AchievementBadge widget | Circular icon + localized name; locked/unlocked color variants | Done |
| Create AchievementCard widget | Row layout: icon + name + description + optional progress bar | Done |
| Create ProfileAchievementsSection | Up to 3 unlocked badges + "+N more" chip + count + tap-through arrow | Done |
| Create AchievementsScreen | At `/profile/achievements`: progress header + Next Up + Unlocked + Locked grids | Done |
| Create "Next Up" section | Sorts locked achievements by progress fraction desc (special excluded) | Done |
| Calculate progress for each | Pure `achievementProgressOf(criteria, state)` helper with `AchievementProgress` value type | Done |
| Add route to achievements screen | `AppRoutes.achievements` nested under profile shell | Done |
| Localize all strings | 7 new keys in EN / JA / ES (`achievementsTitle`, `achievementsProgress`, `achievementsEmptyHint`, `achievementsLoadError`, `achievementsNextUp`, `achievementsUnlocked`, `achievementsLocked`) | Done |
| Write widget tests | 14 tests across 5 files: badge, progress bar, card, next-up sorting/exclusion, profile section overrides | Done |

#### Files Created

```
lib/features/achievements/
+-- domain/services/achievement_progress.dart                # Pure progress calc
+-- presentation/
|   +-- screens/achievements_screen.dart                     # Full screen
|   +-- widgets/
|       +-- achievement_badge.dart                           # Circular badge
|       +-- achievement_card.dart                            # Detailed row card
|       +-- achievement_icons.dart                           # iconName -> IconData
|       +-- achievement_progress_bar.dart                    # Bar + label
|       +-- next_up_section.dart                             # Top-N closest
|       +-- profile_achievements_section.dart                # Profile preview

test/features/achievements/
+-- domain/services/achievement_progress_test.dart           # 9 tests
+-- presentation/widgets/
    +-- achievement_badge_test.dart                          # 3 tests
    +-- achievement_card_test.dart                           # 2 tests
    +-- achievement_progress_bar_test.dart                   # 2 tests
    +-- next_up_section_test.dart                            # 4 tests
    +-- profile_achievements_section_test.dart               # 3 tests
```

#### Files Modified

- `lib/app/router.dart` -- add `AppRoutes.achievements` + nested `GoRoute`
- `lib/features/profile/presentation/screens/profile_screen.dart`
  -- slot `ProfileAchievementsSection` between stats and sign-out
- `lib/features/achievements/achievements.dart`
  -- export new domain services, widgets, and screen
- `lib/core/l10n/app_en.arb` / `app_ja.arb` / `app_es.arb`
  -- 7 new keys

---

### 6.9 Achievement Celebrations

**Priority:** P1 | **Complexity:** Low

Celebrate when users unlock achievements.

#### Celebration Flow

1. User action triggers achievement unlock
2. Ephemeral celebration screen appears
3. Shows achievement badge, name, description
4. Shows bonus points earned
5. User taps to dismiss or auto-dismiss after 3 seconds

#### Celebration Screen Design

```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│           🎉 Achievement! 🎉            │
│                                         │
│              ┌───────┐                  │
│              │  🔥   │                  │
│              │       │                  │
│              └───────┘                  │
│                                         │
│          One Week Strong                │
│                                         │
│    Maintain a 7-day streak              │
│                                         │
│           +150 points!                  │
│                                         │
│                                         │
│         [ Tap to continue ]             │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

#### Implementation

- Use a modal overlay or full-screen route
- Add confetti animation (reuse from evolution celebration)
- Auto-dismiss after 3-4 seconds or on tap
- Queue multiple achievements if unlocked simultaneously

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AchievementCelebrationScreen | Full-screen overlay via `showGeneralDialog` (transparent barrier) with backdrop, confetti, icon, name, description, bonus-point line, "tap to continue" hint, and "+N more queued" indicator | Done |
| Add confetti animation | Inline `_ConfettiLayer` (40 particles, 4 celebration colors); separate copy from `EggHatchingCelebration` -- enough structural divergence that a shared widget would be premature | Done |
| Add points animation | `+X points!` in gold animates via `flutter_animate` (fade + scale-out-back) | Done |
| ~~Implement auto-dismiss~~ | **Dropped:** tap-only dismiss. Auto-dismiss risks rare unlocks scrolling past unread; sequential queue means user controls pacing | Done |
| Queue multiple achievements | `showAchievementCelebrations(...)` loops the list, awaits dismiss between items, surfaces "+N more queued" count on each | Done |
| Integrate with achievement checker | Triggered in `handle_action_tap.dart` after the streak-milestone block when `logResult.didUnlockAchievement` | Done |
| ~~Wire `markPointsClaimed` on dismiss~~ | **Dropped:** `pointsClaimed` flag removed from the data layer entirely. No current consumer relied on it; adding the write path was hypothetical-future-feature work. Re-add the field when an actual "unclaimed badge" UX needs it. | Done |
| Write widget tests | 5 tests: renders content + bonus + tap hint, "+N more queued" indicator, tap dismisses, queue advances in order, empty list no-op | Done |

#### Files Created

```
lib/features/achievements/presentation/screens/achievement_celebration_screen.dart
  -- AchievementCelebrationScreen widget + showAchievementCelebrations helper

test/features/achievements/presentation/screens/
  +-- achievement_celebration_screen_test.dart
```

#### Files Modified

- `lib/features/actions/presentation/utils/handle_action_tap.dart`
  -- consumes `logResult.newlyUnlockedAchievements`
- `lib/features/achievements/achievements.dart` -- export new screen
- `lib/core/l10n/app_en.arb` / `app_ja.arb` / `app_es.arb`
  -- 4 new keys (`achievementUnlockedTitle`, `achievementBonusPoints`,
     `achievementTapToContinue`, `achievementMoreQueued`)

---

## User Feedback

### 6.10 User Feedback

**Priority:** P1 | **Complexity:** Low

Give users a clear, low-friction way to report bugs, suggest features, or
share general feedback — without leaving the app.

#### Current State

The About screen (`about_screen.dart`) already has a basic "Contact" tile
that opens a `mailto:` link with a generic subject line. This works but
provides no structure — the developer receives unformatted emails with
no device or app context.

#### Approach: Structured Feedback Form + mailto

Use a dedicated in-app form that collects structured input, then submits
via a pre-populated `mailto:` URI. This keeps the implementation simple
(no backend endpoint or Firestore writes needed), while still giving the
user a polished experience and the developer useful context.

**Why mailto over Firestore:**
- Zero additional backend cost or security rules
- Feedback lands directly in an inbox that can be triaged
- No new Firestore collection to maintain or monitor
- `url_launcher` is already a dependency

#### UI Design

**Entry Point** — Replace the existing "Contact" tile in the About
screen's Support section with a "Send Feedback" tile that navigates
to the new feedback screen.

```
┌─────────────────────────────────────────┐
│  <-         Send Feedback               │
├─────────────────────────────────────────┤
│                                         │
│  Category                               │
│  ┌─────────────────────────────────┐   │
│  │ [Bug Report] [Feature Request]  │   │
│  │ [General Feedback]              │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Describe your feedback                 │
│  ┌─────────────────────────────────┐   │
│  │                                 │   │
│  │  (multiline text field)         │   │
│  │                                 │   │
│  │                                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  The following info is included to      │
│  help us investigate:                   │
│  App v1.2.0 (42) | iOS 18.3 | en       │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │        Submit Feedback          │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

#### Feedback Categories

| Category | mailto Subject Prefix |
|----------|----------------------|
| Bug Report | `[Bug]` |
| Feature Request | `[Feature]` |
| General Feedback | `[Feedback]` |

#### mailto Body Template

```
Category: Bug Report
---
<user's description text>
---
App: Seed v1.2.0 (42)
Platform: iOS 18.3
Device: iPhone 15 Pro
Locale: en
User ID: <uid, if authenticated>
```

Device metadata is gathered automatically via `package_info_plus`
(already a dependency) and `dart:io` Platform info. The user ID is
included only if the user is signed in and helps correlate feedback
with account state.

#### Navigation

```
Profile -> Settings -> Support -> Send Feedback (new screen)
Route: /profile/settings/feedback
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create FeedbackCategory enum | bug, featureRequest, general | Pending |
| Create FeedbackScreen | Form with category chips and text field | Pending |
| Build mailto URI with metadata | Category prefix, body template, device info | Pending |
| Add route to go_router | /profile/settings/feedback | Pending |
| Replace About screen Contact tile | Point to new feedback screen | Pending |
| Localize all strings | EN/JA | Pending |
| Write widget tests | Form validation, category selection | Pending |

#### Files to Create / Modify

```
lib/features/settings/presentation/screens/
└── feedback_screen.dart              # New

lib/features/settings/presentation/screens/
└── about_screen.dart                 # Modify: update Support section

lib/app/router.dart                   # Modify: add feedback route
```

#### Considerations

- **Validation:** Require a non-empty description before enabling the
  submit button. No minimum length — even a short note is useful.
- **Confirmation:** After launching the mail client, show a SnackBar
  thanking the user for their feedback.
- **Offline:** `mailto:` works offline — it queues in the user's mail
  app. No connectivity check needed.
- **Future upgrade path:** If feedback volume grows, swap the mailto
  submission for a Firestore write to a `feedback` collection or
  integrate a third-party tool (e.g., Instabug). The form UI stays
  the same.

---

## UX Polish & Tech Debt

### 6.11 UX Polish & Tech Debt

**Priority:** P2 | **Complexity:** Low

Cross-cutting polish items: skeleton loading, haptic feedback,
dark mode audit, shared error/empty states. Verified against
the codebase on 2026-05-03: only an inline `.shimmer()` effect
on the mascot screen exists (no shared skeleton widgets), and
there are no `HapticFeedback` calls anywhere in `lib/`.

#### Items

| Item | Description | Notes |
|------|-------------|-------|
| Skeleton/shimmer loading states | Shared `SkeletonLoader` and `ShimmerEffect` widgets, applied across screens currently using `CircularProgressIndicator`. | Replaces ad-hoc spinners on Profile stats, Action grid, Progress calendar, Achievements grid. |
| Haptic feedback | `HapticFeedback.lightImpact()` / `selectionClick()` on key taps (log action, achievement unlock, paywall purchase, mascot interaction). | Currently zero usages in `lib/`. |
| Dark mode audit | Walk every screen in dark mode, fix contrast and surface colors. Theme infrastructure already exists in `lib/core/theme/`. | Audit task, not new code. |
| User-friendly error messages | Shared `ErrorView` widget for failed loads (auth, Firestore reads, action logging). Today errors are caught ad-hoc with bare `catch (e)` blocks. | No shared error widget exists. |
| Empty states | Shared `EmptyState` widget for "no actions yet", "no achievements unlocked", "no eco-dex entries discovered". | No shared empty-state widget exists. |

#### Out of Scope (future considerations)

- Advanced notification analytics (open/dismiss rates per category)
- Notification A/B testing framework

Nice-to-have research tasks rather than user-facing features.
Park in backlog; revisit only if engagement data calls for it.

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create SkeletonLoader widget | Shared widget with rounded blocks | Pending |
| Create ShimmerEffect widget | Animated shimmer overlay | Pending |
| Apply skeletons to Profile stats cards | Replace CircularProgressIndicator | Pending |
| Apply skeletons to Action grid | Replace spinner during load | Pending |
| Apply skeletons to Progress calendar | Replace spinner during load | Pending |
| Add haptic feedback on log action | `HapticFeedback.mediumImpact()` | Pending |
| Add haptic feedback on achievement unlock | `HapticFeedback.heavyImpact()` | Pending |
| Add haptic feedback on subscription purchase | Confirmation feedback | Pending |
| Dark mode walkthrough | Per-screen contrast and surface check | Pending |
| Fix dark mode issues found | Adjust colors in `app_colors.dart` | Pending |
| Create ErrorView widget | Shared error state with retry | Pending |
| Create EmptyState widget | Shared empty-state with icon + message | Pending |
| Apply ErrorView to async load failures | Replace bare error text/spinners | Pending |
| Apply EmptyState to "no data" screens | Action history, achievements, eco-dex | Pending |

#### Files to Create

```
lib/shared/widgets/
+-- skeleton_loader.dart
+-- shimmer_effect.dart
+-- error_view.dart
+-- empty_state.dart
```

---

## Data Models

### CO₂ Stats Model

```dart
@freezed
class CO2Stats with _$CO2Stats {
  const factory CO2Stats({
    required int totalGrams,
    required int previousTotalGrams,
    required double percentChange,
    required TimePeriod period,
    DateTime? startDate,
    DateTime? endDate,
  }) = _CO2Stats;

  factory CO2Stats.empty() => const CO2Stats(
    totalGrams: 0,
    previousTotalGrams: 0,
    percentChange: 0,
    period: TimePeriod.today,
  );
}

enum TimePeriod {
  today,
  thisWeek,
  thisMonth,
  allTime,
  custom,
}
```

### Chart Data Models

```dart
@freezed
class CO2TrendData with _$CO2TrendData {
  const factory CO2TrendData({
    required List<CO2DataPoint> points,
    required int maxValue,
    required int minValue,
  }) = _CO2TrendData;
}

@freezed
class CO2DataPoint with _$CO2DataPoint {
  const factory CO2DataPoint({
    required DateTime date,
    required int grams,
  }) = _CO2DataPoint;
}

@freezed
class CO2CategoryData with _$CO2CategoryData {
  const factory CO2CategoryData({
    required String category,
    required int grams,
    required double percentage,
    required Color color,
  }) = _CO2CategoryData;
}
```

### Impact Equivalency Model

```dart
@freezed
class ImpactEquivalency with _$ImpactEquivalency {
  const factory ImpactEquivalency({
    required String type,      // trees, carKm, phoneCharges, etc.
    required double value,
    required String iconName,
    required String labelEn,
    required String labelJa,
    required String labelEs,
  }) = _ImpactEquivalency;
}
```

---

## Implementation Order

### Recommended Sequence

```
Stage 6.1: CO₂ Dashboard Foundation
├── Create CO2Stats model and provider
├── Add time period selector widget
├── Create CO2TotalCard widget
├── Integrate into ProgressScreen
└── Add period comparison logic

Stage 6.2: Impact Equivalencies
├── Create equivalency calculator
├── Create EquivalencyCard widgets
├── Add equivalency row to dashboard
└── Write unit tests for calculations

Stage 6.3: CO₂ Charts
├── Add fl_chart dependency
├── Create CO2TrendChart widget
├── Create CO2CategoryChart widget
├── Add chart data providers
└── Write widget tests

Stage 6.4: Achievement Data Layer
├── Create achievement models (Freezed)
├── Create achievement definitions
├── Create AchievementsRepository
├── Run code generation
└── Write unit tests

Stage 6.5: Achievement Tracking
├── Create AchievementChecker service
├── Integrate with action logging
├── Integrate with streak service
├── Integrate with level up
└── Write unit tests

Stage 6.6: Achievement UI
├── Create achievement widgets
├── Create AchievementsScreen
├── Add profile achievements section
├── Add route and navigation
└── Write widget tests

Stage 6.7: Achievement Celebrations
├── Create celebration screen
├── Add confetti animation
├── Implement auto-dismiss
├── Queue multiple achievements
└── Write tests

Stage 6.8: User Feedback
├── Create FeedbackScreen with category chips
├── Build mailto URI with device metadata
├── Add route and update About screen
├── Localize strings
└── Write widget tests

Stage 6.9: UX Polish & Tech Debt
├── Build SkeletonLoader and ShimmerEffect widgets
├── Apply skeletons across screens with spinner loads
├── Add haptic feedback on key interactions
├── Walk every screen in dark mode and fix issues
└── Write tests for new shared widgets

Stage 6.10: Polish & Testing
├── End-to-end testing
├── Localization (EN/ES/JA)
├── Bug fixes
└── Documentation updates
```

---

## Testing Strategy

### Unit Tests

| Component | Test File | Key Scenarios |
|-----------|-----------|---------------|
| CO2Stats provider | `co2_stats_provider_test.dart` | Period calculations, comparisons |
| Equivalency calculator | `impact_equivalencies_test.dart` | All conversion formulas |
| Chart data provider | `co2_chart_data_provider_test.dart` | Data aggregation |
| Achievement criteria | `achievement_criteria_test.dart` | All criteria types |
| Achievement checker | `achievement_checker_test.dart` | Unlock logic, point award |
| Achievement repository | `achievements_repository_test.dart` | CRUD operations |

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| CO2TotalCard | `co2_total_card_test.dart` | Display, comparison badge |
| TimePeriodSelector | `time_period_selector_test.dart` | Selection, callback |
| EquivalencyCard | `equivalency_card_test.dart` | Display formatting |
| CO2TrendChart | `co2_trend_chart_test.dart` | Rendering, empty state |
| AchievementBadge | `achievement_badge_test.dart` | Locked/unlocked states |
| AchievementCard | `achievement_card_test.dart` | Progress display |
| AchievementsScreen | `achievements_screen_test.dart` | List rendering |
| CelebrationScreen | `achievement_celebration_test.dart` | Display, dismiss |
| FeedbackScreen | `feedback_screen_test.dart` | Category selection, validation, mailto URI |

---

## Acceptance Criteria

### 6.1 CO₂ Dashboard UI — **Complete**
- [x] Dashboard section visible in Progress screen (Impact segment)
- [x] Shows total CO₂ saved prominently (kg with one decimal)
- [x] Time period selector works correctly (Today / Week / Month / All Time)
- [x] Comparison badge shows % change (hidden for All Time and previous=0)
- [x] `categoryCo2Grams` increments on every action log
- [x] All strings localized in EN/JA/ES
- [x] Unit + widget tests pass

### 6.2 Time Period Analytics — **Complete**
- [x] Today shows current day total
- [x] This week shows Mon-Sun total (device timezone)
- [x] This month shows calendar month total
- [x] All time shows lifetime total (from `user.totalCo2Grams`)
- [x] Comparisons calculate correctly (previous-period delta)

### 6.3 Impact Equivalencies — **Complete**
- [x] Shows 4 equivalencies (trees, car km, phone charges, beef burgers)
      — ~~"select best 3-4 per total"~~ dropped; sub-unit floor handles the
      demoralization case and we have 4 fixed types, not 6
- [x] Calculations are accurate (factors sourced per `Plan/AUDIT_FACT_DATA.md`)
- [x] Icons and labels display correctly; sub-rounding values floor to
      `<0.1` / `<1` so a real action never reads as zero
- [x] Negative totals clamped to 0; row + header hidden when total = 0
- [x] Localized labels in EN/JA/ES (`tree-years`, `beef burgers`)
- [x] **Info sheet** (`EquivalencyInfoSheet`) with explainer, tappable
      source citation, and locale-formatted formula per equivalency,
      reached via info icon next to the "Equivalent to" header
- [x] Conversion factors + source URLs live in
      `data/app/impact_equivalencies.json`, loaded via
      `impactEquivalenciesDataProvider` — single source of truth, matches
      the codebase's catalog pattern (`sdg_resources.json` etc.)
- [x] Unit + widget tests pass (calculator, row, card, info sheet,
      dashboard zero-state)

### 6.4 CO₂ Charts — **Complete**
- [x] Trend chart shows daily data — scatter dots over a 7/30/90-day
      rolling window with a dashed horizontal mean line
- [x] Category chart shows distribution — donut with center total kg,
      Top 5 categories + lumped "Other", legend with % shares
- [x] Charts handle empty data gracefully — each hides on insufficient
      data; whole section collapses when both empty
- [x] Touch interactions work — `fl_chart` built-in scatter tooltip
      shows date + kg; donut highlights segments on tap
- [x] Range tied to dashboard `TimePeriod` (no separate range selector)
- [x] Localized in EN/JA/ES
- [x] Unit + widget tests pass

### 6.5 Achievement Data Layer — **Complete**
- [x] All models serialize correctly (criteria round-trip + JSON loader covered by unit tests)
- [x] Repository CRUD works (`fake_cloud_firestore`-backed datasource + repository tests)
- [x] 19 achievements defined in `data/app/achievements.json`
- [x] All localized in EN / JA / ES

### 6.6 Achievement Definitions — **Complete**
- [x] All 6 categories represented (special / action / streak / level / sdg / milestone)
- [x] Point values balanced from 25 (Welcome to Seed) to 5000 (Year of Impact)
- [x] Criteria types working — `actionCount`, `streakDays`, `levelReached`, `sdgCount`, `co2Saved`, `categoriesCovered`, `special`

### 6.7 Achievement Tracking — **Complete**
- [x] Checks trigger at correct times (every `logAction` txn evaluates the full catalog against post-update state)
- [x] Unlocks save to Firestore atomically with the rest of the user-state update
- [x] Bonus points awarded correctly; level recomputed after bonuses to catch threshold crossings
- [x] Multiple unlocks handled in one action (catalog-order list returned via `ActionLogResult.newlyUnlockedAchievements`)
- [x] Per-candidate `transaction.get` race check prevents concurrent double-awards

### 6.8 Achievement UI — **Complete**
- [x] Profile section shows badges (up to 3 + "+N more" chip), counter, and tap-through arrow
- [x] AchievementsScreen at `/profile/achievements` shows progress header, Next Up, Unlocked grid, Locked grid
- [x] "Next Up" sorts by progress fraction desc; binary (special) criteria excluded
- [x] Progress bars are accurate (`achievementProgressOf` pure helper, clamped to `[0, target]`)
- [x] All strings localized in EN / JA / ES

### 6.9 Achievement Celebrations — **Complete**
- [x] Celebration appears on unlock (triggered from `handle_action_tap`)
- [x] Confetti animation plays (`_ConfettiLayer` with 40 particles)
- [x] Bonus points shown prominently in gold
- [x] ~~Auto-dismiss~~ replaced with **acknowledge button** ("Awesome!") to avoid rare unlocks scrolling past unread; confetti fades out after its 4s run instead of freezing
- [x] Queue handles multiple sequentially; "+N more queued" indicator
- [x] ~~`markPointsClaimed`~~ -- `pointsClaimed` flag dropped (YAGNI; no consumer)

### 6.10 User Feedback — **Complete**
- [x] Feedback screen accessible from Settings > Support (`/profile/settings/feedback`)
- [x] Category selector works (Bug / Feature / General `ChoiceChip`s)
- [x] Description field validates non-empty (submit disabled until trimmed text is non-empty)
- [x] Submit builds correct mailto URI with category prefix (`[Bug]` / `[Feature]` / `[Feedback]`)
- [x] Device metadata (app version, OS, locale, optional uid) included in body
- [x] Mail client opens on submit via `launchUrl(LaunchMode.externalApplication)`
- [x] Confirmation SnackBar shown after submission; error SnackBar on launch failure
- [x] All strings localized (EN / JA / ES)

### 6.11 UX Polish & Tech Debt
- [ ] SkeletonLoader and ShimmerEffect widgets created
- [ ] Skeletons applied to Profile stats, Action grid, Progress calendar
- [ ] Haptic feedback on log action, achievement unlock, purchase
- [ ] Dark mode walkthrough completed; contrast/surface issues fixed
- [ ] ErrorView widget created and applied to async load failures
- [ ] EmptyState widget created and applied to "no data" screens
- [ ] Tests for new shared widgets pass

---

## Dependencies

### New Package Dependencies

```yaml
dependencies:
  fl_chart: ^0.69.0  # Charts library
```

### Internal Dependencies

- Phase 4 complete (action library, analytics)
- Phase 5 complete (eco-fact, daily challenges, eco-dex provide
  related engagement context)

---

## Localization Strings

### English (sample)

```json
{
  "co2Dashboard": "Your Impact",
  "co2Saved": "CO₂ Saved",
  "today": "Today",
  "thisWeek": "This Week",
  "thisMonth": "This Month",
  "allTime": "All Time",
  "customRange": "Custom Range",
  "comparedToYesterday": "compared to yesterday",
  "comparedToLastWeek": "compared to last week",
  "comparedToLastMonth": "compared to last month",
  "equivalentTo": "That's Equivalent To",
  "treesPlanted": "trees",
  "carKmAvoided": "km not driven",
  "phoneCharges": "phone charges",
  "burgersNotEaten": "burgers",

  "achievements": "Achievements",
  "achievementUnlocked": "Achievement Unlocked!",
  "nextUp": "Next Up",
  "unlocked": "Unlocked",
  "bonusPoints": "+{count} points!",
  "@bonusPoints": { "placeholders": { "count": { "type": "int" } } },
  "achievementsProgress": "{unlocked} of {total} unlocked",
  "@achievementsProgress": {
    "placeholders": {
      "unlocked": { "type": "int" },
      "total": { "type": "int" }
    }
  }
}
```

---

## Notes

- CO₂ equivalency formulas should be documented with sources
- Achievement point values may need balancing after testing
- Consider adding more achievements in future phases
- Charts should match app theme colors
- Celebration screen reuses confetti from mascot evolution

---

*This plan will be updated as implementation progresses.*
