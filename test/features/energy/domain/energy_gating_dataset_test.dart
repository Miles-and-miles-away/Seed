import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

import '../../../helpers/dataset_helpers.dart';

/// The gating rule exercised against the REAL dataset, not hand-built
/// behaviors (Phase 8.15, decision E2).
///
/// The unit tests in energy_calculator_test.dart prove the rule; this
/// file proves the shipped data actually lands where the PDR says it
/// must. Both are needed: a dataset edit can break these without
/// touching the engine.
void main() {
  late Map<String, EnergyBehavior> byId;
  late double grid;
  late double gas;

  setUpAll(() {
    final root = rawDatasetRoot('data/app/energy_behaviors.json');
    final behaviors = datasetEntries(
      root,
      'behaviors',
    ).map(EnergyBehavior.fromJson).toList();
    byId = EnergyCalculator.byId(behaviors);
    final metadata = root['metadata'] as Map<String, dynamic>;
    grid = (metadata['grid_factor_g_per_kwh'] as num).toDouble();
    gas = (metadata['gas_factor_g_per_kwh'] as num).toDouble();
  });

  EnergyVerdictBlock blockFor(
    List<(String, double)> a,
    List<(String, double)> b,
  ) {
    final options = [
      [for (final (id, units) in a) RoutineUsage(behaviorId: id, units: units)],
      [for (final (id, units) in b) RoutineUsage(behaviorId: id, units: units)],
    ];
    final totals = [
      for (final o in options)
        EnergyCalculator.routineCo2eGrams(
          byId,
          o,
          gridFactor: grid,
          gasFactor: gas,
        ),
    ];
    return EnergyCalculator.checkVerdict(
      compareTotals(totals)!,
      byId,
      options,
    ).block;
  }

  group('pairs the PDR requires to be blocked', () {
    // PDR_ENERGY_CALCULATOR.md section 3 checks the gating against the
    // never-pin list. Each of these must stay blocked, and the reason
    // matters as much as the refusal.
    test('kettle vs gas hob fails the carrier condition', () {
      expect(
        blockFor([('kettle', 1)], [('gas_hob', 1)]),
        EnergyVerdictBlock.differentCarrier,
      );
    });

    test('a gas bath vs an electric bath fails the carrier condition', () {
      expect(
        blockFor([('bath_gas', 1)], [('bath_electric', 1)]),
        EnergyVerdictBlock.differentCarrier,
      );
    });

    test('kettle vs induction hob fails the 20% condition', () {
      expect(
        blockFor([('kettle', 1)], [('ih_hob', 1)]),
        EnergyVerdictBlock.tooClose,
      );
    });

    test('wash load vs dishwasher fails the group condition', () {
      expect(
        blockFor([('wash_hot', 1)], [('dishwasher_normal', 1)]),
        EnergyVerdictBlock.differentGroup,
      );
    });

    test('aircon cooling vs heating fails the group condition', () {
      expect(
        blockFor([('aircon_cooling', 1)], [('aircon_heating', 1)]),
        EnergyVerdictBlock.differentGroup,
      );
    });

    test('laptop vs incandescent fails the group condition', () {
      expect(
        blockFor([('laptop_charge', 1)], [('incandescent_bulb', 1)]),
        EnergyVerdictBlock.differentGroup,
      );
    });

    test('oven vs portable heater fails the group condition', () {
      expect(
        blockFor([('oven', 1)], [('portable_electric_heater', 1)]),
        EnergyVerdictBlock.differentGroup,
      );
    });

    test('electric vs gas shower fails the carrier condition', () {
      // The crossover itself: below ~241 g CO2e/kWh electric wins,
      // above it gas does, so the answer is a fact about the grid.
      expect(
        blockFor([('shower_electric', 10)], [('shower_gas', 10)]),
        EnergyVerdictBlock.differentCarrier,
      );
    });
  });

  group('comparisons that must be allowed', () {
    test('line drying vs tumble drying', () {
      // The flagship lesson. Carrier `none` is exempt from the carrier
      // condition because a zero cannot flip with the grid factor.
      expect(
        blockFor([('line_dry', 1)], [('dryer_vented', 1)]),
        EnergyVerdictBlock.none,
      );
    });

    test('resistance vs heat-pump shower inside a larger routine', () {
      // Regression for the union-of-groups bug: identical composition
      // on both sides, one within-group substitution, same carrier.
      // Pooling the groups blocked this as a category error and killed
      // the dataset's headline lever (heat-pump water heating, 4.3x).
      expect(
        blockFor(
          [('shower_electric', 10), ('kettle', 1)],
          [('shower_heatpump', 10), ('kettle', 1)],
        ),
        EnergyVerdictBlock.none,
      );
    });

    test('a shorter gas shower inside a larger routine', () {
      // Regression for the pooled-carrier bug, the carrier twin of the
      // union-of-groups one above: identical carrier make-up on both
      // sides ({gas, electricity}), one gas shower halved, 45.9% apart
      // -- and it was refused as a gas-versus-electric comparison.
      expect(
        blockFor(
          [('shower_gas', 10), ('kettle', 1)],
          [('shower_gas', 5), ('kettle', 1)],
        ),
        EnergyVerdictBlock.none,
      );
    });

    test('bath vs a ten-minute shower on the same carrier', () {
      expect(
        blockFor([('bath_gas', 1)], [('shower_gas', 10)]),
        EnergyVerdictBlock.none,
      );
    });

    test('vented vs heat-pump dryer', () {
      expect(
        blockFor([('dryer_vented', 1)], [('dryer_heatpump', 1)]),
        EnergyVerdictBlock.none,
      );
    });

    test('fan vs an hour of aircon cooling', () {
      // The flagship cooling lesson, buildable since `fan` paired the
      // space_cool singleton (owner call, 2026-08-30). 7.6x apart.
      expect(
        blockFor([('fan', 1)], [('aircon_cooling', 1)]),
        EnergyVerdictBlock.none,
      );
    });

    test('the setpoint self-comparison is intended, not a hole', () {
      // PDR section 3, 2026-08-30: the same entry at two preset
      // quantities is how the setpoint lesson ships. 26 C is 1.35783
      // hourly units against 1.0 at 28 C, a 26% delta.
      expect(
        blockFor([('aircon_cooling', 1.35783)], [('aircon_cooling', 1.0)]),
        EnergyVerdictBlock.none,
      );
    });

    test('cross-unit comparisons inside one group are allowed', () {
      // Owner call, 2026-08-29. `cook` spans a bake cycle, a minute and
      // an hour, so the gate permits ten hours of keep-warm against one
      // bake. Both quantities are the user's own and the arithmetic is
      // true, so there is nothing to refuse. Asserted rather than left
      // implicit: the retired unit-level rule in the old pin 14 was
      // guarding this by accident, and its removal should not read as
      // an oversight.
      expect(
        blockFor([('rice_cook_keepwarm', 1)], [('oven', 1)]),
        EnergyVerdictBlock.none,
      );
      expect(
        blockFor([('standby', 1)], [('phone_charge', 1)]),
        EnergyVerdictBlock.none,
      );
    });
  });

  group('malformed input cannot produce a verdict', () {
    test('NaN units throw rather than defeating the 20% gate', () {
      // Every comparison with NaN is false, so an unguarded NaN sailed
      // through the `deltaPercent < 20` check and the app was permitted
      // to declare a winner on a NaN comparison.
      expect(
        () => EnergyCalculator.routineCo2eGrams(
          byId,
          const [RoutineUsage(behaviorId: 'kettle', units: double.nan)],
          gridFactor: grid,
          gasFactor: gas,
        ),
        throwsArgumentError,
      );
    });

    test('infinite units throw', () {
      expect(
        () => EnergyCalculator.routineCo2eGrams(
          byId,
          const [RoutineUsage(behaviorId: 'kettle', units: double.infinity)],
          gridFactor: grid,
          gasFactor: gas,
        ),
        throwsArgumentError,
      );
    });

    test('an unknown id throws on every path, not just the totals', () {
      const bad = [RoutineUsage(behaviorId: 'does_not_exist', units: 1)];
      expect(
        () => EnergyCalculator.routineCo2eGrams(
          byId,
          bad,
          gridFactor: grid,
          gasFactor: gas,
        ),
        throwsArgumentError,
      );
      // The gate silently skipped unknown ids, dropping a whole
      // option's group and carrier and so becoming more permissive
      // than the totals path it guards.
      expect(
        () => EnergyCalculator.checkVerdict(
          const ComparisonSummary(
            bestIndex: 0,
            worstIndex: 1,
            deltaGrams: 100,
            deltaPercent: 90,
          ),
          byId,
          const [bad, []],
        ),
        throwsArgumentError,
      );
    });
  });

  test('the engine constant matches the dataset metadata', () {
    // Two sources of truth for the 20% bar, previously unpinned: an
    // edit to the JSON changed nothing at runtime.
    final root = rawDatasetRoot('data/app/energy_behaviors.json');
    final metadata = root['metadata'] as Map<String, dynamic>;
    expect(
      (metadata['verdict_min_percent'] as num).toDouble(),
      EnergyCalculator.verdictMinPercent,
    );
  });
}
