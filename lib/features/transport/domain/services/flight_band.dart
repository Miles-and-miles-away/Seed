/// Honest flight-band selection for a flight leg (Phase 8.3).
///
/// DESNZ defines exactly three flight rows -- domestic, short-haul,
/// long-haul -- and no "medium-haul". Its domestic factor is for flights
/// that start and end in the UK (methodology paper para 8.8), with no
/// distance limit, so other same-country flights are not domestic here.
/// The short/long split is geographic and UK-centric; para 8.8 retires
/// the earlier 3,700 km rule as simplistic. A global app cannot use the
/// UK geography, so the auto-pick keeps that superseded but still
/// DESNZ-cited boundary, inventing no threshold of its own.
library;

const flightModeDomestic = 'flight_domestic';
const flightModeShortHaul = 'flight_shorthaul';
const flightModeLongHaul = 'flight_longhaul';

/// DEFRA's pre-2025 short-haul vs long-haul boundary (straight-line km).
const flightLongHaulMinKm = 3700.0;

/// DESNZ domestic scope: the UK, Isle of Man and Channel Islands.
const _desnzDomesticCountryCodes = {'GB', 'IM', 'JE', 'GG'};

/// The honest flight-mode id for a leg of [straightLineKm] between
/// countries [fromCc] and [toCc] (null when unknown, e.g. manual
/// distance entry with no city pair).
///
/// - Beyond [flightLongHaulMinKm]: long-haul regardless of country
///   -- a long within-country flight is cruise-dominated, not the
///   takeoff-dominated profile the domestic factor describes.
/// - Otherwise both ends inside the DESNZ domestic scope: domestic.
/// - Otherwise (any other or unknown country): short-haul.
String flightBandModeId({
  required double straightLineKm,
  String? fromCc,
  String? toCc,
}) {
  if (straightLineKm > flightLongHaulMinKm) return flightModeLongHaul;
  final domestic =
      _desnzDomesticCountryCodes.contains(fromCc) &&
      _desnzDomesticCountryCodes.contains(toCc);
  return domestic ? flightModeDomestic : flightModeShortHaul;
}
