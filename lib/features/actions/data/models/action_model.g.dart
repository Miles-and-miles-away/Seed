// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => _ActionModel(
      id: json['id'] as String,
      nameEn: json['nameEn'] as String,
      nameJa: json['nameJa'] as String,
      category: json['category'] as String,
      points: (json['points'] as num).toInt(),
      nameEs: json['nameEs'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      descriptionJa: json['descriptionJa'] as String? ?? '',
      descriptionEs: json['descriptionEs'] as String? ?? '',
      descriptionLongEn: json['descriptionLongEn'] as String? ?? '',
      descriptionLongJa: json['descriptionLongJa'] as String? ?? '',
      descriptionLongEs: json['descriptionLongEs'] as String? ?? '',
      co2Grams: (json['co2Grams'] as num?)?.toInt() ?? 0,
      iconName: json['iconName'] as String? ?? 'eco',
      relatedSdgs: (json['relatedSdgs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isLearnOnly: json['isLearnOnly'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ActionModelToJson(_ActionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameEn': instance.nameEn,
      'nameJa': instance.nameJa,
      'category': instance.category,
      'points': instance.points,
      'nameEs': instance.nameEs,
      'descriptionEn': instance.descriptionEn,
      'descriptionJa': instance.descriptionJa,
      'descriptionEs': instance.descriptionEs,
      'descriptionLongEn': instance.descriptionLongEn,
      'descriptionLongJa': instance.descriptionLongJa,
      'descriptionLongEs': instance.descriptionLongEs,
      'co2Grams': instance.co2Grams,
      'iconName': instance.iconName,
      'relatedSdgs': instance.relatedSdgs,
      'isLearnOnly': instance.isLearnOnly,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
    };
