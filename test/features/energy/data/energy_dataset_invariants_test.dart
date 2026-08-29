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

  test('pin 9: a dishwasher cycle beats washing up by hand', () {
    // True for ELECTRIC water only -- the gas hand-wash comparison is
    // on the never-pin list because it is cross-carrier.
    expect(kwh('dishwasher_normal'), lessThan(kwh('washup_electric')));
  });

  test('pin 10: heat beats light and computation by an order of magnitude', () {
    // The research prefers dryer > 10 x tv (+469%) over the thin
    // dryer > 50 x tv (+14%).
    expect(kwh('dryer_vented'), greaterThan(10 * kwh('tv')));
  });

  test('pin 11: ten hours of keep-warm exceeds one cook cycle', () {
    // The foundation of the 4-hour rule the rice-cooker copy ships.
    expect(10 * kwh('rice_keepwarm'), greaterThan(kwh('rice_cooker')));
  });

  test('pin 13: line_dry is the only zero-carrier, zero-kWh entry', () {
    final zeros = byId.entries.where(
      (e) => (e.value['kwh_per_unit'] as num) == 0,
    );
    expect(zeros.map((e) => e.key), ['line_dry']);
    expect(byId['line_dry']!['carrier'], 'none');
  });

  test('pin 15: assembled judgment-call values ship exactly', () {
    // These are unreachable by any ordering pin, so without this test a
    // silent revert to a nameplate or a rated figure would pass the
    // whole suite. Each parenthetical is the wrong value a well-meaning
    // future edit would reach for.
    expect(kwh('kotatsu'), 0.15); // not the 0.3-0.6 nameplate
    expect(kwh('portable_electric_heater'), 1.2); // not 1.5
    expect(kwh('standby'), 0.8); // not 1.78
    expect(kwh('gas_hob'), 0.282389); // efficiency 0.35, not 0.32 or 0.42
    expect(kwh('dryer_vented'), 4.5); // not the model-specific 4.63
    expect(kwh('oven'), 0.82); // EU 60-70 L midpoint, not 1.0/hour or 2.0
    // METI measured, NOT the Panasonic JIS rated 0.435 / 0.455.
    expect(kwh('aircon_cooling'), 0.167679);
    expect(kwh('aircon_heating'), 0.241006);
  });

  test('the oven stays per bake cycle', () {
    // No per-hour oven figure exists anywhere: DOE never adopted an
    // active-mode standard and ENERGY STAR does not certify ovens. An
    // edit to `hour` would be inventing one.
    expect(byId['oven']!['unit'], 'use');
  });
}
