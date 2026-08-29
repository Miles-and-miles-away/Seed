// Freezed's documented pattern for JSON options puts
// @JsonSerializable on the factory, which trips this lint.
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

/// A city the user can pick to prefill journey distances.
///
/// [mass] tags the road-connected landmass (islands isolated);
/// fixed crossings between masses are [CityLink]s, so geography
/// stays pure and connectivity stays explicit.
///
/// [name] is the GeoNames endonym-or-English form and is always
/// present; [nameJa] and [nameEs] are sourced GeoNames alternate
/// names, null wherever GeoNames publishes none or publishes one
/// identical to [name].
@freezed
abstract class City with _$City {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory City({
    required String name,
    required String cc,
    required double lat,
    required double lon,
    required String mass,
    @Default(0) int pop,
    String? nameJa,
    String? nameEs,
  }) = _City;

  const City._();

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  /// Localized display name with English fallback.
  String localizedName(String locale) => switch (locale) {
    'ja' => nameJa ?? name,
    'es' => nameEs ?? name,
    _ => name,
  };
}

/// A fixed crossing between two landmasses.
///
/// kind "rail_tunnel" makes ground modes available across the
/// link; kind "ferry" makes ferry legs available. [maxKm] caps
/// the straight-line ferry suggestion distance for this link
/// (null falls back to the global cap).
///
/// Ferry links are port-anchored: each side carries a
/// representative port coordinate and a catchment radius, and a
/// ferry is only suggested when each city lies within its side's
/// radius. This scopes a mass-level link to the corridor it
/// names by construction. Links without ports (and rail_tunnel
/// links) gate on distance alone.
@freezed
abstract class CityLink with _$CityLink {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CityLink({
    required String a,
    required String b,
    required String kind,
    @Default('') String label,
    double? maxKm,
    double? portALat,
    double? portALon,
    double? radiusAKm,
    double? portBLat,
    double? portBLon,
    double? radiusBKm,
  }) = _CityLink;

  factory CityLink.fromJson(Map<String, dynamic> json) =>
      _$CityLinkFromJson(json);
}
