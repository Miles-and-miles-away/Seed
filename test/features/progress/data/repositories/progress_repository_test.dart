import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/progress/data/datasources/daily_summary_remote_datasource.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';
import 'package:seed_app/features/progress/data/repositories/progress_repository.dart';

class _MockDataSource extends Mock implements DailySummaryRemoteDataSource {}

void main() {
  late _MockDataSource dataSource;
  late FakeFirebaseFirestore firestore;
  late ProgressRepository repository;

  const uid = 'user-1';

  setUp(() {
    dataSource = _MockDataSource();
    firestore = FakeFirebaseFirestore();
    repository = ProgressRepository(dataSource, firestore);
  });

  group('watchTodaySummary', () {
    test('delegates to data source', () {
      final summary = DailySummaryModel(date: '2026-04-19', goalCount: 2);
      when(() => dataSource.watchTodaySummary(uid))
          .thenAnswer((_) => Stream.value(summary));

      expect(repository.watchTodaySummary(uid), emits(summary));
      verify(() => dataSource.watchTodaySummary(uid)).called(1);
    });
  });

  group('getMonthSummaries', () {
    test('queries from first day to last day of the month', () async {
      when(() => dataSource.getSummariesInRange(uid, any(), any()))
          .thenAnswer((_) async => []);

      await repository.getMonthSummaries(uid, 2026, 2);

      final captured = verify(
        () => dataSource.getSummariesInRange(uid, captureAny(), captureAny()),
      ).captured;
      expect(captured.first, DateTime(2026, 2));
      expect(captured.last, DateTime(2026, 2, 28));
    });

    test('correctly handles month with 31 days', () async {
      when(() => dataSource.getSummariesInRange(uid, any(), any()))
          .thenAnswer((_) async => []);

      await repository.getMonthSummaries(uid, 2026, 1);

      final captured = verify(
        () => dataSource.getSummariesInRange(uid, captureAny(), captureAny()),
      ).captured;
      expect(captured.first, DateTime(2026));
      expect(captured.last, DateTime(2026, 1, 31));
    });

    test('correctly handles leap-year February', () async {
      when(() => dataSource.getSummariesInRange(uid, any(), any()))
          .thenAnswer((_) async => []);

      await repository.getMonthSummaries(uid, 2024, 2);

      final captured = verify(
        () => dataSource.getSummariesInRange(uid, captureAny(), captureAny()),
      ).captured;
      expect(captured.last, DateTime(2024, 2, 29));
    });
  });

  group('getMonthCalendarData', () {
    test('produces one CalendarDayData per day in month', () async {
      when(() => dataSource.getSummariesInRange(uid, any(), any()))
          .thenAnswer((_) async => []);

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
      when(() => dataSource.getSummariesInRange(uid, any(), any())).thenAnswer(
        (_) async => [
          const DailySummaryModel(
            date: '2026-04-10',
            goalCount: 2,
            completedSdgs: [3, 11],
          ),
        ],
      );

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
      when(() => dataSource.getSummariesInRange(uid, any(), any()))
          .thenAnswer((_) async => []);

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
      when(() => dataSource.getSummariesInRange(uid, any(), any())).thenAnswer(
        (_) async => [
          const DailySummaryModel(date: '2026-01-05', goalCount: 5),
        ],
      );

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

  group('recordAction', () {
    test('forwards all fields to the data source', () async {
      when(
        () => dataSource.incrementDailySummary(
          userId: uid,
          points: 20,
          co2Grams: 500,
          sdgNumbers: const [3, 11],
          category: 'transport',
        ),
      ).thenAnswer((_) async {});

      await repository.recordAction(
        userId: uid,
        points: 20,
        co2Grams: 500,
        sdgNumbers: const [3, 11],
        category: 'transport',
      );

      verify(
        () => dataSource.incrementDailySummary(
          userId: uid,
          points: 20,
          co2Grams: 500,
          sdgNumbers: const [3, 11],
          category: 'transport',
        ),
      ).called(1);
    });
  });
}
