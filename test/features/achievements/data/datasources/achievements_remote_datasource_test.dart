import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/achievements/data/datasources/achievements_remote_datasource.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late AchievementsRemoteDataSourceImpl dataSource;

  const userId = 'test-user';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = AchievementsRemoteDataSourceImpl(firestore: fakeFirestore);
  });

  CollectionReference<Map<String, dynamic>> achievementsCollection(String uid) {
    return fakeFirestore
        .collection(AppConstants.collectionUsers)
        .doc(uid)
        .collection(AppConstants.collectionAchievements);
  }

  Future<void> seed(
    String uid,
    String id, {
    DateTime? unlockedAt,
    bool pointsClaimed = false,
  }) async {
    await achievementsCollection(uid).doc(id).set({
      AppConstants.fieldUnlockedAt: Timestamp.fromDate(
        unlockedAt ?? DateTime(2026, 5),
      ),
      AppConstants.fieldPointsClaimed: pointsClaimed,
    });
  }

  group('unlockAchievement', () {
    test('creates a doc with serverTimestamp and pointsClaimed=false',
        () async {
      await dataSource.unlockAchievement(userId, 'first_action');

      final doc =
          await achievementsCollection(userId).doc('first_action').get();
      expect(doc.exists, isTrue);
      final data = doc.data()!;
      expect(data[AppConstants.fieldPointsClaimed], isFalse);
      expect(data[AppConstants.fieldUnlockedAt], isNotNull);
    });

    test('is a no-op when the achievement is already unlocked', () async {
      final originalDate = DateTime(2026);
      await seed(userId, 'streak_7', unlockedAt: originalDate);

      await dataSource.unlockAchievement(userId, 'streak_7');

      final doc = await achievementsCollection(userId).doc('streak_7').get();
      final ts = doc.data()![AppConstants.fieldUnlockedAt] as Timestamp;
      expect(
        ts.toDate(),
        originalDate,
        reason: 'unlockAchievement must not overwrite an existing record',
      );
    });

    test('concurrent calls for the same id produce a single write', () async {
      await Future.wait([
        dataSource.unlockAchievement(userId, 'first_action'),
        dataSource.unlockAchievement(userId, 'first_action'),
        dataSource.unlockAchievement(userId, 'first_action'),
      ]);

      final snap = await achievementsCollection(userId).get();
      expect(snap.docs.map((d) => d.id), ['first_action']);
    });
  });

  group('getUserAchievements', () {
    test('returns empty when the user has nothing unlocked', () async {
      final result = await dataSource.getUserAchievements(userId);
      expect(result, isEmpty);
    });

    test('returns all unlocked records keyed by doc id', () async {
      await seed(userId, 'first_action');
      await seed(userId, 'streak_7', pointsClaimed: true);

      final result = await dataSource.getUserAchievements(userId);
      expect(result.map((r) => r.id).toSet(), {'first_action', 'streak_7'});

      final claimed = result.firstWhere((r) => r.id == 'streak_7');
      expect(claimed.pointsClaimed, isTrue);
    });
  });

  group('watchUserAchievements', () {
    test('emits new unlocks as they are written', () async {
      final lengths = dataSource
          .watchUserAchievements(userId)
          .map((records) => records.length);

      final expectation = expectLater(
        lengths,
        emitsInOrder(<dynamic>[0, 1, 2]),
      );

      await dataSource.unlockAchievement(userId, 'first_action');
      await dataSource.unlockAchievement(userId, 'streak_7');

      await expectation;
    });
  });

  group('markPointsClaimed', () {
    test('flips the pointsClaimed flag', () async {
      await seed(userId, 'streak_7');

      await dataSource.markPointsClaimed(userId, 'streak_7');

      final doc = await achievementsCollection(userId).doc('streak_7').get();
      expect(doc.data()![AppConstants.fieldPointsClaimed], isTrue);
    });
  });
}
