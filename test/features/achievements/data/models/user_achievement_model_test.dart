import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';

void main() {
  group('UserAchievementModel.fromFirestore', () {
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
    });

    Future<DocumentSnapshot<Map<String, dynamic>>> writeDoc(
      String id,
      Map<String, dynamic> data,
    ) async {
      final ref = firestore
          .collection(AppConstants.collectionUsers)
          .doc('u1')
          .collection(AppConstants.collectionAchievements)
          .doc(id);
      await ref.set(data);
      return ref.get();
    }

    test('builds model from a well-formed doc', () async {
      final unlockedAt = DateTime.utc(2026, 3, 15);
      final doc = await writeDoc('first_action', {
        AppConstants.fieldUnlockedAt: Timestamp.fromDate(unlockedAt),
        AppConstants.fieldPointsClaimed: true,
      });

      final model = UserAchievementModel.fromFirestore(doc);
      expect(model.id, 'first_action');
      expect(model.unlockedAt.toUtc(), unlockedAt);
      expect(model.pointsClaimed, isTrue);
    });

    test('defaults pointsClaimed to false when the field is absent', () async {
      final doc = await writeDoc('streak_7', {
        AppConstants.fieldUnlockedAt: Timestamp.fromDate(DateTime.utc(2026, 4)),
      });

      final model = UserAchievementModel.fromFirestore(doc);
      expect(model.pointsClaimed, isFalse);
    });

    test('throws when unlockedAt is missing', () async {
      final doc = await writeDoc('streak_30', <String, dynamic>{
        AppConstants.fieldPointsClaimed: false,
      });

      expect(
        () => UserAchievementModel.fromFirestore(doc),
        throwsA(anything),
        reason: 'unlockedAt is required; surfacing the failure is preferable '
            'to producing a model with a sentinel timestamp',
      );
    });
  });
}
