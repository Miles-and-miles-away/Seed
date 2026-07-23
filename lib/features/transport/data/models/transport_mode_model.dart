// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:seed_app/shared/models/emission_source_model.dart';

part 'transport_mode_model.freezed.dart';
part 'transport_mode_model.g.dart';

/// A transport mode with its CO2e emission factor and citations.
///
/// [gCo2ePerKm] is grams CO2e per passenger-km, except for
/// [perVehicle] modes where it is per vehicle-km and must be
/// divided by the number of occupants (1..[maxOccupants]).
@freezed
abstract class TransportMode with _$TransportMode {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TransportMode({
    required String id,
    required String group,
    required String nameEn,
    required String nameJa,
    required String nameEs,
    required double gCo2ePerKm,
    @Default(false) bool perVehicle,
    @Default(1) int maxOccupants,
    @Default('') String calculationNotes,
    @Default([]) List<EmissionSource> sources,
  }) = _TransportMode;

  const TransportMode._();

  factory TransportMode.fromJson(Map<String, dynamic> json) =>
      _$TransportModeFromJson(json);

  /// Localized display name with English fallback.
  String name(String locale) => switch (locale) {
    'ja' when nameJa.isNotEmpty => nameJa,
    'es' when nameEs.isNotEmpty => nameEs,
    _ => nameEn,
  };
}
