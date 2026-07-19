import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

/// Sanity invariants from Plan/RESEARCH_TRANSPORT.md section 6.
///
/// These pin cross-mode orderings that must survive dataset
/// updates (e.g. a new DEFRA vintage). The two deliberate
/// non-invariants documented there (coach vs national rail;
/// short-haul flight vs solo petrol car) are intentionally NOT
/// tested.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, TransportMode> byId;

  setUpAll(() async {
    byId = TransportCalculator.byId(await loadTransportModes());
  });

  double factor(String id) => byId[id]!.gCo2ePerKm;

  /// Per-passenger figure at a given occupancy for vehicle modes;
  /// the factor itself for per-passenger modes.
  double perPassenger(String id, {int occupants = 1}) {
    final mode = byId[id]!;
    if (!mode.perVehicle) return mode.gCo2ePerKm;
    return mode.gCo2ePerKm / occupants.clamp(1, mode.maxOccupants);
  }

  test('1. active/micro modes beat every motorized per-passenger', () {
    final activeMax = [
      factor('cycle'),
      factor('ebike'),
      factor('escooter_private'),
    ].reduce((a, b) => a > b ? a : b);
    expect(factor('walk'), 0);
    for (final mode in byId.values) {
      if (const {'active', 'micro'}.contains(mode.group)) continue;
      // Documented exception (RESEARCH_TRANSPORT.md sec 6):
      // rail_international (4.46) sits below the e-scooter (6)
      // until the ~2.5x 2026 DEFRA revision lands.
      if (mode.id == 'rail_international') continue;
      final best = perPassenger(mode.id, occupants: mode.maxOccupants);
      expect(
        activeMax,
        lessThan(best),
        reason: '${mode.id} at full occupancy beats active modes',
      );
    }
  });

  test('2. shinkansen at or below tram and national rail', () {
    // Metro deliberately excluded: the 2026 DEFRA revision cuts
    // London Underground ~44% to ~15.4, below shinkansen's 20.
    for (final id in ['tram', 'rail_national']) {
      expect(
        factor('rail_shinkansen'),
        lessThanOrEqualTo(factor(id)),
        reason: id,
      );
    }
  });

  test('3. rail band < city bus < solo average petrol car', () {
    for (final id in ['metro', 'tram', 'rail_national']) {
      expect(factor(id), lessThan(factor('bus_city')), reason: id);
    }
    expect(factor('bus_city'), lessThan(factor('car_petrol_avg')));
  });

  test('4. coach < solo average petrol car', () {
    expect(factor('coach'), lessThan(factor('car_petrol_avg')));
  });

  test('5. electric car < every combustion car variant', () {
    for (final id in [
      'car_petrol_small',
      'car_petrol_medium',
      'car_petrol_large',
      'car_petrol_avg',
      'car_diesel_avg',
      'car_hybrid',
    ]) {
      expect(factor('car_bev'), lessThan(factor(id)), reason: id);
    }
  });

  test('6. long-haul < short-haul < domestic flight per km', () {
    expect(factor('flight_longhaul'), lessThan(factor('flight_shorthaul')));
    expect(factor('flight_shorthaul'), lessThan(factor('flight_domestic')));
  });

  test('7. any full car < any commercial flight per passenger-km', () {
    final flights = ['flight_domestic', 'flight_shorthaul', 'flight_longhaul'];
    for (final mode in byId.values) {
      if (mode.group != 'car' || mode.id == 'motorbike') continue;
      final full = perPassenger(mode.id, occupants: mode.maxOccupants);
      for (final flight in flights) {
        expect(full, lessThan(factor(flight)), reason: '${mode.id} vs $flight');
      }
    }
  });

  test('8. ferry foot passenger < city bus', () {
    expect(factor('ferry_foot'), lessThan(factor('bus_city')));
  });

  test('9. helicopter > every ground mode solo per-passenger', () {
    const airborne = {'air', 'high_impact'};
    for (final mode in byId.values) {
      if (airborne.contains(mode.group)) continue;
      expect(
        factor('helicopter'),
        greaterThan(perPassenger(mode.id)),
        reason: mode.id,
      );
    }
  });

  test('10. private jet > every other mode', () {
    for (final mode in byId.values) {
      if (mode.id == 'private_jet') continue;
      expect(
        factor('private_jet'),
        greaterThan(perPassenger(mode.id)),
        reason: mode.id,
      );
    }
  });

  test('11. international rail < shinkansen', () {
    expect(factor('rail_international'), lessThan(factor('rail_shinkansen')));
  });

  test('12. taxi > city bus', () {
    expect(factor('taxi'), greaterThan(factor('bus_city')));
  });

  test('13. car ferry > foot ferry', () {
    expect(factor('ferry_car'), greaterThan(factor('ferry_foot')));
  });
}
