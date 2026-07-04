# Phase 6: CO₂ Dashboard & Impact

**Version:** 1.1
**Created:** January 2026
**Updated:** June 2026
**Status:** Done (6.1-6.4 + 6.10 shipped; 6.11 polish pending)

---

## Table of Contents

1. [Phase Overview](#phase-overview)
2. [Goals & Deliverables](#goals--deliverables)
3. [Feature Breakdown](#feature-breakdown)
4. [CO₂ Dashboard](#co2-dashboard)
5. [User Feedback](#user-feedback)
6. [Data Models](#data-models)
7. [Implementation Order](#implementation-order)
8. [Testing Strategy](#testing-strategy)
9. [Acceptance Criteria](#acceptance-criteria)

---

## Phase Overview

> **Milestone rewards live in the Eco-Dex.** Badges and "collect them all"
> goals are handled by the **Eco-Dex** (see
> [PLAN_PHASE_5.md](./PLAN_PHASE_5.md)), not by Phase 6. An earlier draft of
> this phase specified a separate Achievement system; it was merged into the
> Eco-Dex because the two were near-duplicate milestone systems, and its
> bonus-point reward violated the Phase 5 **No Fake Points** principle (points
> represent real CO2 savings only -- discoveries reward knowledge). The Eco-Dex
> absorbed the missing milestones (first action, 500 actions, 100/365-day
> streaks, all 17 SDGs, 1 tonne CO2; 102 -> 108 entries) and the
> celebration / "Next Up" / profile-preview UX. Phase 6 is therefore code-only
> with no art bottleneck.

Phase 6 adds an impact-visualization dashboard and a user feedback channel:

1. **CO₂ Dashboard** - Visualize environmental impact with charts, trends, and relatable equivalencies
2. **User Feedback** - In-app feedback form so users can report issues and suggest features

These features deepen engagement by making progress tangible and giving users a voice.

### Key Objectives

- Add CO₂ dashboard section to Progress screen
- Display impact across multiple time periods with comparisons
- Show relatable equivalencies ("equals X trees planted")
- Visualize CO2 trends over time with charts
- Provide an in-app feedback channel

---

## Goals & Deliverables

### Primary Deliverables

| Deliverable | Description |
|-------------|-------------|
| CO₂ Dashboard UI | Charts, trends, and totals within Progress screen |
| Time Period Selector | Today, this week, this month, all time, custom range |
| Period Comparisons | "20% more than last month" style insights |
| Impact Equivalencies | Trees, car miles, flights, phone charges |
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
| 6.10 User Feedback | P1 | Low | **Done** |
| 6.11 UX Polish & Tech Debt | P2 | Low | Pending |

> Milestone/collection rewards (formerly proposed here as 6.5-6.9
> "Achievements") are delivered by the Eco-Dex in
> [PLAN_PHASE_5.md](./PLAN_PHASE_5.md).

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
the existing streak_service.dart convention).

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

- [x] Impact segment renders alongside Calendar / Eco-Dex
- [x] All four periods (Today, Week, Month, All Time) compute correct totals against seeded daily summaries
- [x] Comparison badge shows up/down arrow + percent for non-zero previous totals
- [x] Comparison badge hidden for All Time and when previous = 0
- [x] `categoryCo2Grams` increments on every action log (verified by repository test)
- [x] Total displays in kilograms with one decimal (e.g. `0.4 kg`, `2.5 kg`)
- [x] All strings localized in EN/JA/ES
- [x] Unit + widget tests pass

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
| Skeleton/shimmer loading states | Shared `SkeletonLoader` and `ShimmerEffect` widgets, applied across screens currently using `CircularProgressIndicator`. | Replaces ad-hoc spinners on Profile stats, Action grid, Progress calendar, Eco-Dex grid. |
| Haptic feedback | `HapticFeedback.lightImpact()` / `selectionClick()` on key taps (log action, eco-dex discovery, paywall purchase, mascot interaction). | Currently zero usages in `lib/`. |
| Dark mode audit | Walk every screen in dark mode, fix contrast and surface colors. Theme infrastructure already exists in `lib/core/theme/`. | Audit task, not new code. |
| User-friendly error messages | Shared `ErrorView` widget for failed loads (auth, Firestore reads, action logging). Today errors are caught ad-hoc with bare `catch (e)` blocks. | No shared error widget exists. |
| Empty states | Shared `EmptyState` widget for "no actions yet", "no eco-dex entries discovered". | No shared empty-state widget exists. |
| Progression analytics wiring | Wire the four defined-but-uncalled `AnalyticsService` events: `logLevelUp`, `logMascotEvolved`, `logMascotUnlocked`, `logStreakBroken`. Needed before Phase 8 beta to validate level-curve pacing (1.05, ~4-5 months to max) and observe streak churn with real users. | Detection points already exist: level-up beside the `logStreakMilestone` call in `actions_providers.dart`; `calculateStreakUpdate` (streak_service.dart) computes `streakWasBroken`; unlock happens in `EggHatchingService` (adjust `pointsSpent` param -- unlocks are hatch-based, not purchases). |

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
| Add haptic feedback on eco-dex discovery | `HapticFeedback.heavyImpact()` | Pending |
| Add haptic feedback on subscription purchase | Confirmation feedback | Pending |
| Dark mode walkthrough | Per-screen contrast and surface check | Pending |
| Fix dark mode issues found | Adjust colors in `app_colors.dart` | Pending |
| Create ErrorView widget | Shared error state with retry | Pending |
| Create EmptyState widget | Shared empty-state with icon + message | Pending |
| Apply ErrorView to async load failures | Replace bare error text/spinners | Pending |
| Apply EmptyState to "no data" screens | Action history, eco-dex | Pending |
| Wire logLevelUp + logMascotEvolved | Call at the level-up/evolution detection points in `actions_providers.dart` / mascot flow | Pending |
| Wire logStreakBroken | Call where `calculateStreakUpdate` reports `streakWasBroken` | Pending |
| Wire logMascotUnlocked | Call from `EggHatchingService` hatch success; rework `pointsSpent` param | Pending |

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

Stage 6.4: User Feedback
├── Create FeedbackScreen with category chips
├── Build mailto URI with device metadata
├── Add route and update About screen
├── Localize strings
└── Write widget tests

Stage 6.5: UX Polish & Tech Debt
├── Build SkeletonLoader and ShimmerEffect widgets
├── Apply skeletons across screens with spinner loads
├── Add haptic feedback on key interactions
├── Walk every screen in dark mode and fix issues
└── Write tests for new shared widgets

Stage 6.6: Polish & Testing
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

### Widget Tests

| Widget | Test File | Key Scenarios |
|--------|-----------|---------------|
| CO2TotalCard | `co2_total_card_test.dart` | Display, comparison badge |
| TimePeriodSelector | `time_period_selector_test.dart` | Selection, callback |
| EquivalencyCard | `equivalency_card_test.dart` | Display formatting |
| CO2TrendChart | `co2_trend_chart_test.dart` | Rendering, empty state |
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

> **Milestone/collection acceptance (formerly 6.5-6.9 "Achievements")** is
> covered by the Eco-Dex acceptance criteria in
> [PLAN_PHASE_5.md](./PLAN_PHASE_5.md).

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
- [ ] Haptic feedback on log action, eco-dex discovery, purchase
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
  "burgersNotEaten": "burgers"
}
```

---

## Notes

- CO₂ equivalency formulas should be documented with sources
- Charts should match app theme colors

---

*This plan will be updated as implementation progresses.*
