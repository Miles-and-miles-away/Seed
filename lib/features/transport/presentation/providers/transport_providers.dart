import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';

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
/// (review requirement): without it, cross-water same-mass pairs like
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

/// The legs of both journey options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back (checking the methodology, popping to Actions), which
/// autoDispose silently wiped. Still memory-only -- nothing is
/// persisted (Phase 8 plan), so it resets when the app restarts.
@Riverpod(keepAlive: true)
class JourneyOptions extends _$JourneyOptions {
  @override
  List<List<JourneyLeg>> build() => List.unmodifiable([
    for (var i = 0; i < optionCount; i++) const <JourneyLeg>[],
  ]);

  bool _valid(int option) => option >= 0 && option < optionCount;

  List<List<JourneyLeg>> _withOption(int option, List<JourneyLeg> legs) =>
      List.unmodifiable([
        for (var i = 0; i < optionCount; i++)
          if (i == option) List<JourneyLeg>.unmodifiable(legs) else state[i],
      ]);

  /// Appends a leg to [option].
  void addLeg(int option, JourneyLeg leg) {
    if (!_valid(option)) return;
    state = _withOption(option, [...state[option], leg]);
  }

  /// Replaces the leg at [index] within [option].
  void updateLeg(int option, int index, JourneyLeg leg) {
    if (!_valid(option) || index < 0 || index >= state[option].length) return;
    final legs = [...state[option]];
    legs[index] = leg;
    state = _withOption(option, legs);
  }

  /// Removes the leg at [index] within [option].
  void removeLeg(int option, int index) {
    if (!_valid(option) || index < 0 || index >= state[option].length) return;
    final legs = [...state[option]]..removeAt(index);
    state = _withOption(option, legs);
  }

  /// Empties both options (after banking a choice).
  void clear() => state = build();
}
