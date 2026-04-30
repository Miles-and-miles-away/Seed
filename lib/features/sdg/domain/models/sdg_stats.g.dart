// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sdg_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SdgStats _$SdgStatsFromJson(Map<String, dynamic> json) => _SdgStats(
      sdgNumber: (json['sdgNumber'] as num).toInt(),
      actionsLogged: (json['actionsLogged'] as num?)?.toInt() ?? 0,
      co2SavedGrams: (json['co2SavedGrams'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SdgStatsToJson(_SdgStats instance) => <String, dynamic>{
      'sdgNumber': instance.sdgNumber,
      'actionsLogged': instance.actionsLogged,
      'co2SavedGrams': instance.co2SavedGrams,
    };
