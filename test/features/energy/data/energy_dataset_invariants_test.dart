import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Sanity invariants from Plan/RESEARCH_ENERGY.md section 6.
///
/// These are DATA PINS for the shipped values, not truth claims.
/// Several are thin by design and the research doc says so: each must
/// be re-derived at the next data pass rather than assumed to survive
/// it. Where a pin is thin, the margin is stated in the comment.
///
/// The never-pin list in that section is deliberately NOT tested:
/// kettle vs gas hob and hand-wash-gas vs dishwasher (cross-carrier, so
/// they flip with the grid factor), kettle vs IH (a 0.3% tie), wash load
/// vs dishwasher, aircon cooling vs heating, laptop vs incandescent, and
/// oven vs portable heater (all category errors). Those are blocked
/// structurally by the gating rule, which has its own tests.
void main() {
  late Map<String, Map<String, dynamic>> byId;

  setUpAll(() {
    final raw = File('data/app/energy_behaviors.json').readAsStringSync();
    final root = json.decode(raw) as Map<String, dynamic>;
    final behaviors = (root['behaviors'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    byId = {for (final b in behaviors) b['id'] as String: b};
  });

  double kwh(String id) {
    final behavior = byId[id];
    expect(behavior, isNotNull, reason: 'missing behavior $id');
    return (behavior!['kwh_per_unit'] as num).toDouble();
  }

  test('pin 1: bath_electric is the electricity maximum per single use', () {
    // Margin vs dryer_vented 4.5 is +26%. Re-derive before adding any
    // entry above 4.5.
    //
    // Scoped to electricity on purpose. A gas kWh is fuel input and an
    // electric kWh is delivered energy, so ranking the two together is
    // not meaningful: bath_gas is 7.53 kWh for the same hot water,
    // purely because it is divided by a 0.756 boiler efficiency. The
    // pin's own "#2 dryer_vented" ranking is what shows it meant the
    // electricity subset.
    final singleUse = byId.values.where(
      (b) => b['unit'] == 'use' && b['carrier'] == 'electricity',
    );
    final max = singleUse
        .map((b) => (b['kwh_per_unit'] as num).toDouble())
        .reduce((a, b) => a > b ? a : b);
    expect(kwh('bath_electric'), max);
    expect(kwh('bath_electric'), greaterThan(kwh('dryer_vented')));
  });

  test('pin 2: the hot-water chain holds', () {
    // bath > 10 x shower > kettle > phone charge. Thinnest link is
    // bath vs a 10-minute shower at +129%.
    expect(kwh('bath_electric'), greaterThan(10 * kwh('shower_electric')));
    expect(10 * kwh('shower_electric'), greaterThan(kwh('kettle')));
    expect(kwh('kettle'), greaterThan(kwh('phone_charge')));
  });

  test('pin 3: resistance shower beats heat-pump shower by over 4x', () {
    // THIN: +7.5% margin, and the COP-4.3 mean is the fragile input.
    expect(kwh('shower_electric'), greaterThan(4 * kwh('shower_heatpump')));
  });

  test('pin 4: vented dryer is over 2x the heat-pump dryer', () {
    // THIN: +10%, source-backed. Flagged in the research as the pin
    // most likely to move.
    expect(kwh('dryer_vented'), greaterThan(2 * kwh('dryer_heatpump')));
  });

  test('pin 5: the wash-temperature chain holds', () {
    // hot > warm > 2 x cold. Thinnest link hot vs warm at +31%.
    expect(kwh('wash_hot'), greaterThan(kwh('wash_warm')));
    expect(kwh('wash_warm'), greaterThan(2 * kwh('wash_cold')));
  });

  test('pin 6: portable electric heater is over 5x the kotatsu', () {
    // Actual ratio 8.0x. The plan's "~10x" did not survive the
    // research, and copy must ship 8x, never 10x.
    expect(kwh('portable_electric_heater'), greaterThan(5 * kwh('kotatsu')));
    final ratio = kwh('portable_electric_heater') / kwh('kotatsu');
    expect(ratio, closeTo(8.0, 0.1));
    expect(ratio, lessThan(10), reason: 'copy must not claim 10x');
  });

  test('pin 7: portable heater is over 4x aircon heating', () {
    // The flagship heating lesson: actual ratio 4.98x, +24% margin.
    expect(
      kwh('portable_electric_heater'),
      greaterThan(4 * kwh('aircon_heating')),
    );
  });

  test('pin 8: incandescent is over 4x the LED', () {
    // Actual ratio 7.06x, +76% margin.
    expect(kwh('incandescent_bulb'), greaterThan(4 * kwh('led_bulb')));
  });

  test('pin 9: the eco programme really is the cheaper dishwasher cycle', () {
    // Replaced the dishwasher-vs-hand-washing pin when the hand-washing
    // rows were withdrawn (2026-09-02): a single hand-wash figure
    // implied a precision that technique does not allow.
    expect(kwh('dishwasher_eco'), lessThan(kwh('dishwasher_normal')));
  });

  test('pin 10: heat beats light and computation by an order of magnitude', () {
    // The research prefers dryer > 10 x tv (+469%) over the thin
    // dryer > 50 x tv (+14%).
    expect(kwh('dryer_vented'), greaterThan(10 * kwh('tv')));
  });

  test('pin 11: ten hours of keep-warm exceeds one cook cycle', () {
    // The foundation of the 4-hour rule the rice-cooker copy ships.
    expect(kwh('rice_cook_keepwarm'), greaterThan(kwh('rice_cooker')));
  });

  test('pin 16: aircon cooling is over 5x the fan', () {
    // The flagship cooling lesson, buildable in-app since the fan
    // entry paired the space_cool singleton. Actual ratio 7.62x.
    expect(kwh('aircon_cooling'), greaterThan(5 * kwh('fan')));
  });
}
