import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/energy/data/energy_behaviors_data.dart';
import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/shared/domain/option_lists.dart';

part 'energy_providers.g.dart';

// Pure data loads stay autoDispose: the asset is small, so re-parsing
// on a screen revisit is cheaper than pinning it for the app's
// lifetime (mirrors the transport and food providers).

/// All energy behaviors from the bundled dataset.
@riverpod
Future<List<EnergyBehavior>> energyBehaviors(Ref ref) => loadEnergyBehaviors();

/// Dataset metadata (scope, both carrier factors) for the methodology
/// screen and the engine's factors (Phase 8.16).
@riverpod
Future<Map<String, dynamic>> energyMetadata(Ref ref) => loadEnergyMetadata();

/// The two carrier factors, read from the dataset rather than hardcoded
/// so the metadata block stays the single source of truth.
@riverpod
Future<CarrierFactors> energyCarrierFactors(Ref ref) async {
  final metadata = await ref.watch(energyMetadataProvider.future);
  return CarrierFactors(
    grid: (metadata['grid_factor_g_per_kwh'] as num).toDouble(),
    gas: (metadata['gas_factor_g_per_kwh'] as num).toDouble(),
  );
}

/// The electricity and gas factors in g CO2e per kWh.
class CarrierFactors {
  const CarrierFactors({required this.grid, required this.gas});

  final double grid;
  final double gas;
}

/// Ids of behaviors picked this session, most recent first.
///
/// keepAlive so the list survives closing the picker, but memory-only:
/// building two comparable routines means reaching for the same handful
/// of behaviors twice, and the payoff is within a session anyway.
@Riverpod(keepAlive: true)
class RecentEnergyBehaviorIds extends _$RecentEnergyBehaviorIds {
  /// Enough to cover a two-routine comparison without pushing the
  /// grouped list off screen.
  static const maxRecents = 8;

  @override
  List<String> build() => const [];

  /// Records a pick, moving a repeat to the front rather than
  /// duplicating it.
  void record(String behaviorId) {
    state = List.unmodifiable(
      [behaviorId, ...state.where((id) => id != behaviorId)].take(maxRecents),
    );
  }
}

/// The usages of both routine options, indexed [optionA] / [optionB].
///
/// keepAlive: an in-progress comparison must survive navigating away
/// and back. Memory-only -- this calculator persists and banks nothing
/// (decision 8.18).
@Riverpod(keepAlive: true)
class RoutineOptions extends _$RoutineOptions {
  @override
  List<List<RoutineUsage>> build() => List.unmodifiable([
    for (var i = 0; i < optionCount; i++) const <RoutineUsage>[],
  ]);

  /// Appends a usage to [option].
  void addUsage(int option, RoutineUsage usage) {
    if (!isValidOption(option)) return;
    state = withOption(state, option, [...state[option], usage]);
  }

  /// Replaces the usage at [index] within [option].
  void updateUsage(int option, int index, RoutineUsage usage) {
    if (!isValidOption(option) || index < 0 || index >= state[option].length) {
      return;
    }
    final usages = [...state[option]];
    usages[index] = usage;
    state = withOption(state, option, usages);
  }

  /// Removes the usage at [index] within [option].
  void removeUsage(int option, int index) {
    if (!isValidOption(option) || index < 0 || index >= state[option].length) {
      return;
    }
    final usages = [...state[option]]..removeAt(index);
    state = withOption(state, option, usages);
  }

  /// Empties both options.
  void clear() => state = build();
}
