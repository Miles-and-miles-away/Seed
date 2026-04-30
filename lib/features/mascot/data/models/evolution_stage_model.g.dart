// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_stage_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EvolutionStageModel _$EvolutionStageModelFromJson(Map<String, dynamic> json) =>
    _EvolutionStageModel(
      level: (json['level'] as num).toInt(),
      assetPath: json['assetPath'] as String,
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String,
      nameEs: json['nameEs'] as String? ?? '',
    );

Map<String, dynamic> _$EvolutionStageModelToJson(
        _EvolutionStageModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'assetPath': instance.assetPath,
      'nameEn': instance.nameEn,
      'nameJa': instance.nameJa,
      'nameEs': instance.nameEs,
    };
