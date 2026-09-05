import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

part 'progress_providers.g.dart';

@riverpod
ProgressRepository progressRepository(Ref ref) {
  return ProgressRepository(
    ref.watch(firestoreProvider),
    clock: ref.watch(clockProvider),
  );
}

/// Loads and caches impact equivalency metadata (conversion factors
/// and source URLs) from the bundled JSON asset. Cached for the
/// lifetime of the app -- factors are static scientific constants.
@Riverpod(keepAlive: true)
Future<List<EquivalencyMetadata>> impactEquivalenciesData(Ref ref) =>
    loadImpactEquivalencies();

/// Stream of today's summary for the Rainbow Sun visualization.
///
/// Keyed on the user id so the Firestore listener survives user-doc
/// writes; dayChangeProvider invalidates it at midnight.
@riverpod
Stream<DailySummaryModel?> todaySummary(Ref ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return Stream.value(null);

  final repository = ref.watch(progressRepositoryProvider);
  return repository.watchTodaySummary(userId);
}

/// User's daily goal target from their profile.
@riverpod
int? dailyGoalTarget(Ref ref) {
  return ref.watch(
    currentUserProvider.select((user) => user.value?.dailyGoalTarget),
  );
}

/// Whether the user needs to set up their daily goal target.
@riverpod
bool needsDailyTargetSetup(Ref ref) {
  final hasUser = ref.watch(
    currentUserProvider.select((user) => user.value != null),
  );
  if (!hasUser) return false;
  return ref.watch(dailyGoalTargetProvider) == null;
}

/// Currently selected month for the calendar view.
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    final now = ref.watch(clockProvider)();
    return DateTime(now.year, now.month);
  }

  void goToPreviousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void goToNextMonth() {
    final now = ref.read(clockProvider)();
    final nextMonth = DateTime(state.year, state.month + 1);
    // Don't allow navigating to future months
    if (nextMonth.year < now.year ||
        (nextMonth.year == now.year && nextMonth.month <= now.month)) {
      state = nextMonth;
    }
  }

  bool get canGoToNextMonth {
    final now = ref.read(clockProvider)();
    return state.year < now.year ||
        (state.year == now.year && state.month < now.month);
  }
}

/// Calendar data for the selected month.
///
/// Keyed on the user id; refreshed explicitly after logging an action
/// and at day change instead of on every user-doc write.
@riverpod
Future<List<CalendarDayData>> monthCalendarData(Ref ref) async {
  final userId = ref.watch(userIdProvider);
  if (userId == null) return [];

  final selectedMonth = ref.watch(selectedMonthProvider);
  final goalTarget = ref.watch(dailyGoalTargetProvider) ?? 3;

  final repository = ref.watch(progressRepositoryProvider);
  return repository.getMonthCalendarData(
    userId: userId,
    year: selectedMonth.year,
    month: selectedMonth.month,
    goalTarget: goalTarget,
  );
}

/// Notifier to save the daily goal target.
@riverpod
class DailyTargetNotifier extends _$DailyTargetNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> saveTarget(int target) async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception('Not logged in');

      final repository = ref.read(progressRepositoryProvider);
      await repository.saveDailyGoalTarget(user.uid, target);
    });

    // Only update state if provider is still mounted
    if (ref.mounted) {
      state = result;
    }
  }
}
