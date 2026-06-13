import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/progress/data/datasources/daily_summary_remote_datasource.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';

/// Repository for progress-related operations.
class ProgressRepository {
  ProgressRepository(this._dataSource, this._firestore);

  final DailySummaryRemoteDataSource _dataSource;
  final FirebaseFirestore _firestore;

  /// Stream today's summary.
  Stream<DailySummaryModel?> watchTodaySummary(String userId) {
    return _dataSource.watchTodaySummary(userId);
  }

  /// Get summaries for a month (for calendar view).
  Future<List<DailySummaryModel>> getMonthSummaries(
    String userId,
    int year,
    int month,
  ) async {
    final startOfMonth = DateTime(year, month);
    final endOfMonth = DateTime(year, month + 1, 0);
    return _dataSource.getSummariesInRange(userId, startOfMonth, endOfMonth);
  }

  /// Get summaries for a half-open date range `[start, end)`.
  ///
  /// The underlying data source query is inclusive on both ends, so we
  /// translate `end` -> `end - 1 day` before querying. Returns an empty
  /// list when the range is zero-width or inverted.
  Future<List<DailySummaryModel>> getSummariesForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    if (!end.isAfter(start)) return const [];
    final inclusiveEnd = end.subtract(const Duration(days: 1));
    return _dataSource.getSummariesInRange(userId, start, inclusiveEnd);
  }

  /// Convert summaries to calendar day data for a specific month.
  Future<List<CalendarDayData>> getMonthCalendarData({
    required String userId,
    required int year,
    required int month,
    required int goalTarget,
  }) async {
    final summaries = await getMonthSummaries(userId, year, month);
    final summaryMap = {for (final s in summaries) s.date: s};

    final today = DateTime.now();
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final calendarData = <CalendarDayData>[];

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final summary = summaryMap[dateString];

      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isFuture = date.isAfter(today);

      calendarData.add(
        CalendarDayData(
          date: date,
          goalCount: summary?.goalCount ?? 0,
          goalTarget: goalTarget,
          completedSdgs: summary?.completedSdgs ?? [],
          isToday: isToday,
          isFuture: isFuture,
        ),
      );
    }

    return calendarData;
  }

  /// Save user's daily goal target to their profile.
  Future<void> saveDailyGoalTarget(String userId, int target) async {
    await _firestore
        .collection(AppConstants.collectionUsers)
        .doc(userId)
        .update({
      AppConstants.fieldDailyGoalTarget: target,
    });
  }
}
