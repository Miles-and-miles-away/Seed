import 'dart:math';

import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';

/// Pure CO2e arithmetic for transport journeys.
///
/// Educational feature: results are never converted to points or
/// logged CO2 savings (No Fake Points principle, Phase 8 plan).
class TransportCalculator {
  const TransportCalculator._();

  /// CO2e grams for a single leg.
  ///
  /// Per-vehicle modes divide the vehicle factor by occupants,
  /// clamped to 1..[TransportMode.maxOccupants]. Throws
  /// [ArgumentError] on negative distance.
  static double legCo2eGrams(TransportMode mode, JourneyLeg leg) {
    if (leg.distanceKm < 0) {
      throw ArgumentError.value(leg.distanceKm, 'distanceKm', 'must be >= 0');
    }
    if (!mode.perVehicle) return mode.gCo2ePerKm * leg.distanceKm;
    // Guard maxOccupants < 1 (clamp would throw on an inverted
    // range); degrade to solo occupancy instead of crashing.
    final occupants = leg.occupants.clamp(1, max(1, mode.maxOccupants));
    return mode.gCo2ePerKm * leg.distanceKm / occupants;
  }

  /// Total CO2e grams for a journey.
  ///
  /// Throws [ArgumentError] if a leg references an unknown mode
  /// id -- the dataset is static, so that is a programming error.
  static double journeyCo2eGrams(
    Map<String, TransportMode> modesById,
    List<JourneyLeg> legs,
  ) {
    var total = 0.0;
    for (final leg in legs) {
      final mode = modesById[leg.modeId];
      if (mode == null) {
        throw ArgumentError.value(
          leg.modeId,
          'modeId',
          'unknown transport mode',
        );
      }
      total += legCo2eGrams(mode, leg);
    }
    return total;
  }

  /// Index for [journeyCo2eGrams] lookups.
  static Map<String, TransportMode> byId(List<TransportMode> modes) => {
    for (final m in modes) m.id: m,
  };
}
