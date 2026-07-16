// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailySummaryModel _$DailySummaryModelFromJson(Map<String, dynamic> json) =>
    _DailySummaryModel(
      date: json['date'] as String,
      goalCount: (json['goalCount'] as num?)?.toInt() ?? 0,
      completedSdgs:
          (json['completedSdgs'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      totalCo2Grams: (json['totalCo2Grams'] as num?)?.toInt() ?? 0,
      categoryCo2Grams:
          (json['categoryCo2Grams'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const <String, int>{},
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp?,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$DailySummaryModelToJson(_DailySummaryModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'goalCount': instance.goalCount,
      'completedSdgs': instance.completedSdgs,
      'totalPoints': instance.totalPoints,
      'totalCo2Grams': instance.totalCo2Grams,
      'categoryCo2Grams': instance.categoryCo2Grams,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
