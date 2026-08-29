// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_behavior_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnergyBehavior _$EnergyBehaviorFromJson(Map<String, dynamic> json) =>
    _EnergyBehavior(
      id: json['id'] as String,
      comparableGroup: json['comparable_group'] as String,
      carrier: $enumDecode(_$EnergyCarrierEnumMap, json['carrier']),
      unit: $enumDecode(_$EnergyUnitEnumMap, json['unit']),
      kwhPerUnit: (json['kwh_per_unit'] as num).toDouble(),
      nameEn: json['name_en'] as String,
      nameJa: json['name_ja'] as String,
      nameEs: json['name_es'] as String,
      presets:
          (json['presets'] as List<dynamic>?)
              ?.map((e) => UsagePreset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      defaultPresetId: json['default_preset_id'] as String? ?? '',
      calculationNotes: json['calculation_notes'] as String? ?? '',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => EmissionSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      confidence: json['confidence'] as String? ?? 'medium',
    );

Map<String, dynamic> _$EnergyBehaviorToJson(_EnergyBehavior instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comparable_group': instance.comparableGroup,
      'carrier': _$EnergyCarrierEnumMap[instance.carrier]!,
      'unit': _$EnergyUnitEnumMap[instance.unit]!,
      'kwh_per_unit': instance.kwhPerUnit,
      'name_en': instance.nameEn,
      'name_ja': instance.nameJa,
      'name_es': instance.nameEs,
      'presets': instance.presets,
      'default_preset_id': instance.defaultPresetId,
      'calculation_notes': instance.calculationNotes,
      'sources': instance.sources,
      'confidence': instance.confidence,
    };

const _$EnergyCarrierEnumMap = {
  EnergyCarrier.electricity: 'electricity',
  EnergyCarrier.gas: 'gas',
  EnergyCarrier.none: 'none',
};

const _$EnergyUnitEnumMap = {
  EnergyUnit.minute: 'minute',
  EnergyUnit.hour: 'hour',
  EnergyUnit.use: 'use',
  EnergyUnit.day: 'day',
};
