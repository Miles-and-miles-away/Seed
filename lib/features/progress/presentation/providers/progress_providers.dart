import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/daily_summary_model.dart';
import '../../data/repositories/progress_repository.dart';
import '../../domain/entities/calendar_day_data.dart';

part 'progress_providers.g.dart';

/// Stream of today's summary for the Rainbow Sun visualization.
@riverpod
Stream<DailySummaryModel?> todaySummary(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value(null);

  final repository = ref.watch(progressRepositoryProvider);
  return repository.watchTodaySummary(user.uid);
}

/// User's daily goal target from their profile.
@riverpod
int? dailyGoalTarget(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.dailyGoalTarget;
}

/// Whether the user needs to set up their daily goal target.
@riverpod
bool needsDailyTargetSetup(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  return user.dailyGoalTarget == null;
}

/// Currently selected month for the calendar view.
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void goToPreviousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void goToNextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(state.year, state.month + 1);
    // Don't allow navigating to future months
    if (nextMonth.year < now.year ||
        (nextMonth.year == now.year && nextMonth.month <= now.month)) {
      state = nextMonth;
    }
  }

  bool get canGoToNextMonth {
    final now = DateTime.now();
    return state.year < now.year ||
        (state.year == now.year && state.month < now.month);
  }
}

/// Calendar data for the selected month.
@riverpod
Future<List<CalendarDayData>> monthCalendarData(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];

  final selectedMonth = ref.watch(selectedMonthProvider);
  final goalTarget = user.dailyGoalTarget ?? 3;

  final repository = ref.watch(progressRepositoryProvider);
  return repository.getMonthCalendarData(
    userId: user.uid,
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
