import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/core/utils/firestore_converters.dart';

part 'user_achievement_model.freezed.dart';
part 'user_achievement_model.g.dart';

/// Record of a single achievement unlocked by a user. Stored at
/// `users/{userId}/achievements/{achievementId}` with the
/// achievement id as the document id; the field set is intentionally
/// minimal because the definition (name, description, criteria,
/// bonus points) lives in the bundled JSON catalog.
@freezed
abstract class UserAchievementModel with _$UserAchievementModel {
  const factory UserAchievementModel({
    required String id,
    @RequiredTimestampConverter() required DateTime unlockedAt,
  }) = _UserAchievementModel;

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementModelFromJson(json);

  /// Builds a model from a Firestore document. The document id is
  /// the achievement id (matches the catalog entry).
  factory UserAchievementModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserAchievementModel.fromJson({
      'id': doc.id,
      ...data,
    });
  }
}
