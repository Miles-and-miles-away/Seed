// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomAction _$CustomActionFromJson(Map<String, dynamic> json) =>
    _CustomAction(
      id: json['id'] as String,
      name: json['name'] as String,
      co2Grams: (json['co2Grams'] as num).toInt(),
      points: (json['points'] as num).toInt(),
      category: json['category'] as String,
      relatedSdgs: (json['relatedSdgs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CustomActionToJson(_CustomAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'co2Grams': instance.co2Grams,
      'points': instance.points,
      'category': instance.category,
      'relatedSdgs': instance.relatedSdgs,
    };
