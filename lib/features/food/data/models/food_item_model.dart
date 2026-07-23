// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/features/food/data/models/serving_preset_model.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';

part 'food_item_model.freezed.dart';
part 'food_item_model.g.dart';

/// A food item with its CO2e emission factor and citations (Phase 8.7).
///
/// [kgCo2ePerKg] is kg CO2e per kg of food as-purchased (raw/dry weight),
/// cradle-to-retail incl. land-use change (Poore & Nemecek 2018 means via
/// Our World in Data). Liquids assume density 1.0, so per litre = per kg.
@freezed
abstract class FoodItem with _$FoodItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory FoodItem({
    required String id,
    required String group,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double kgCo2ePerKg,
    @Default([]) List<ServingPreset> servings,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,
  }) = _FoodItem;

  const FoodItem._();

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);

  /// Localized display name with English fallback.
  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };
}
