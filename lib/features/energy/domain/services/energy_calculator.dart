import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

/// Pure CO2e arithmetic for home energy routines (Phase 8.14).
///
/// Unlike transport and food, this calculator generates nothing: no
/// points, no logged savings, no bankable action. A shorter shower has
/// no verifiable counterfactual (it needs a personal baseline the app
/// cannot obtain) and the action library already covers the same
/// behaviours, so a bridge would let one laundry load be logged twice.
/// Decision 8.18, permanent rather than deferred.
class EnergyCalculator {
  const EnergyCalculator._();

  /// CO2e grams for a single usage, given the two carrier factors from
  /// the dataset metadata.
  ///
  /// Throws [ArgumentError] on negative units.
  static double usageCo2eGrams(
    EnergyBehavior behavior,
    RoutineUsage usage, {
    required double gridFactor,
    required double gasFactor,
  }) {
    // `< 0` alone is not enough: every comparison with NaN is false, so
    // NaN sailed through, produced a NaN total, and then defeated the
    // `deltaPercent < 20` gate the same way -- letting the app declare a
    // winner on a NaN comparison. Infinity did the same.
    if (!usage.units.isFinite || usage.units < 0) {
      throw ArgumentError.value(
        usage.units,
        'units',
        'must be finite and >= 0',
      );
    }
    final factor = switch (behavior.carrier) {
      EnergyCarrier.electricity => gridFactor,
      EnergyCarrier.gas => gasFactor,
      EnergyCarrier.none => 0.0,
    };
    return behavior.kwhPerUnit * usage.units * factor;
  }

  /// Total CO2e grams for a routine.
  ///
  /// Throws [ArgumentError] if a usage references an unknown behavior
  /// id -- the dataset is static, so that is a programming error.
  /// The behavior a usage names, or [ArgumentError] if the dataset does
  /// not have it.
  ///
  /// Every path uses this. An earlier version threw here, skipped in
  /// [routineKwh] and skipped in [checkVerdict], which meant an unknown
  /// id quietly dropped a whole option's group and carrier from the
  /// gate -- making the verdict check more permissive than the totals
  /// it is supposed to guard.
  static EnergyBehavior _require(
    Map<String, EnergyBehavior> behaviorsById,
    String behaviorId,
  ) {
    final behavior = behaviorsById[behaviorId];
    if (behavior == null) {
      throw ArgumentError.value(
        behaviorId,
        'behaviorId',
        'unknown energy behavior',
      );
    }
    return behavior;
  }

  static double routineCo2eGrams(
    Map<String, EnergyBehavior> behaviorsById,
    List<RoutineUsage> usages, {
    required double gridFactor,
    required double gasFactor,
  }) {
    var total = 0.0;
    for (final usage in usages) {
      final behavior = _require(behaviorsById, usage.behaviorId);
      total += usageCo2eGrams(
        behavior,
        usage,
        gridFactor: gridFactor,
        gasFactor: gasFactor,
      );
    }
    return total;
  }

  /// Total site kWh for a routine.
  ///
  /// Site energy, so a gas kWh and an electric kWh add up here even
  /// though they are not the same thing carbon-wise. Never rank two
  /// routines on this number -- that is what the carrier factors and
  /// [routineCo2eGrams] are for (RESEARCH_ENERGY section 6 pin 1).
  static double routineKwh(
    Map<String, EnergyBehavior> behaviorsById,
    List<RoutineUsage> usages,
  ) {
    var total = 0.0;
    for (final usage in usages) {
      total +=
          _require(behaviorsById, usage.behaviorId).kwhPerUnit * usage.units;
    }
    return total;
  }

  /// Index for routine lookups.
  static Map<String, EnergyBehavior> byId(List<EnergyBehavior> behaviors) => {
    for (final b in behaviors) b.id: b,
  };

  /// Minimum reduction, in percent, before the comparison may name a
  /// winner (decision E2).
  static const verdictMinPercent = 20.0;

  /// Whether the comparison may state a verdict, and if not, why.
  ///
  /// Three conditions, all of which must hold (decision E2). A
  /// percentage-delta rule alone cannot catch a category error:
  /// comparing a wash load to a dishwasher load is not a close call,
  /// it is a different question.
  static VerdictCheck checkVerdict(
    ComparisonSummary summary,
    Map<String, EnergyBehavior> behaviorsById,
    List<List<RoutineUsage>> options,
  ) {
    // Groups are compared PER OPTION, not pooled. Pooling asked the
    // wrong question: "shower + kettle" against "heat-pump shower +
    // kettle" is one within-group substitution with identical
    // composition on both sides, and a union rule blocked it as a
    // category error -- killing the dataset's headline lever (heat-pump
    // water heating, 4.3x). What makes a comparison a category error is
    // the two sides being about different things, so that is what is
    // tested: a wash load against a dishwasher load still fails.
    final groupsPerOption = <Set<String>>[];
    final carriers = <EnergyCarrier>{};
    for (final option in options) {
      final groups = <String>{};
      for (final usage in option) {
        final behavior = _require(behaviorsById, usage.behaviorId);
        groups.add(behavior.comparableGroup);
        // Carrier `none` is deliberately not collected, and is pooled
        // rather than per-option for the same reason. The same-carrier
        // rule exists because the gas-versus-electric ordering flips
        // with the grid factor, so a verdict would be a fact about the
        // user's country. A zero emits zero on every grid and cannot
        // flip, so line drying stays comparable with a tumble dryer --
        // the flagship lesson of the feature. Per-option carrier sets
        // would have broken exactly that, since line drying's option
        // has no carrier at all.
        if (behavior.carrier != EnergyCarrier.none) {
          carriers.add(behavior.carrier);
        }
      }
      groupsPerOption.add(groups);
    }
    final first = groupsPerOption.first;
    if (groupsPerOption.any((g) => !_sameGroups(g, first))) {
      return const VerdictCheck(EnergyVerdictBlock.differentGroup);
    }
    if (carriers.length > 1) {
      return const VerdictCheck(EnergyVerdictBlock.differentCarrier);
    }
    if (summary.deltaPercent < verdictMinPercent) {
      return const VerdictCheck(EnergyVerdictBlock.tooClose);
    }
    return const VerdictCheck(EnergyVerdictBlock.none);
  }

  static bool _sameGroups(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  /// A tie is the honest answer, not a failure to compute: the kettle
  /// and the induction hob really are within 0.3% of each other, and
  /// saying so is more useful than manufacturing a winner.
  static bool mayStateVerdict(
    ComparisonSummary summary,
    Map<String, EnergyBehavior> behaviorsById,
    List<List<RoutineUsage>> options,
  ) =>
      checkVerdict(summary, behaviorsById, options).block ==
      EnergyVerdictBlock.none;
}

/// Why an energy comparison may not name a winner (decision E2).
enum EnergyVerdictBlock {
  /// It may.
  none,

  /// The routines span more than one comparable group, so the question
  /// is a category error rather than a close call.
  differentGroup,

  /// The routines span both gas and electricity, where the ordering is
  /// a fact about the user's grid rather than their behaviour.
  differentCarrier,

  /// Inside the dataset's own resolution.
  tooClose,
}

/// The verdict decision. Carries the required percentage so the UI can
/// explain the bar it did not clear.
class VerdictCheck {
  const VerdictCheck(this.block);

  final EnergyVerdictBlock block;

  /// The reduction this comparison would have needed, in percent.
  double get requiredPercent => EnergyCalculator.verdictMinPercent;
}
