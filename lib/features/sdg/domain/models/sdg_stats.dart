import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdg_stats.freezed.dart';

/// Aggregated stats for a specific SDG. Always built field-by-field
/// (never (de)serialized), so no json -- freezed is kept for value
/// equality and immutability.
@freezed
abstract class SdgStats with _$SdgStats {
  const factory SdgStats({
    required int sdgNumber,
    @Default(0) int actionsLogged,
    @Default(0) int co2SavedGrams,
  }) = _SdgStats;
}
