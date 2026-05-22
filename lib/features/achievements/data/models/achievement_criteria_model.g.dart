// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_criteria_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionCountCriteria _$ActionCountCriteriaFromJson(Map<String, dynamic> json) =>
    ActionCountCriteria(
      count: (json['count'] as num).toInt(),
      category: json['category'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ActionCountCriteriaToJson(
        ActionCountCriteria instance) =>
    <String, dynamic>{
      'count': instance.count,
      'category': instance.category,
      'type': instance.$type,
    };

StreakDaysCriteria _$StreakDaysCriteriaFromJson(Map<String, dynamic> json) =>
    StreakDaysCriteria(
      days: (json['days'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$StreakDaysCriteriaToJson(StreakDaysCriteria instance) =>
    <String, dynamic>{
      'days': instance.days,
      'type': instance.$type,
    };

LevelReachedCriteria _$LevelReachedCriteriaFromJson(
        Map<String, dynamic> json) =>
    LevelReachedCriteria(
      level: (json['level'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$LevelReachedCriteriaToJson(
        LevelReachedCriteria instance) =>
    <String, dynamic>{
      'level': instance.level,
      'type': instance.$type,
    };

SdgCountCriteria _$SdgCountCriteriaFromJson(Map<String, dynamic> json) =>
    SdgCountCriteria(
      count: (json['count'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SdgCountCriteriaToJson(SdgCountCriteria instance) =>
    <String, dynamic>{
      'count': instance.count,
      'type': instance.$type,
    };

Co2SavedCriteria _$Co2SavedCriteriaFromJson(Map<String, dynamic> json) =>
    Co2SavedCriteria(
      grams: (json['grams'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$Co2SavedCriteriaToJson(Co2SavedCriteria instance) =>
    <String, dynamic>{
      'grams': instance.grams,
      'type': instance.$type,
    };

CategoriesCoveredCriteria _$CategoriesCoveredCriteriaFromJson(
        Map<String, dynamic> json) =>
    CategoriesCoveredCriteria(
      count: (json['count'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$CategoriesCoveredCriteriaToJson(
        CategoriesCoveredCriteria instance) =>
    <String, dynamic>{
      'count': instance.count,
      'type': instance.$type,
    };

SpecialCriteria _$SpecialCriteriaFromJson(Map<String, dynamic> json) =>
    SpecialCriteria(
      specialType: json['specialType'] as String,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$SpecialCriteriaToJson(SpecialCriteria instance) =>
    <String, dynamic>{
      'specialType': instance.specialType,
      'type': instance.$type,
    };
