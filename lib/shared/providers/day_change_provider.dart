import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_chart_data_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';

part 'day_change_provider.g.dart';

/// Tracks the current date and invalidates day-sensitive providers
/// when the date changes (at midnight or on app resume).
///
/// Must be keepAlive: it is bootstrapped by a single `ref.read` in
/// MainShell's initState with no listeners, so an autoDispose provider
/// would be disposed immediately and the midnight timer would never fire.
@Riverpod(keepAlive: true)
class DayChangeNotifier extends _$DayChangeNotifier {
  Timer? _midnightTimer;
  AppLifecycleListener? _lifecycleListener;

  @override
  String build() {
    _scheduleMidnightRefresh();
    _listenToAppResume();
    ref.onDispose(_cleanup);
    return formatDateKey(DateTime.now());
  }

  void _scheduleMidnightRefresh() {
    _midnightTimer?.cancel();
    final now = DateTime.now();
    final midnight = DateTime(
      now.year,
      now.month,
      now.day + 1,
    );
    // 1s buffer to ensure we're past midnight
    final duration = midnight.difference(now) + const Duration(seconds: 1);
    _midnightTimer = Timer(duration, _onDayChanged);
  }

  void _listenToAppResume() {
    _lifecycleListener = AppLifecycleListener(
      onResume: checkDayChanged,
    );
  }

  /// Checks if the day has changed and invalidates providers
  /// if so. Public for testing.
  void checkDayChanged() {
    final currentKey = formatDateKey(DateTime.now());
    if (state != currentKey) {
      _onDayChanged();
    }
  }

  void _onDayChanged() {
    // Invalidate all day-sensitive providers
    ref
      ..invalidate(todayChallengeProvider)
      ..invalidate(isTodayChallengeCompletedProvider)
      ..invalidate(challengeStreakProvider)
      ..invalidate(todayEcoFactProvider)
      ..invalidate(isTodayFactViewedProvider)
      ..invalidate(isEcoFactLockedProvider)
      ..invalidate(hasUnreadFactProvider)
      ..invalidate(shouldShowChallengeDialogProvider)
      ..invalidate(challengeDialogShownProvider)
      ..invalidate(todayActionsProvider)
      ..invalidate(todaySummaryProvider)
      ..invalidate(monthCalendarDataProvider)
      ..invalidate(co2StatsProvider)
      ..invalidate(co2TrendDataProvider)
      ..invalidate(co2CategoryDataProvider);

    // Update state and reschedule
    state = formatDateKey(DateTime.now());
    _scheduleMidnightRefresh();
  }

  void _cleanup() {
    _midnightTimer?.cancel();
    _lifecycleListener?.dispose();
  }
}
