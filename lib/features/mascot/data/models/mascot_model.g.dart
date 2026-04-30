// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mascot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MascotModel _$MascotModelFromJson(Map<String, dynamic> json) => _MascotModel(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      name: json['name'] as String? ?? '',
      mascotPoints: (json['mascotPoints'] as num?)?.toInt() ?? 0,
      mascotLevel: (json['mascotLevel'] as num?)?.toInt() ?? 1,
      isFullyEvolved: json['isFullyEvolved'] as bool? ?? false,
      equippedItems: (json['equippedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp?),
      lastSeenStage: (json['lastSeenStage'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MascotModelToJson(_MascotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'speciesId': instance.speciesId,
      'name': instance.name,
      'mascotPoints': instance.mascotPoints,
      'mascotLevel': instance.mascotLevel,
      'isFullyEvolved': instance.isFullyEvolved,
      'equippedItems': instance.equippedItems,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'lastSeenStage': instance.lastSeenStage,
    };
