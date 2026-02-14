# Phase 7: CO₂ Dashboard & Achievement System

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
6. [Data Models](#data-models)
7. [Implementation Order](#implementation-order)
8. [Testing Strategy](#testing-strategy)
9. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

Phase 7 adds two major engagement features:

1. **CO₂ Dashboard** - Visualize environmental impact with charts, trends, and relatable equivalencies
2. **Achievement System** - Gamify the experience with unlockable badges and bonus point rewards

Both features deepen user engagement by making progress tangible and rewarding consistent behavior.

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

---

## Feature Breakdown

### Summary Table

| Feature | Priority | Complexity | Status |
|---------|----------|------------|--------|
| 7.1 CO₂ Dashboard UI | P0 | Medium | Pending |
| 7.2 Time Period Analytics | P0 | Medium | Pending |
| 7.3 Impact Equivalencies | P1 | Low | Pending |
| 7.4 CO₂ Charts | P1 | Medium | Pending |
| 7.5 Achievement Data Layer | P0 | Medium | Pending |
| 7.6 Achievement Definitions | P0 | Low | Pending |
| 7.7 Achievement Tracking | P0 | Medium | Pending |
| 7.8 Achievement UI | P0 | Medium | Pending |
| 7.9 Achievement Celebrations | P1 | Low | Pending |

---

## CO₂ Dashboard

### 7.1 Dashboard UI

**Priority:** P0 | **Complexity:** Medium

Add a CO₂ impact section to the existing Progress screen.

#### Location

The CO₂ dashboard will be a new section within `ProgressScreen`, positioned after the calendar view.

#### UI Design

```
┌─────────────────────────────────────────┐
│  ←         Progress                     │
├─────────────────────────────────────────┤
│                                         │
│  ─────── Calendar View ───────          │
│  [Existing calendar widget]             │
│                                         │
│  ─────── Your Impact ───────            │
│                                         │
│  [Today ▼] [This Week] [Month] [All]    │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │                                 │   │
│  │      🌍  2.5 kg                │   │
│  │      CO₂ Saved Today            │   │
│  │                                 │   │
│  │   ▲ 15% more than yesterday    │   │
│  │                                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── That's Equivalent To ───────   │
│                                         │
│  ┌────────┐ ┌────────┐ ┌────────┐      │
│  │  🌳    │ │  🚗    │ │  📱    │      │
│  │  0.1   │ │  10    │ │  312   │      │
│  │ trees  │ │  km    │ │charges │      │
│  └────────┘ └────────┘ └────────┘      │
│                                         │
│  ─────── Trend ───────                  │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  📈 [Line chart of CO₂/day]    │   │
│  │     Last 7 days                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────── By Category ───────            │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [Pie chart by category]        │   │
│  │  Transport: 45%                 │   │
│  │  Food: 30%                      │   │
│  │  Energy: 15%                    │   │
│  │  Other: 10%                     │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create CO2DashboardSection widget | Main container for dashboard | Pending |
| Add time period selector | Tab bar or segmented control | Pending |
| Create CO2TotalCard widget | Big number display with comparison | Pending |
| Integrate into ProgressScreen | Add below calendar view | Pending |
| Create CO₂ stats provider | Calculate totals by time period | Pending |
| Add period comparison logic | Calculate % change vs previous | Pending |
| Localize all strings | EN/ES/JA | Pending |
| Write widget tests | Test display and interactions | Pending |

#### Files to Create

```
lib/features/progress/presentation/widgets/
├── co2_dashboard_section.dart
├── co2_total_card.dart
├── time_period_selector.dart
└── period_comparison_badge.dart

lib/features/progress/presentation/providers/
└── co2_stats_provider.dart
```

---

### 7.2 Time Period Analytics

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

### 7.3 Impact Equivalencies

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

### 7.4 CO₂ Charts

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
| Add fl_chart dependency | pubspec.yaml | Pending |
| Create CO2TrendChart widget | Line/area chart | Pending |
| Create CO2CategoryChart widget | Pie/donut chart | Pending |
| Create chart data providers | Aggregate data for charts | Pending |
| Add chart range selector | 7/30/90 days | Pending |
| Style charts to match theme | Colors, fonts | Pending |
| Handle empty data state | "No data yet" message | Pending |
| Localize chart labels | EN/ES/JA | Pending |
| Write widget tests | Test chart rendering | Pending |

#### Files to Create

```
lib/features/progress/presentation/widgets/
├── co2_trend_chart.dart
├── co2_category_chart.dart
└── chart_range_selector.dart

lib/features/progress/presentation/providers/
└── co2_chart_data_provider.dart
```

---

## Achievement System

### 7.5 Achievement Data Layer

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
    required bool pointsClaimed,
  }) = _UserAchievement;
}
```

#### Firestore Structure

```
users/{userId}/achievements/
├── {achievementId}/
│   ├── unlockedAt: timestamp
│   └── pointsClaimed: boolean

# Achievement definitions stored locally (not in Firestore)
# This keeps them fast and avoids unnecessary reads
```

#### Tasks

| Task | Description | Status |
|------|-------------|--------|
| Create AchievementDefinition model | Freezed model | Pending |
| Create AchievementCriteria model | Union type for criteria | Pending |
| Create UserAchievement model | User's unlocked achievements | Pending |
| Create AchievementRepository | CRUD for user achievements | Pending |
| Create achievement definitions file | All ~15-20 achievements | Pending |
| Run code generation | Freezed + JSON serializable | Pending |
| Write unit tests | Model serialization | Pending |

#### Files to Create

```
lib/features/achievements/
├── achievements.dart                    # Barrel file
├── data/
│   ├── models/
│   │   ├── achievement_definition.dart
│   │   ├── achievement_criteria.dart
│   │   └── user_achievement.dart
│   ├── datasources/
│   │   └── achievements_remote_datasource.dart
│   ├── repositories/
│   │   └── achievements_repository.dart
│   └── achievement_definitions.dart     # Static definitions
└── ...
```

---

### 7.6 Achievement Definitions

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
| Define all achievements in code | Static list of definitions | Pending |
| Localize achievement names | EN/ES/JA | Pending |
| Localize achievement descriptions | EN/ES/JA | Pending |
| Select icons for each achievement | Material icons or custom | Pending |
| Balance point rewards | Ensure fair progression | Pending |

---

### 7.7 Achievement Tracking

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
| Create AchievementChecker service | Check criteria logic | Pending |
| Integrate with action logging | Check after each action | Pending |
| Integrate with streak service | Check after streak update | Pending |
| Integrate with level up | Check after level change | Pending |
| Create achievement unlock logic | Save to Firestore | Pending |
| Create point award logic | Add bonus points | Pending |
| Return newly unlocked list | For celebration screen | Pending |
| Write unit tests | Test all criteria types | Pending |

#### Files to Create

```
lib/features/achievements/domain/services/
└── achievement_checker.dart

lib/features/achievements/presentation/providers/
└── achievement_providers.dart
```

---

### 7.8 Achievement UI

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
| Create AchievementBadge widget | Single badge display | Pending |
| Create AchievementCard widget | Detailed card with progress | Pending |
| Create ProfileAchievementsSection | Horizontal scroll of badges | Pending |
| Create AchievementsScreen | Full achievements list | Pending |
| Create "Next Up" section | Show closest to completion | Pending |
| Calculate progress for each | e.g., 78/100 actions | Pending |
| Add route to achievements screen | From profile section | Pending |
| Localize all strings | EN/ES/JA | Pending |
| Write widget tests | Test display states | Pending |

#### Files to Create

```
lib/features/achievements/presentation/
├── screens/
│   └── achievements_screen.dart
└── widgets/
    ├── achievement_badge.dart
    ├── achievement_card.dart
    ├── achievement_progress_bar.dart
    ├── next_up_section.dart
    └── profile_achievements_section.dart
```

---

### 7.9 Achievement Celebrations

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
| Create AchievementCelebrationScreen | Full-screen overlay | Pending |
| Add confetti animation | Reuse existing confetti widget | Pending |
| Add points animation | Animated counter or pop | Pending |
| Implement auto-dismiss | Timer-based dismissal | Pending |
| Queue multiple achievements | Show one at a time | Pending |
| Integrate with achievement checker | Trigger on unlock | Pending |
| Write widget tests | Test display and dismiss | Pending |

#### Files to Create

```
lib/features/achievements/presentation/
└── screens/
    └── achievement_celebration_screen.dart
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
Stage 7.1: CO₂ Dashboard Foundation
├── Create CO2Stats model and provider
├── Add time period selector widget
├── Create CO2TotalCard widget
├── Integrate into ProgressScreen
└── Add period comparison logic

Stage 7.2: Impact Equivalencies
├── Create equivalency calculator
├── Create EquivalencyCard widgets
├── Add equivalency row to dashboard
└── Write unit tests for calculations

Stage 7.3: CO₂ Charts
├── Add fl_chart dependency
├── Create CO2TrendChart widget
├── Create CO2CategoryChart widget
├── Add chart data providers
└── Write widget tests

Stage 7.4: Achievement Data Layer
├── Create achievement models (Freezed)
├── Create achievement definitions
├── Create AchievementsRepository
├── Run code generation
└── Write unit tests

Stage 7.5: Achievement Tracking
├── Create AchievementChecker service
├── Integrate with action logging
├── Integrate with streak service
├── Integrate with level up
└── Write unit tests

Stage 7.6: Achievement UI
├── Create achievement widgets
├── Create AchievementsScreen
├── Add profile achievements section
├── Add route and navigation
└── Write widget tests

Stage 7.7: Achievement Celebrations
├── Create celebration screen
├── Add confetti animation
├── Implement auto-dismiss
├── Queue multiple achievements
└── Write tests

Stage 7.8: Polish & Testing
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

---

## Acceptance Criteria

### 7.1 CO₂ Dashboard UI
- [ ] Dashboard section visible in Progress screen
- [ ] Shows total CO₂ saved prominently
- [ ] Time period selector works correctly
- [ ] Comparison badge shows % change

### 7.2 Time Period Analytics
- [ ] Today shows current day total
- [ ] This week shows Mon-Sun total
- [ ] This month shows calendar month total
- [ ] All time shows lifetime total
- [ ] Custom range picker works
- [ ] Comparisons calculate correctly

### 7.3 Impact Equivalencies
- [ ] Shows 3-4 relevant equivalencies
- [ ] Calculations are accurate
- [ ] Icons and labels display correctly
- [ ] Localized in EN/ES/JA

### 7.4 CO₂ Charts
- [ ] Trend chart shows daily data
- [ ] Category chart shows distribution
- [ ] Charts handle empty data gracefully
- [ ] Touch interactions work

### 7.5 Achievement Data Layer
- [ ] All models serialize correctly
- [ ] Repository CRUD works
- [ ] 19 achievements defined
- [ ] All localized

### 7.6 Achievement Definitions
- [ ] All categories represented
- [ ] Point values balanced
- [ ] Criteria types working

### 7.7 Achievement Tracking
- [ ] Checks trigger at correct times
- [ ] Unlocks save to Firestore
- [ ] Points awarded correctly
- [ ] Multiple unlocks handled

### 7.8 Achievement UI
- [ ] Profile section shows badges
- [ ] Achievements screen shows all
- [ ] "Next up" shows closest to completion
- [ ] Progress bars accurate

### 7.9 Achievement Celebrations
- [ ] Celebration appears on unlock
- [ ] Confetti animation plays
- [ ] Points shown
- [ ] Auto-dismiss works
- [ ] Queue handles multiple

---

## Dependencies

### New Package Dependencies

```yaml
dependencies:
  fl_chart: ^0.69.0  # Charts library
```

### Internal Dependencies

- Phase 4 complete (action library, analytics)
- Phase 6 complete (premium features, if achievements are premium)

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
