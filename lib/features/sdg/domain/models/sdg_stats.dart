import 'package:freezed_annotation/freezed_annotation.dart';

part 'sdg_stats.freezed.dart';
part 'sdg_stats.g.dart';

/// Aggregated stats for a specific SDG.
@freezed
abstract class SdgStats with _$SdgStats {
  const factory SdgStats({
    required int sdgNumber,
    @Default(0) int actionsLogged,
    @Default(0) int co2SavedGrams,
  }) = _SdgStats;

  factory SdgStats.fromJson(Map<String, dynamic> json) =>
      _$SdgStatsFromJson(json);
}
