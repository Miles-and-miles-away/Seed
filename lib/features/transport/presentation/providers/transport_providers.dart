import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/transport/data/cities_data.dart';
import 'package:seed_app/features/transport/data/models/city_model.dart';
import 'package:seed_app/features/transport/data/models/journey_leg_model.dart';
import 'package:seed_app/features/transport/data/models/transport_mode_model.dart';
import 'package:seed_app/features/transport/data/transport_modes_data.dart';
import 'package:seed_app/features/transport/domain/services/journey_distance.dart';
import 'package:seed_app/features/transport/domain/services/transport_calculator.dart';

part 'transport_providers.g.dart';

// Pure data loads stay autoDispose: the cities loader memoizes its
// decoded root, and the modes asset is small, so re-parsing on a
// screen revisit is cheaper than pinning it for the app's lifetime.

/// All transport modes from the bundled dataset.
@riverpod
Future<List<TransportMode>> transportModes(Ref ref) => loadTransportModes();

/// Dataset metadata (scope statement, grid factor) for the
/// methodology sheet (Phase 8.4).
@riverpod
Future<Map<String, dynamic>> transportMetadata(Ref ref) =>
    loadTransportMetadata();

/// Modes indexed by id for calculator lookups.
@riverpod
Future<Map<String, TransportMode>> transportModesById(Ref ref) async {
  final modes = await ref.watch(transportModesProvider.future);
  return TransportCalculator.byId(modes);
}

/// Cities available for the distance-prefill pickers.
@riverpod
Future<List<City>> transportCities(Ref ref) => loadCities();

/// Fixed landmass crossings (rail tunnels, ferry corridors).
@riverpod
Future<List<CityLink>> transportCityLinks(Ref ref) => loadCityLinks();

/// Same-mass city pairs whose straight line crosses open water.
@riverpod
Future<Set<String>> transportWaterBlockedPairs(Ref ref) =>
    loadWaterBlockedPairs();

/// Suggested distances per journey kind for a city pair.
///
/// Threads the water-blocked pair set into [suggestedDistancesKm]
/// (PDR R4-10): without it, cross-water same-mass pairs like
/// Helsinki-Tallinn would get fictional ground/cycling estimates.
/// Every UI consumer must go through this provider, never call
/// [suggestedDistancesKm] with its silent empty default.
@riverpod
Future<Map<String, double>> citySuggestions(Ref ref, City from, City to) async {
  // A same-city pair has no meaningful estimate; guarding here
  // covers every consumer, so no "~0 km" label can render.
  if (from == to) return const {};
  final links = await ref.watch(transportCityLinksProvider.future);
  final blocked = await ref.watch(transportWaterBlockedPairsProvider.future);
  return suggestedDistancesKm(from, to, links, waterBlocked: blocked);
}

/// Ephemeral journey legs for the builder screen.
///
/// autoDispose by design: journeys are screen state, never persisted
/// (Phase 8 plan), so leaving the calculator resets the journey.
@riverpod
class JourneyBuilder extends _$JourneyBuilder {
  @override
  List<JourneyLeg> build() => const [];

  /// Appends a leg to the journey.
  void addLeg(JourneyLeg leg) => state = [...state, leg];

  /// Replaces the leg at [index].
  void updateLeg(int index, JourneyLeg leg) {
    final legs = [...state];
    legs[index] = leg;
    state = legs;
  }

  /// Removes the leg at [index].
  void removeLeg(int index) {
    final legs = [...state]..removeAt(index);
    state = legs;
  }
}
