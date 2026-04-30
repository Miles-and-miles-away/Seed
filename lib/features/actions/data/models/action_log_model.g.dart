// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionLogModel _$ActionLogModelFromJson(Map<String, dynamic> json) =>
    _ActionLogModel(
      id: json['id'] as String,
      actionId: json['actionId'] as String,
      actionName: json['actionName'] as String,
      category: json['category'] as String,
      points: (json['points'] as num).toInt(),
      loggedAt: const RequiredTimestampConverter()
          .fromJson(json['loggedAt'] as Timestamp),
      co2Grams: (json['co2Grams'] as num?)?.toInt() ?? 0,
      note: json['note'] as String?,
      relatedSdgs: (json['relatedSdgs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ActionLogModelToJson(_ActionLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actionId': instance.actionId,
      'actionName': instance.actionName,
      'category': instance.category,
      'points': instance.points,
      'loggedAt': const RequiredTimestampConverter().toJson(instance.loggedAt),
      'co2Grams': instance.co2Grams,
      'note': instance.note,
      'relatedSdgs': instance.relatedSdgs,
    };
