// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransportMode _$TransportModeFromJson(Map<String, dynamic> json) =>
    _TransportMode(
      id: json['id'] as String,
      group: json['group'] as String,
      nameEn: json['name_en'] as String,
      nameJa: json['name_ja'] as String,
      nameEs: json['name_es'] as String,
      gCo2ePerKm: (json['g_co2e_per_km'] as num).toDouble(),
      perVehicle: json['per_vehicle'] as bool? ?? false,
      maxOccupants: (json['max_occupants'] as num?)?.toInt() ?? 1,
      calculationNotes: json['calculation_notes'] as String? ?? '',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => EmissionSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TransportModeToJson(_TransportMode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group': instance.group,
      'name_en': instance.nameEn,
      'name_ja': instance.nameJa,
      'name_es': instance.nameEs,
      'g_co2e_per_km': instance.gCo2ePerKm,
      'per_vehicle': instance.perVehicle,
      'max_occupants': instance.maxOccupants,
      'calculation_notes': instance.calculationNotes,
      'sources': instance.sources,
    };
