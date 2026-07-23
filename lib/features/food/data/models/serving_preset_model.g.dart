// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serving_preset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServingPreset _$ServingPresetFromJson(Map<String, dynamic> json) =>
    _ServingPreset(
      id: json['id'] as String,
      nameEn: json['name_en'] as String,
      nameJa: json['name_ja'] as String,
      nameEs: json['name_es'] as String,
      grams: (json['grams'] as num).toDouble(),
    );

Map<String, dynamic> _$ServingPresetToJson(_ServingPreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_ja': instance.nameJa,
      'name_es': instance.nameEs,
      'grams': instance.grams,
    };
