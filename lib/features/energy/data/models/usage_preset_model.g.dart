// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_preset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UsagePreset _$UsagePresetFromJson(Map<String, dynamic> json) => _UsagePreset(
  id: json['id'] as String,
  nameEn: json['name_en'] as String,
  nameJa: json['name_ja'] as String,
  nameEs: json['name_es'] as String,
  units: (json['units'] as num).toDouble(),
);

Map<String, dynamic> _$UsagePresetToJson(_UsagePreset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_ja': instance.nameJa,
      'name_es': instance.nameEs,
      'units': instance.units,
    };
