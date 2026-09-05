// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/features/energy/data/models/usage_preset_model.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';

part 'energy_behavior_model.freezed.dart';
part 'energy_behavior_model.g.dart';

/// The energy carrier a behavior draws on, which decides the factor its
/// kWh is multiplied by (Phase 8.13).
///
/// [none] exists for line drying: zero energy on no carrier at all, and
/// the only entry allowed a kWh of zero.
enum EnergyCarrier {
  @JsonValue('electricity')
  electricity,
  @JsonValue('gas')
  gas,
  @JsonValue('none')
  none,
}

/// What one unit of a behavior means. The dataset stores kWh per one of
/// these.
enum EnergyUnit {
  @JsonValue('minute')
  minute,
  @JsonValue('hour')
  hour,
  @JsonValue('use')
  use,
  @JsonValue('day')
  day,
}

/// A home energy behavior with its consumption factor and citations
/// (Phase 8.13).
///
/// The unit of this dataset is the **behavior**, never the product: no
/// makes, models or efficiency classes, because those inform purchases
/// rather than habits and would rot with every product cycle.
@freezed
abstract class EnergyBehavior with _$EnergyBehavior {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory EnergyBehavior({
    required String id,

    /// The set this behavior may be compared within. Doubles as the
    /// display grouping in the picker, because the comparability
    /// groups are also the sensible headings (hot water, dishes,
    /// laundry).
    ///
    /// Allowlist semantics: a new behavior compares with nothing until
    /// someone deliberately groups it. A blocklist would rot the first
    /// time an entry was added.
    required String comparableGroup,
    required EnergyCarrier carrier,
    required EnergyUnit unit,
    required double kwhPerUnit,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    @Default([]) List<UsagePreset> presets,
    @Default('') String defaultPresetId,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,

    /// How well-sourced the factor is: `high`, `medium_high`, `medium`
    /// or `low`, mirroring RESEARCH_ENERGY.md section 4.
    ///
    /// Only `standby` is `low`, and it is the only entry that gets a
    /// sublabel. An earlier draft of PDR rule 21 also demanded one on
    /// the oven, on the premise that it had no tier-1 primary; the
    /// research rates it `medium` on a tier-1 EU regulation, so the
    /// rule was corrected rather than the data (owner call
    /// 2026-08-29).
    @Default('medium') String confidence,
  }) = _EnergyBehavior;

  const EnergyBehavior._();

  factory EnergyBehavior.fromJson(Map<String, dynamic> json) =>
      _$EnergyBehaviorFromJson(json);

  /// Localized display name with English fallback.
  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };

  /// The preset the editor selects on open, or null when the dataset
  /// names none (or names one that no longer exists).
  UsagePreset? get defaultPreset {
    for (final preset in presets) {
      if (preset.id == defaultPresetId) return preset;
    }
    return null;
  }

  /// True when this entry's figure is the weakest class in the dataset
  /// and the UI owes the user a sublabel saying so.
  ///
  /// Today that is `standby` alone. See the [confidence] doc for why the
  /// oven is not included despite PDR rule 21.
  bool get isLowConfidence => confidence == 'low';
}
