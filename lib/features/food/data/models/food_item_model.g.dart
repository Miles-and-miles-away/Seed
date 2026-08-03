// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => _FoodItem(
  id: json['id'] as String,
  group: json['group'] as String,
  nameEn: json['name_en'] as String,
  nameJa: json['name_ja'] as String,
  nameEs: json['name_es'] as String,
  kgCo2ePerKg: (json['kg_co2e_per_kg'] as num).toDouble(),
  servings:
      (json['servings'] as List<dynamic>?)
          ?.map((e) => ServingPreset.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  searchTermsEn:
      (json['search_terms_en'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  searchTermsJa:
      (json['search_terms_ja'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  searchTermsEs:
      (json['search_terms_es'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  calculationNotes: json['calculation_notes'] as String? ?? '',
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map((e) => EmissionSource.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$FoodItemToJson(_FoodItem instance) => <String, dynamic>{
  'id': instance.id,
  'group': instance.group,
  'name_en': instance.nameEn,
  'name_ja': instance.nameJa,
  'name_es': instance.nameEs,
  'kg_co2e_per_kg': instance.kgCo2ePerKg,
  'servings': instance.servings,
  'search_terms_en': instance.searchTermsEn,
  'search_terms_ja': instance.searchTermsJa,
  'search_terms_es': instance.searchTermsEs,
  'calculation_notes': instance.calculationNotes,
  'sources': instance.sources,
};
