// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'serving_preset_model.freezed.dart';
part 'serving_preset_model.g.dart';

/// A named portion for a food item (e.g. "1 breast", "1 can"), so users
/// enter quantities they know rather than raw grams (Phase 8.8). Picking
/// a preset fills an editable grams field.
@freezed
abstract class ServingPreset with _$ServingPreset {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ServingPreset({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double grams,
  }) = _ServingPreset;

  const ServingPreset._();

  factory ServingPreset.fromJson(Map<String, dynamic> json) =>
      _$ServingPresetFromJson(json);

  /// Localized display name with English fallback.
  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };
}
