import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late ProgressRepository repository;

  const uid = 'user-1';

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = ProgressRepository(firestore);
  });

  CollectionReference<Map<String, dynamic>> summariesCollection(String u) =>
      firestore
          .collection(AppConstants.collectionUsers)
          .doc(u)
          .collection(AppConstants.collectionDailySummaries);

  Future<void> seedSummary(
    String dateId, {
    int goalCount = 1,
    List<int> completedSdgs = const [1],
    int totalPoints = 10,
    int totalCo2Grams = 100,
  }) async {
    await summariesCollection(uid).doc(dateId).set({
      'date': dateId,
      'goalCount': goalCount,
      'completedSdgs': completedSdgs,
      'totalPoints': totalPoints,
      'totalCo2Grams': totalCo2Grams,
    });
  }

  group('watchTodaySummary', () {
    test('emits null when no summary exists', () async {
      final stream = repository.watchTodaySummary(uid);

      await expectLater(stream, emits(isNull));
    });

    test('emits summary for today', () async {
      final now = DateTime.now();
      final todayId =
          '${now.year}'
          '-${now.month.toString().padLeft(2, '0')}'
          '-${now.day.toString().padLeft(2, '0')}';
      await seedSummary(todayId, goalCount: 3, totalPoints: 50);

      final stream = repository.watchTodaySummary(uid);

      await expectLater(
        stream,
        emits(
          predicate<DailySummaryModel?>(
            (s) => s != null && s.goalCount == 3 && s.totalPoints == 50,
          ),
        ),
      );
    });
  });

  group('getMonthSummaries', () {
    test('includes first and last day of the month only', () async {
      await seedSummary('2026-01-31');
      await seedSummary('2026-02-01');
      await seedSummary('2026-02-28');
      await seedSummary('2026-03-01');

      final result = await repository.getMonthSummaries(uid, 2026, 2);

      expect(result.map((s) => s.date), ['2026-02-01', '2026-02-28']);
    });

    test('includes leap-year February 29', () async {
      await seedSummary('2024-02-29');
      await seedSummary('2024-03-01');

      final result = await repository.getMonthSummaries(uid, 2024, 2);

      expect(result.map((s) => s.date), ['2024-02-29']);
    });

    test('returns empty list for a month with no data', () async {
      final result = await repository.getMonthSummaries(uid, 2026, 6);

      expect(result, isEmpty);
    });
  });

  group('getSummariesForDateRange', () {
    test('is inclusive of start and exclusive of end', () async {
      await seedSummary('2024-06-13');
      await seedSummary('2024-06-14');
      await seedSummary('2024-06-15');
      await seedSummary('2024-06-16');

      final result = await repository.getSummariesForDateRange(
        uid,
        DateTime(2024, 6, 14),
        DateTime(2024, 6, 16),
      );

      expect(result.map((s) => s.date), ['2024-06-14', '2024-06-15']);
    });

    test('returns empty list for zero-width or inverted range', () async {
      await seedSummary('2024-06-14');

      final zeroWidth = await repository.getSummariesForDateRange(
        uid,
        DateTime(2024, 6, 14),
        DateTime(2024, 6, 14),
      );
      final inverted = await repository.getSummariesForDateRange(
        uid,
        DateTime(2024, 6, 15),
        DateTime(2024, 6, 14),
      );

      expect(zeroWidth, isEmpty);
      expect(inverted, isEmpty);
    });
  });

  group('getMonthCalendarData', () {
    test('produces one CalendarDayData per day in month', () async {
      final data = await repository.getMonthCalendarData(
        userId: uid,
        year: 2026,
        month: 4,
        goalTarget: 3,
      );

      expect(data, hasLength(30));
      expect(data.first.date, DateTime(2026, 4));
      expect(data.last.date, DateTime(2026, 4, 30));
      expect(data.first.goalTarget, 3);
    });

    test('merges summaries by date string', () async {
      await seedSummary('2026-04-10', goalCount: 2, completedSdgs: [3, 11]);

      final data = await repository.getMonthCalendarData(
        userId: uid,
        year: 2026,
        month: 4,
        goalTarget: 3,
      );

      final day10 = data.firstWhere((d) => d.date.day == 10);
      expect(day10.goalCount, 2);
      expect(day10.completedSdgs, [3, 11]);
      final day9 = data.firstWhere((d) => d.date.day == 9);
      expect(day9.goalCount, 0);
      expect(day9.completedSdgs, isEmpty);
    });

    test('flags today and future days', () async {
      final now = DateTime.now();
      final data = await repository.getMonthCalendarData(
        userId: uid,
        year: now.year,
        month: now.month,
        goalTarget: 3,
      );

      final today = data.firstWhere((d) => d.date.day == now.day);
      expect(today.isToday, isTrue);
      expect(today.isFuture, isFalse);

      // Today must not also be flagged as future; at least one element
      // for each category exists in a month including today.
      final futures = data.where((d) => d.isFuture).toList();
      for (final f in futures) {
        expect(f.date.isAfter(now), isTrue);
      }
    });

    test('pads single-digit days/months so ISO lookup matches', () async {
      await seedSummary('2026-01-05', goalCount: 5);

      final data = await repository.getMonthCalendarData(
        userId: uid,
        year: 2026,
        month: 1,
        goalTarget: 3,
      );

      expect(data.firstWhere((d) => d.date.day == 5).goalCount, 5);
    });
  });

  group('saveDailyGoalTarget', () {
    test('updates the user document field', () async {
      await firestore.collection(AppConstants.collectionUsers).doc(uid).set({
        'uid': uid,
      });

      await repository.saveDailyGoalTarget(uid, 5);

      final doc = await firestore
          .collection(AppConstants.collectionUsers)
          .doc(uid)
          .get();
      expect(doc.data()![AppConstants.fieldDailyGoalTarget], 5);
    });
  });

  // Summary increments on action logging are covered by
  // action_log_repository_test (they happen inside the logAction
  // transaction).
}
