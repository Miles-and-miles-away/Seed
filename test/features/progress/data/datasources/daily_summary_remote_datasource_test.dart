import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/progress/data/datasources/daily_summary_remote_datasource.dart';
import 'package:seed_app/features/progress/data/models/daily_summary_model.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late DailySummaryRemoteDataSource dataSource;

  const userId = 'test-user';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = DailySummaryRemoteDataSource(fakeFirestore);
  });

  CollectionReference summariesCollection(String uid) => fakeFirestore
      .collection(AppConstants.collectionUsers)
      .doc(uid)
      .collection(AppConstants.collectionDailySummaries);

  Future<void> seedSummary(
    String uid,
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

  group('DailySummaryRemoteDataSource', () {
    group('watchTodaySummary', () {
      test(
        'emits null when no summary exists',
        () async {
          final stream = dataSource.watchTodaySummary(userId);

          await expectLater(stream, emits(isNull));
        },
      );

      test(
        'emits summary for today',
        () async {
          final now = DateTime.now();
          final todayId =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

          await seedSummary(
            userId,
            todayId,
            goalCount: 3,
            totalPoints: 50,
          );

          final stream = dataSource.watchTodaySummary(userId);

          await expectLater(
            stream,
            emits(
              predicate<DailySummaryModel?>(
                (s) => s != null && s.goalCount == 3 && s.totalPoints == 50,
              ),
            ),
          );
        },
      );
    });

    group('getSummary', () {
      test('returns summary for a given date', () async {
        await seedSummary(
          userId,
          '2024-06-15',
          totalPoints: 75,
        );

        final result = await dataSource.getSummary(
          userId,
          DateTime(2024, 6, 15),
        );

        expect(result, isNotNull);
        expect(result!.totalPoints, 75);
        expect(result.date, '2024-06-15');
      });

      test('returns null for missing date', () async {
        final result = await dataSource.getSummary(
          userId,
          DateTime(2024),
        );

        expect(result, isNull);
      });

      test(
        'formats single-digit months and days correctly',
        () async {
          await seedSummary(userId, '2024-01-05');

          final result = await dataSource.getSummary(
            userId,
            DateTime(2024, 1, 5),
          );

          expect(result, isNotNull);
        },
      );
    });

    group('getSummariesInRange', () {
      test('returns summaries within date range', () async {
        await seedSummary(userId, '2024-06-13');
        await seedSummary(userId, '2024-06-14');
        await seedSummary(userId, '2024-06-15');
        await seedSummary(userId, '2024-06-16');

        final result = await dataSource.getSummariesInRange(
          userId,
          DateTime(2024, 6, 14),
          DateTime(2024, 6, 15),
        );

        expect(result, hasLength(2));
      });

      test(
        'returns empty list for range with no data',
        () async {
          final result = await dataSource.getSummariesInRange(
            userId,
            DateTime(2024),
            DateTime(2024, 1, 31),
          );

          expect(result, isEmpty);
        },
      );
    });

    // Summary increments on action logging are covered by
    // action_log_repository_test (they happen inside the logAction
    // transaction so they cannot diverge from the action log).
  });
}
