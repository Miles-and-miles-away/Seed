import 'dart:math';

import 'package:seed_app/features/transport/data/models/city_model.dart';

/// Distance estimation and mode availability for city-pair
/// prefill. Estimates only -- every prefilled distance stays
/// user-editable in the journey builder.

/// Ground routes exceed straight-line distance; US-average
/// driving circuity is ~1.3 (range 1.2-1.42 in the literature:
/// Ballou et al. 2002, circuity.org). Applied to car/bus/rail
/// and active-mode estimates.
const groundCircuityFactor = 1.3;

/// Flights are estimated as great-circle + 95 km, the EN 16258
/// convention used by myclimate and EU MRV for routing detours.
const flightDetourKm = 95.0;

/// Ground modes are offered up to this straight-line distance --
/// product rule: a plausible long drive or one rail/coach journey
/// (matches the city_pairs prototype intent).
const groundModeMaxKm = 2000.0;

/// Below this straight-line distance flying is not offered.
const minFlightKm = 250.0;

/// Ferry suggestions are capped at this straight-line distance
/// unless the link carries its own [CityLink.maxKm]. Port-anchored
/// links additionally require each city inside its side's
/// catchment radius, which scopes a mass-level link to the
/// corridor it names; the cap remains as a backstop for portless
/// links and total-distance sanity.
const ferryModeMaxKm = 500.0;

/// Linkless cross-water pairs below this straight-line distance
/// get no air fallback: they are local boat hops the model does
/// not cover, so the suggestion map stays empty and the UI falls
/// back to manual distance entry.
const fallbackAirMinKm = 100.0;

/// Active modes (walk/cycle groups) are only suggested for short
/// hops; users can still add active legs manually at any length.
/// [kindActive] uses the cycle-family cap; when mapping the kind
/// to concrete modes, exclude walking beyond [walkModeMaxKm].
const activeModeMaxKm = 150.0;

/// Walking is only a sensible suggestion far below the cycle cap.
/// Applied at kind-to-mode mapping time, not in the suggestion
/// map: [kindActive] up to [activeModeMaxKm] means cycle-family;
/// walking is offered only up to this straight-line distance.
const walkModeMaxKm = 40.0;

/// Suggestion keys returned by [suggestedDistancesKm].
const kindGround = 'ground';
const kindAir = 'air';
const kindFerry = 'ferry';
const kindActive = 'active';

const _earthRadiusKm = 6371.0088;

/// Great-circle distance between two coordinates.
double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  final phi1 = lat1 * pi / 180;
  final phi2 = lat2 * pi / 180;
  final sinDPhi = sin((lat2 - lat1) * pi / 360);
  final sinDLambda = sin((lon2 - lon1) * pi / 360);
  final a = sinDPhi * sinDPhi + cos(phi1) * cos(phi2) * sinDLambda * sinDLambda;
  // Float error can push a just past 1 near antipodes, making
  // asin return NaN; clamp keeps the result finite.
  return 2 * _earthRadiusKm * asin(sqrt(min(1.0, a)));
}

CityLink? _link(City a, City b, List<CityLink> links, String kind) {
  for (final link in links) {
    if (link.kind != kind) continue;
    final direct = link.a == a.mass && link.b == b.mass;
    final reverse = link.b == a.mass && link.a == b.mass;
    if (direct || reverse) return link;
  }
  return null;
}

bool _withinPort(
  City city,
  double? portLat,
  double? portLon,
  double? radiusKm,
) {
  if (portLat == null || portLon == null || radiusKm == null) return true;
  return haversineKm(city.lat, city.lon, portLat, portLon) <= radiusKm;
}

/// Whether both cities sit inside the link's port catchments.
/// Portless sides always pass (legacy distance-only links).
bool _portsAllow(City a, City b, CityLink link) {
  final aIsSideA = a.mass == link.a;
  final sideA = aIsSideA ? a : b;
  final sideB = aIsSideA ? b : a;
  return _withinPort(sideA, link.portALat, link.portALon, link.radiusAKm) &&
      _withinPort(sideB, link.portBLat, link.portBLon, link.radiusBKm);
}

/// Canonical key for an unordered city pair, matching the keys in
/// the water-blocked set from `loadWaterBlockedPairs`.
String cityPairKey(City a, City b) {
  final ka = '${a.cc}/${a.name}';
  final kb = '${b.cc}/${b.name}';
  return ka.compareTo(kb) <= 0 ? '$ka||$kb' : '$kb||$ka';
}

/// Estimated distances (km) per available journey kind for a
/// city pair. Kinds absent from the map should not be suggested
/// in the UI (the user can still build any journey manually).
///
/// - [kindGround]: same landmass or a rail_tunnel link, within
///   [groundModeMaxKm] straight-line, and not water-blocked;
///   estimate = haversine x 1.3
/// - [kindAir]: at least [minFlightKm]; estimate = haversine + 95
/// - [kindFerry]: a ferry link between the masses whose port
///   catchments admit both cities, within the link's
///   [CityLink.maxKm] (default [ferryModeMaxKm]);
///   estimate = haversine (no detour factor)
/// - [kindActive]: ground rules and within [activeModeMaxKm]
///
/// [waterBlocked] (from `loadWaterBlockedPairs`) lists same-mass
/// pairs whose straight line crosses open water the x1.3 circuity
/// cannot honestly cover (Helsinki-Tallinn); ground/active are
/// suppressed for them, air/ferry unaffected.
///
/// Cross-water pairs below [minFlightKm] with no usable link get
/// air as a fallback (real short island hops exist), but only at
/// or above [fallbackAirMinKm]; below that the map stays empty.
Map<String, double> suggestedDistancesKm(
  City a,
  City b,
  List<CityLink> links, {
  Set<String> waterBlocked = const {},
}) {
  final straight = haversineKm(a.lat, a.lon, b.lat, b.lon);
  // NaN coordinates would otherwise flow into a {air: NaN}
  // fallback suggestion; an unknown distance is no suggestion.
  if (straight.isNaN) return const {};
  final grounded =
      a.mass == b.mass || _link(a, b, links, 'rail_tunnel') != null;
  final result = <String, double>{};
  if (grounded &&
      straight <= groundModeMaxKm &&
      !waterBlocked.contains(cityPairKey(a, b))) {
    result[kindGround] = straight * groundCircuityFactor;
    if (straight <= activeModeMaxKm) {
      result[kindActive] = straight * groundCircuityFactor;
    }
  }
  if (straight >= minFlightKm) {
    result[kindAir] = straight + flightDetourKm;
  }
  final ferry = _link(a, b, links, 'ferry');
  if (ferry != null &&
      straight <= (ferry.maxKm ?? ferryModeMaxKm) &&
      _portsAllow(a, b, ferry)) {
    result[kindFerry] = straight;
  }
  if (result.isEmpty && straight >= fallbackAirMinKm) {
    result[kindAir] = straight + flightDetourKm;
  }
  return result;
}
