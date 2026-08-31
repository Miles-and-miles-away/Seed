import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/energy/data/models/energy_behavior_model.dart';
import 'package:seed_app/features/energy/data/models/routine_usage_model.dart';
import 'package:seed_app/features/energy/domain/services/energy_calculator.dart';
import 'package:seed_app/shared/domain/carbon_comparison.dart';

/// Engine arithmetic and the decision-E2 comparison gating (Phase 8.14).
///
/// Uses hand-built behaviors, not the shipped dataset: this file tests
/// the maths and the gating rules, and must not fail when a researched
/// value legitimately moves.
void main() {
  const grid = 458.0;
  const gas = 182.0;

  EnergyBehavior b(
    String id, {
    required String group,
    required double kwh,
    EnergyCarrier carrier = EnergyCarrier.electricity,
    EnergyUnit unit = EnergyUnit.use,
  }) => EnergyBehavior(
    id: id,
    comparableGroup: group,
    carrier: carrier,
    unit: unit,
    kwhPerUnit: kwh,
    nameEn: id,
    nameJa: id,
    nameEs: id,
  );

  final electric = b('electric', group: 'g', kwh: 2);
  final gasEntry = b('gas', group: 'g', carrier: EnergyCarrier.gas, kwh: 2);
  final zero = b('zero', group: 'g', carrier: EnergyCarrier.none, kwh: 0);
  final byId = EnergyCalculator.byId([electric, gasEntry, zero]);

  double usage(EnergyBehavior behavior, double units) =>
      EnergyCalculator.usageCo2eGrams(
        behavior,
        RoutineUsage(behaviorId: behavior.id, units: units),
        gridFactor: grid,
        gasFactor: gas,
      );

  group('usageCo2eGrams', () {
    test('multiplies kWh by units by the electricity factor', () {
      expect(usage(electric, 3), 2 * 3 * grid);
    });

    test('uses the gas factor for a gas carrier', () {
      expect(usage(gasEntry, 3), 2 * 3 * gas);
      // The whole point of two factors: same kWh, different carbon.
      expect(usage(gasEntry, 3), lessThan(usage(electric, 3)));
    });

    test('a none carrier emits nothing however many units', () {
      expect(usage(zero, 99), 0);
    });

    test('zero units emits nothing', () {
      expect(usage(electric, 0), 0);
    });

    test('rejects negative units', () {
      expect(() => usage(electric, -1), throwsArgumentError);
    });
  });

  group('routineCo2eGrams', () {
    test('sums across carriers', () {
      final total = EnergyCalculator.routineCo2eGrams(
        byId,
        const [
          RoutineUsage(behaviorId: 'electric', units: 1),
          RoutineUsage(behaviorId: 'gas', units: 1),
        ],
        gridFactor: grid,
        gasFactor: gas,
      );
      expect(total, 2 * grid + 2 * gas);
    });

    test('an empty routine is zero, not an error', () {
      expect(
        EnergyCalculator.routineCo2eGrams(
          byId,
          const [],
          gridFactor: grid,
          gasFactor: gas,
        ),
        0,
      );
    });

    test('throws on an unknown behavior id', () {
      expect(
        () => EnergyCalculator.routineCo2eGrams(
          byId,
          const [RoutineUsage(behaviorId: 'nope', units: 1)],
          gridFactor: grid,
          gasFactor: gas,
        ),
        throwsArgumentError,
      );
    });
  });

  group('routineKwh', () {
    test('sums kWh across carriers, factor-blind', () {
      // The E7 basis: a kWh sum cancels the carrier factor, so the
      // ratio and the phone-charge equivalency built on it hold on
      // every grid.
      final total = EnergyCalculator.routineKwh(byId, const [
        RoutineUsage(behaviorId: 'electric', units: 1),
        RoutineUsage(behaviorId: 'gas', units: 2),
      ]);
      expect(total, 2 * 1 + 2 * 2);
    });

    test('shares the usageCo2eGrams input contract', () {
      // NaN, infinity, negatives and unknown ids all throw, exactly
      // like the grams path -- an unguarded kWh sum would let NaN
      // reach the ratio headline.
      for (final units in [double.nan, double.infinity, -1.0]) {
        expect(
          () => EnergyCalculator.routineKwh(byId, [
            RoutineUsage(behaviorId: 'electric', units: units),
          ]),
          throwsArgumentError,
          reason: '$units',
        );
      }
      expect(
        () => EnergyCalculator.routineKwh(byId, const [
          RoutineUsage(behaviorId: 'nope', units: 1),
        ]),
        throwsArgumentError,
      );
    });
  });

  group('comparison gating (decision E2)', () {
    /// Builds the summary the way the screen does.
    EnergyVerdictCheck check(
      List<List<RoutineUsage>> options,
      Map<String, EnergyBehavior> behaviors,
    ) {
      final totals = [
        for (final o in options)
          EnergyCalculator.routineCo2eGrams(
            behaviors,
            o,
            gridFactor: grid,
            gasFactor: gas,
          ),
      ];
      return EnergyCalculator.checkVerdict(
        compareTotals(totals)!,
        behaviors,
        options,
      );
    }

    test('same group, same carrier, big delta: verdict allowed', () {
      final small = b('small', group: 'hot_water', kwh: 1);
      final big = b('big', group: 'hot_water', kwh: 5);
      final map = EnergyCalculator.byId([small, big]);
      final result = check([
        const [RoutineUsage(behaviorId: 'small', units: 1)],
        const [RoutineUsage(behaviorId: 'big', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.none);
    });

    test('condition 1: different comparable_group blocks the verdict', () {
      // A wash load against a dishwasher load is a category error, and
      // no percentage delta catches a category error.
      final wash = b('wash', group: 'laundry_wash', kwh: 1.7);
      final dish = b('dish', group: 'dishes', kwh: 0.85);
      final map = EnergyCalculator.byId([wash, dish]);
      final result = check([
        const [RoutineUsage(behaviorId: 'wash', units: 1)],
        const [RoutineUsage(behaviorId: 'dish', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.differentGroup);
    });

    test('condition 2: mixing gas and electricity blocks the verdict', () {
      // The kettle-vs-gas-hob ordering flipped when the grid factor
      // moved 386 -> 458. This rule is why that changed no user-facing
      // claim.
      final kettle = b('kettle', group: 'boil', kwh: 0.116278);
      final hob = b(
        'gas_hob',
        group: 'boil',
        carrier: EnergyCarrier.gas,
        kwh: 0.282389,
      );
      final map = EnergyCalculator.byId([kettle, hob]);
      final result = check([
        const [RoutineUsage(behaviorId: 'kettle', units: 1)],
        const [RoutineUsage(behaviorId: 'gas_hob', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.differentCarrier);
    });

    test('condition 3: a delta under 20% blocks the verdict', () {
      // Kettle vs induction hob: 0.3% apart. The tie is the honest
      // answer.
      final kettle = b('kettle', group: 'boil', kwh: 0.116278);
      final ih = b('ih_hob', group: 'boil', kwh: 0.116598);
      final map = EnergyCalculator.byId([kettle, ih]);
      final result = check([
        const [RoutineUsage(behaviorId: 'kettle', units: 1)],
        const [RoutineUsage(behaviorId: 'ih_hob', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.tooClose);
      expect(result.requiredPercent, 20);
    });

    test('20% exactly is enough', () {
      // 1145 -> 916 is a 20.0% reduction; the bar is >=, not >.
      final options = [
        [const RoutineUsage(behaviorId: 'electric', units: 1)],
        [const RoutineUsage(behaviorId: 'electric', units: 1.25)],
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
      expect(compareTotals(totals)!.deltaPercent, closeTo(20, 1e-9));
      expect(check(options, byId).block, EnergyVerdictBlock.none);
    });

    test('just under 20% still blocks', () {
      // 0.24 / 1.24 = 19.35%: pins the bar from below, so moving it
      // to 19 fails here and moving it to 21 fails the exact-20 pin.
      final options = [
        [const RoutineUsage(behaviorId: 'electric', units: 1)],
        [const RoutineUsage(behaviorId: 'electric', units: 1.24)],
      ];
      expect(check(options, byId).block, EnergyVerdictBlock.tooClose);
    });

    test('an all-zero comparison reads too close, never a winner', () {
      // line_dry in both columns is reachable in the UI. worst <= 0
      // zeroes deltaPercent, both carrier sets are empty, and the
      // gate lands on tooClose -- safe today by the shape of the
      // carrier filter, pinned so it stays safe on purpose.
      final options = [
        [const RoutineUsage(behaviorId: 'zero', units: 1)],
        [const RoutineUsage(behaviorId: 'zero', units: 2)],
      ];
      expect(check(options, byId).block, EnergyVerdictBlock.tooClose);
    });

    test('identical carrier make-up on both sides is comparable', () {
      // Pooling the carriers asked "is more than one present at all",
      // so a gas shower against a shorter gas shower was blocked the
      // moment a kettle sat on both sides -- and the copy then told
      // the user one side runs on gas and the other on electricity.
      final shower = b(
        'shower_gas',
        group: 'hot_water',
        carrier: EnergyCarrier.gas,
        kwh: 0.3,
        unit: EnergyUnit.minute,
      );
      final kettle = b('kettle', group: 'boil', kwh: 0.116278);
      final map = EnergyCalculator.byId([shower, kettle]);
      final result = check([
        const [
          RoutineUsage(behaviorId: 'shower_gas', units: 10),
          RoutineUsage(behaviorId: 'kettle', units: 1),
        ],
        const [
          RoutineUsage(behaviorId: 'shower_gas', units: 5),
          RoutineUsage(behaviorId: 'kettle', units: 1),
        ],
      ], map);
      expect(result.block, EnergyVerdictBlock.none);
    });

    test('a carrier swap inside a shared routine still blocks', () {
      // The rule the pooling was standing in for: same groups, same
      // kettle, but one shower is gas and the other electric.
      final gasShower = b(
        'shower_gas',
        group: 'hot_water',
        carrier: EnergyCarrier.gas,
        kwh: 0.3,
        unit: EnergyUnit.minute,
      );
      final electricShower = b(
        'shower_electric',
        group: 'hot_water',
        kwh: 0.248111,
        unit: EnergyUnit.minute,
      );
      final kettle = b('kettle', group: 'boil', kwh: 0.116278);
      final map = EnergyCalculator.byId([gasShower, electricShower, kettle]);
      final result = check([
        const [
          RoutineUsage(behaviorId: 'shower_gas', units: 10),
          RoutineUsage(behaviorId: 'kettle', units: 1),
        ],
        const [
          RoutineUsage(behaviorId: 'shower_electric', units: 10),
          RoutineUsage(behaviorId: 'kettle', units: 1),
        ],
      ], map);
      expect(result.block, EnergyVerdictBlock.differentCarrier);
    });

    test('carrier none does not count as a second carrier', () {
      // Line drying against a tumble dryer is the flagship comparison
      // of the feature. A zero emits zero on every grid, so it cannot
      // flip the way gas-vs-electric can, and must stay comparable.
      final dryer = b('dryer', group: 'laundry_dry', kwh: 4.5);
      final line = b(
        'line_dry',
        group: 'laundry_dry',
        carrier: EnergyCarrier.none,
        kwh: 0,
      );
      final map = EnergyCalculator.byId([dryer, line]);
      final result = check([
        const [RoutineUsage(behaviorId: 'line_dry', units: 1)],
        const [RoutineUsage(behaviorId: 'dryer', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.none);
    });

    test('routines with different group composition block the verdict', () {
      // Groups are compared per option, not pooled: two routines with
      // the SAME composition are comparable (see the dataset gating
      // test's heat-pump case). This one differs -- B has no laundry --
      // so the two sides are about different things.
      //
      // Users may build any routine they like; the gating governs what
      // the app asserts, not what the user may look at.
      final shower = b('shower', group: 'hot_water', kwh: 2.5);
      final wash = b('wash', group: 'laundry_wash', kwh: 1.7);
      final map = EnergyCalculator.byId([shower, wash]);
      final result = check([
        const [
          RoutineUsage(behaviorId: 'shower', units: 1),
          RoutineUsage(behaviorId: 'wash', units: 1),
        ],
        const [RoutineUsage(behaviorId: 'shower', units: 1)],
      ], map);
      expect(result.block, EnergyVerdictBlock.differentGroup);
    });
  });
}
