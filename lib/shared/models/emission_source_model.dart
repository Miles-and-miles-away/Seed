import 'package:freezed_annotation/freezed_annotation.dart';

part 'emission_source_model.freezed.dart';
part 'emission_source_model.g.dart';

/// A single citation backing an emission factor (transport mode, food
/// item, energy behavior). Shared across the Phase 8 calculators.
@freezed
abstract class EmissionSource with _$EmissionSource {
  const factory EmissionSource({
    required String name,
    required String url,
    @Default('') String quote,
    @Default('') String accessed,
  }) = _EmissionSource;

  factory EmissionSource.fromJson(Map<String, dynamic> json) =>
      _$EmissionSourceFromJson(json);
}
