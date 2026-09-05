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
  /// Throws [ArgumentError] unless units are finite and >= 0.
  static double usageCo2eGrams(
    EnergyBehavior behavior,
    RoutineUsage usage, {
    required double gridFactor,
    required double gasFactor,
  }) {
    _requireFiniteUnits(usage);
    final factor = switch (behavior.carrier) {
      EnergyCarrier.electricity => gridFactor,
      EnergyCarrier.gas => gasFactor,
      EnergyCarrier.none => 0.0,
    };
    return behavior.kwhPerUnit * usage.units * factor;
  }

  /// `< 0` alone is not enough: every comparison with NaN is false, so
  /// NaN sailed through, produced a NaN total, and then defeated the
  /// `deltaPercent < 20` gate the same way -- letting the app declare a
  /// winner on a NaN comparison. Infinity did the same.
  static void _requireFiniteUnits(RoutineUsage usage) {
    if (!usage.units.isFinite || usage.units < 0) {
      throw ArgumentError.value(
        usage.units,
        'units',
        'must be finite and >= 0',
      );
    }
  }

  /// The behavior a usage names, or [ArgumentError] if the dataset does
  /// not have it.
  ///
  /// Every path uses this. An earlier version threw here but skipped
  /// in [checkVerdict], which meant an unknown id quietly dropped a
  /// whole option's group and carrier from the gate -- making the
  /// verdict check more permissive than the totals it is supposed to
  /// guard.
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

  /// Total CO2e grams for a routine.
  ///
  /// Throws [ArgumentError] if a usage references an unknown behavior
  /// id -- the dataset is static, so that is a programming error.
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

  /// Total kWh for a routine, carrier-blind.
  ///
  /// The grid-invariant basis for the ratio headline and the
  /// phone-charge equivalency (E7, PDR rules 26-27): a kWh ratio
  /// cancels the carrier factor, where a gram ratio is only true on
  /// one grid. Same input contract as [routineCo2eGrams].
  static double routineKwh(
    Map<String, EnergyBehavior> behaviorsById,
    List<RoutineUsage> usages,
  ) {
    var total = 0.0;
    for (final usage in usages) {
      _requireFiniteUnits(usage);
      total +=
          _require(behaviorsById, usage.behaviorId).kwhPerUnit * usage.units;
    }
    return total;
  }

  /// kWh of one default-preset use of [behavior]: the basis the ranked
  /// view, the explore baselines and the quiz deck all rank on.
  static double defaultPresetKwh(EnergyBehavior behavior) =>
      behavior.kwhPerUnit * (behavior.defaultPreset?.units ?? 1);

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
  static EnergyVerdictCheck checkVerdict(
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
    final carriersPerOption = <Set<EnergyCarrier>>[];
    for (final option in options) {
      final groups = <String>{};
      final carriers = <EnergyCarrier>{};
      for (final usage in option) {
        final behavior = _require(behaviorsById, usage.behaviorId);
        groups.add(behavior.comparableGroup);
        // Carrier `none` is deliberately not collected. The
        // same-carrier rule exists because the gas-versus-electric
        // ordering flips with the grid factor, so a verdict would be a
        // fact about the user's country. A zero emits zero on every
        // grid and cannot flip, so line drying stays comparable with a
        // tumble dryer -- the flagship lesson of the feature -- by
        // contributing no carrier at all.
        if (behavior.carrier != EnergyCarrier.none) {
          carriers.add(behavior.carrier);
        }
      }
      groupsPerOption.add(groups);
      carriersPerOption.add(carriers);
    }
    final first = groupsPerOption.first;
    if (groupsPerOption.any((g) => !_sameSet(g, first))) {
      return const EnergyVerdictCheck(EnergyVerdictBlock.differentGroup);
    }
    // Carriers are compared per option too, for the same reason as the
    // groups. Pooling asked "is more than one carrier present at all",
    // which blocked a gas shower against a shorter gas shower the
    // moment a kettle sat on both sides -- and then told the user one
    // side runs on gas and the other on electricity, which was false.
    // Options with no carrier are skipped rather than compared: that
    // is the line-drying case above.
    final carried = carriersPerOption.where((c) => c.isNotEmpty).toList();
    if (carried.any((c) => !_sameSet(c, carried.first))) {
      return const EnergyVerdictCheck(EnergyVerdictBlock.differentCarrier);
    }
    if (summary.deltaPercent < verdictMinPercent) {
      return const EnergyVerdictCheck(EnergyVerdictBlock.tooClose);
    }
    return const EnergyVerdictCheck(EnergyVerdictBlock.none);
  }

  static bool _sameSet<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);
}

/// Why an energy comparison may not name a winner (decision E2).
enum EnergyVerdictBlock {
  /// It may.
  none,

  /// The routines span more than one comparable group, so the question
  /// is a category error rather than a close call.
  differentGroup,

  /// The two routines draw on different carriers, where the ordering
  /// is a fact about the user's grid rather than their behaviour.
  differentCarrier,

  /// Inside the dataset's own resolution.
  tooClose,
}

/// The verdict decision. Carries the required percentage so the UI can
/// explain the bar it did not clear.
class EnergyVerdictCheck {
  const EnergyVerdictCheck(this.block);

  final EnergyVerdictBlock block;

  /// The reduction this comparison would have needed, in percent.
  double get requiredPercent => EnergyCalculator.verdictMinPercent;
}
