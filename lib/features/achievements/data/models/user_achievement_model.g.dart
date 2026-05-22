// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAchievementModel _$UserAchievementModelFromJson(
        Map<String, dynamic> json) =>
    _UserAchievementModel(
      id: json['id'] as String,
      unlockedAt: const RequiredTimestampConverter()
          .fromJson(json['unlockedAt'] as Timestamp),
    );

Map<String, dynamic> _$UserAchievementModelToJson(
        _UserAchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unlockedAt':
          const RequiredTimestampConverter().toJson(instance.unlockedAt),
    };
