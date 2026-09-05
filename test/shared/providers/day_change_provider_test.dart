import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/features/progress/domain/entities/co2_chart_data.dart';
import 'package:seed_app/features/progress/domain/entities/co2_stats.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';
import 'package:seed_app/shared/providers/day_change_provider.dart';

import '../../helpers/test_helpers.dart';

/// Counts builds of the dialog-shown notifier like the other overrides.
class _CountingDialogShown extends ChallengeDialogShown {
  _CountingDialogShown(this.onBuild);
  final void Function() onBuild;

  @override
  bool build() {
    onBuild();
    return false;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testUser = AppUserModel(uid: 'test-uid', email: 'test@example.com');
  const period = TimePeriod.today;

  /// Every provider the notifier refreshes, overridden to count builds.
  (ProviderContainer, Map<String, int>) createContainer(
    DateTime Function() clock,
  ) {
    final builds = <String, int>{};
    void built(String name) => builds[name] = (builds[name] ?? 0) + 1;
    final container = ProviderContainer(
      overrides: [
        userOverride(testUser),
        clockProvider.overrideWithValue(clock),
        todayChallengeProvider.overrideWith((_) async {
          built('todayChallenge');
          return null;
        }),
        isTodayChallengeCompletedProvider.overrideWith((_) {
          built('isTodayChallengeCompleted');
          return false;
        }),
        challengeStreakProvider.overrideWith((_) {
          built('challengeStreak');
          return 0;
        }),
        todayEcoFactProvider.overrideWith((_) async {
          built('todayEcoFact');
          return null;
        }),
        isTodayFactViewedProvider.overrideWith((_) {
          built('isTodayFactViewed');
          return false;
        }),
        isEcoFactLockedProvider.overrideWith((_) {
          built('isEcoFactLocked');
          return true;
        }),
        hasUnreadFactProvider.overrideWith((_) {
          built('hasUnreadFact');
          return false;
        }),
        shouldShowChallengeDialogProvider.overrideWith((_) {
          built('shouldShowChallengeDialog');
          return false;
        }),
        challengeDialogShownProvider.overrideWith(
          () => _CountingDialogShown(() => built('challengeDialogShown')),
        ),
        todayActionsProvider.overrideWith((_) {
          built('todayActions');
          return Stream.value(const <ActionLogModel>[]);
        }),
        todaySummaryProvider.overrideWith((_) {
          built('todaySummary');
          return Stream<DailySummaryModel?>.value(null);
        }),
        monthCalendarDataProvider.overrideWith((_) async {
          built('monthCalendarData');
          return const <CalendarDayData>[];
        }),
        co2StatsProvider.overrideWith((_, p) async {
          built('co2Stats');
          return Co2Stats(
            totalGrams: 0,
            previousTotalGrams: 0,
            percentChange: 0,
            period: p,
          );
        }),
        co2TrendDataProvider.overrideWith((_, p) async {
          built('co2TrendData');
          return Co2TrendData(
            points: const [],
            averageGrams: 0,
            windowStart: DateTime(2026, 6),
            windowEnd: DateTime(2026, 6, 8),
          );
        }),
        co2CategoryDataProvider.overrideWith((_, p) async {
          built('co2CategoryData');
          return const Co2CategoryData(slices: [], totalGrams: 0);
        }),
      ],
    );
    addTearDown(container.dispose);
    container
      ..listen(dayChangeProvider, (_, _) {})
      ..listen(todayChallengeProvider, (_, _) {})
      ..listen(isTodayChallengeCompletedProvider, (_, _) {})
      ..listen(challengeStreakProvider, (_, _) {})
      ..listen(todayEcoFactProvider, (_, _) {})
      ..listen(isTodayFactViewedProvider, (_, _) {})
      ..listen(isEcoFactLockedProvider, (_, _) {})
      ..listen(hasUnreadFactProvider, (_, _) {})
      ..listen(shouldShowChallengeDialogProvider, (_, _) {})
      ..listen(challengeDialogShownProvider, (_, _) {})
      ..listen(todayActionsProvider, (_, _) {})
      ..listen(todaySummaryProvider, (_, _) {})
      ..listen(monthCalendarDataProvider, (_, _) {})
      ..listen(co2StatsProvider(period), (_, _) {})
      ..listen(co2TrendDataProvider(period), (_, _) {})
      ..listen(co2CategoryDataProvider(period), (_, _) {});
    return (container, builds);
  }

  group('DayChangeNotifier', () {
    test('build returns the date key of the clock', () {
      final (container, _) = createContainer(() => DateTime(2026, 6, 17, 9));

      expect(container.read(dayChangeProvider), '2026-06-17');
    });

    test('checkDayChanged does nothing on the same day', () async {
      var current = DateTime(2026, 6, 17, 9);
      final (container, builds) = createContainer(() => current);
      expect(builds, hasLength(15));

      current = DateTime(2026, 6, 17, 23, 59);
      container.read(dayChangeProvider.notifier).checkDayChanged();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(dayChangeProvider), '2026-06-17');
      expect(builds.values, everyElement(1));
    });

    test('checkDayChanged refreshes all 15 day-sensitive providers', () async {
      var current = DateTime(2026, 6, 17, 23, 59);
      final (container, builds) = createContainer(() => current);
      expect(builds.values, everyElement(1));

      current = DateTime(2026, 6, 18, 0, 0, 1);
      container.read(dayChangeProvider.notifier).checkDayChanged();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(dayChangeProvider), '2026-06-18');
      expect(builds, hasLength(15));
      expect(builds.values, everyElement(2), reason: '$builds');
    });
  });
}
