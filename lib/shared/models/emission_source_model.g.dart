// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emission_source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmissionSource _$EmissionSourceFromJson(Map<String, dynamic> json) =>
    _EmissionSource(
      name: json['name'] as String,
      url: json['url'] as String,
      quote: json['quote'] as String? ?? '',
      accessed: json['accessed'] as String? ?? '',
    );

Map<String, dynamic> _$EmissionSourceToJson(_EmissionSource instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'quote': instance.quote,
      'accessed': instance.accessed,
    };
