/// Honest flight-band selection for a flight leg (Phase 8.3).
///
/// DEFRA/DESNZ 2025 (the dataset's primary source) defines exactly
/// three flight rows -- domestic, short-haul, long-haul -- and no
/// "medium-haul". "Domestic" is jurisdictional, not a distance. The
/// short/long split is geographic and UK-centric (UK to Europe and
/// North Africa is short-haul, everything else long-haul); the 2025
/// methodology paper (para 8.9) retired its earlier 3,700 km rule as
/// simplistic. A global app cannot use the UK geography, so the
/// auto-pick keeps that superseded but still DEFRA-cited 3,700 km
/// boundary for the short/long split and country codes for domestic,
/// inventing no threshold of its own.
///
/// ponytail: if the product later wants a different rule (e.g. a
/// distance cutoff for domestic), this one function is the only
/// place to change.
library;

const flightModeDomestic = 'flight_domestic';
const flightModeShortHaul = 'flight_shorthaul';
const flightModeLongHaul = 'flight_longhaul';

/// DEFRA's pre-2025 short-haul vs long-haul boundary (straight-line km).
const flightLongHaulMinKm = 3700.0;

/// The honest flight-mode id for a leg of [straightLineKm] between
/// countries [fromCc] and [toCc] (null when unknown, e.g. manual
/// distance entry with no city pair).
///
/// - Beyond [flightLongHaulMinKm]: long-haul regardless of country
///   -- a long within-country flight is cruise-dominated, not the
///   takeoff-dominated profile the domestic factor describes.
/// - Otherwise same known country: domestic (the highest per-km
///   band, reflecting takeoff overhead on short hops).
/// - Otherwise (different or unknown country): short-haul.
String flightBandModeId({
  required double straightLineKm,
  String? fromCc,
  String? toCc,
}) {
  if (straightLineKm > flightLongHaulMinKm) return flightModeLongHaul;
  final sameCountry = fromCc != null && toCc != null && fromCc == toCc;
  return sameCountry ? flightModeDomestic : flightModeShortHaul;
}
