import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/domain/entities/calendar_day_data.dart';

/// Repository for progress-related operations, backed by the per-user
/// dailySummaries subcollection in Firestore.
///
/// Summary increments on action logging happen inside
/// ActionLogRepository.logAction's transaction so they can never
/// diverge from the action log; this repository only reads summaries.
class ProgressRepository {
  ProgressRepository(this._firestore, {this.clock = DateTime.now});

  final FirebaseFirestore _firestore;
  final DateTime Function() clock;

  CollectionReference<Map<String, dynamic>> _summariesCollection(
    String userId,
  ) => _firestore
      .collection(AppConstants.collectionUsers)
      .doc(userId)
      .collection(AppConstants.collectionDailySummaries);

  /// Stream today's summary.
  Stream<DailySummaryModel?> watchTodaySummary(String userId) {
    final todayId = formatDateKey(clock());
    return _summariesCollection(userId).doc(todayId).snapshots().map((doc) {
      final data = doc.data();
      return data == null ? null : DailySummaryModel.fromJson(data);
    });
  }

  /// Get summaries for a date range, inclusive on both ends.
  Future<List<DailySummaryModel>> _getSummariesInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final snapshot = await _summariesCollection(userId)
        .where(
          AppConstants.fieldDate,
          isGreaterThanOrEqualTo: formatDateKey(startDate),
        )
        .where(
          AppConstants.fieldDate,
          isLessThanOrEqualTo: formatDateKey(endDate),
        )
        .get();

    return snapshot.docs
        .map((doc) => DailySummaryModel.fromJson(doc.data()))
        .toList();
  }

  /// Get summaries for a month (for calendar view).
  Future<List<DailySummaryModel>> getMonthSummaries(
    String userId,
    int year,
    int month,
  ) {
    final startOfMonth = DateTime(year, month);
    final endOfMonth = DateTime(year, month + 1, 0);
    return _getSummariesInRange(userId, startOfMonth, endOfMonth);
  }

  /// Get summaries for a half-open date range `[start, end)`.
  ///
  /// The underlying query is inclusive on both ends, so we translate
  /// `end` -> `end - 1 day` before querying. Returns an empty list
  /// when the range is zero-width or inverted.
  Future<List<DailySummaryModel>> getSummariesForDateRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    if (!end.isAfter(start)) return const [];
    final inclusiveEnd = previousCalendarDay(end);
    return _getSummariesInRange(userId, start, inclusiveEnd);
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

    final today = clock();
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final calendarData = <CalendarDayData>[];

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final summary = summaryMap[formatDateKey(date)];

      final isToday = isSameCalendarDay(date, today);
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
        .update({AppConstants.fieldDailyGoalTarget: target});
  }
}
