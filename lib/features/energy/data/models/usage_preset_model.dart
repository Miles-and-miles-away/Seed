// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_preset_model.freezed.dart';
part 'usage_preset_model.g.dart';

/// A named quantity for an energy behavior (e.g. "A typical shower
/// (10 min)", "An evening (4 h)"), so users enter amounts they recognise
/// rather than raw units (Phase 8.14). Picking a preset fills an
/// editable units field, exactly like a food serving fills grams.
///
/// [units] is in the behavior's own unit, so it is minutes for a
/// shower, hours for an air conditioner and dimensionless multiples of
/// one use for a bath. Some presets are not whole numbers: one mug in a
/// kettle is 0.3 uses.
@freezed
abstract class UsagePreset with _$UsagePreset {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UsagePreset({
    required String id,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double units,
  }) = _UsagePreset;

  const UsagePreset._();

  factory UsagePreset.fromJson(Map<String, dynamic> json) =>
      _$UsagePresetFromJson(json);

  /// Localized display name with English fallback.
  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };
}
