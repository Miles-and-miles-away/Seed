import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/achievements/data/models/user_achievement_model.dart';

/// Firestore CRUD for a user's unlocked achievements.
///
/// Each unlocked achievement is stored at
/// `users/{userId}/achievements/{achievementId}`. Point awarding is
/// handled by the §6.7 checker service in a user-doc transaction;
/// this datasource only manages the achievement subcollection.
abstract class AchievementsRemoteDataSource {
  /// Watches the user's unlocked achievement records.
  Stream<List<UserAchievementModel>> watchUserAchievements(String userId);

  /// One-shot read of the user's unlocked achievement records.
  Future<List<UserAchievementModel>> getUserAchievements(String userId);

  /// Writes an unlock record (`unlockedAt = serverTimestamp`,
  /// `pointsClaimed = false`). Idempotent and concurrency-safe: the
  /// read-then-write runs inside a Firestore transaction so parallel
  /// calls for the same id will not produce duplicate writes.
  Future<void> unlockAchievement(String userId, String achievementId);

  /// Marks an unlocked achievement's points as claimed. Used after
  /// the celebration screen confirms the user has seen the reward.
  Future<void> markPointsClaimed(String userId, String achievementId);

  /// Gets the collection reference for transaction use by §6.7.
  CollectionReference<Map<String, dynamic>> getAchievementsCollection(
    String userId,
  );
}

class AchievementsRemoteDataSourceImpl implements AchievementsRemoteDataSource {
  AchievementsRemoteDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> _userAchievements(String userId) =>
      firestore
          .collection(AppConstants.collectionUsers)
          .doc(userId)
          .collection(AppConstants.collectionAchievements);

  @override
  Stream<List<UserAchievementModel>> watchUserAchievements(String userId) {
    return _userAchievements(userId).snapshots().map(
          (snap) => snap.docs.map(UserAchievementModel.fromFirestore).toList(),
        );
  }

  @override
  Future<List<UserAchievementModel>> getUserAchievements(String userId) async {
    final snap = await _userAchievements(userId).get();
    return snap.docs.map(UserAchievementModel.fromFirestore).toList();
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    final docRef = _userAchievements(userId).doc(achievementId);
    await firestore.runTransaction((txn) async {
      final existing = await txn.get(docRef);
      if (existing.exists) return;
      txn.set(docRef, <String, dynamic>{
        AppConstants.fieldUnlockedAt: FieldValue.serverTimestamp(),
        AppConstants.fieldPointsClaimed: false,
      });
    });
  }

  @override
  Future<void> markPointsClaimed(String userId, String achievementId) async {
    await _userAchievements(userId).doc(achievementId).update(
      <String, dynamic>{AppConstants.fieldPointsClaimed: true},
    );
  }

  @override
  CollectionReference<Map<String, dynamic>> getAchievementsCollection(
    String userId,
  ) =>
      _userAchievements(userId);
}
