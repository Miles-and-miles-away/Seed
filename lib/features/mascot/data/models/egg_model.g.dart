// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'egg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EggModel _$EggModelFromJson(Map<String, dynamic> json) => _EggModel(
  receivedAt: const RequiredTimestampConverter().fromJson(
    json['receivedAt'] as Timestamp,
  ),
  hatchingStreakDays: (json['hatchingStreakDays'] as num?)?.toInt() ?? 0,
  lastHatchingActivityDate: const TimestampConverter().fromJson(
    json['lastHatchingActivityDate'] as Timestamp?,
  ),
);

Map<String, dynamic> _$EggModelToJson(_EggModel instance) => <String, dynamic>{
  'receivedAt': const RequiredTimestampConverter().toJson(instance.receivedAt),
  'hatchingStreakDays': instance.hatchingStreakDays,
  'lastHatchingActivityDate': const TimestampConverter().toJson(
    instance.lastHatchingActivityDate,
  ),
};
