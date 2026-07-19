import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

TransportMode _mode({
  String id = 'test_mode',
  double gCo2ePerKm = 100,
  bool perVehicle = false,
  int maxOccupants = 1,
}) {
  return TransportMode(
    id: id,
    group: 'rail',
    nameEn: 'Test',
    nameJa: 'テスト',
    nameEs: 'Prueba',
    gCo2ePerKm: gCo2ePerKm,
    perVehicle: perVehicle,
    maxOccupants: maxOccupants,
  );
}

void main() {
  group('legCo2eGrams', () {
    test('per-passenger mode multiplies factor by distance', () {
      final mode = _mode(gCo2ePerKm: 20);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 515);
      expect(TransportCalculator.legCo2eGrams(mode, leg), 10300);
    });

    test('per-vehicle mode divides by occupants', () {
      final car = _mode(gCo2ePerKm: 162.72, perVehicle: true, maxOccupants: 4);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 10, occupants: 2);
      expect(TransportCalculator.legCo2eGrams(car, leg), closeTo(813.6, 1e-9));
    });

    test('occupants above maxOccupants are clamped down', () {
      final car = _mode(gCo2ePerKm: 200, perVehicle: true, maxOccupants: 4);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 10, occupants: 9);
      expect(TransportCalculator.legCo2eGrams(car, leg), 500);
    });

    test('occupants below 1 are clamped up to 1', () {
      final car = _mode(gCo2ePerKm: 200, perVehicle: true, maxOccupants: 4);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 10, occupants: 0);
      expect(TransportCalculator.legCo2eGrams(car, leg), 2000);
    });

    test('maxOccupants below 1 degrades to solo instead of throwing', () {
      // Guards the max(1, ...) in the occupancy clamp: an int
      // clamp over an inverted range throws.
      final broken = _mode(gCo2ePerKm: 200, perVehicle: true, maxOccupants: 0);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 10, occupants: 3);
      expect(TransportCalculator.legCo2eGrams(broken, leg), 2000);
    });

    test('occupants are ignored for per-passenger modes', () {
      final bus = _mode(gCo2ePerKm: 90);
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 10, occupants: 4);
      expect(TransportCalculator.legCo2eGrams(bus, leg), 900);
    });

    test('zero distance yields zero', () {
      final mode = _mode();
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: 0);
      expect(TransportCalculator.legCo2eGrams(mode, leg), 0);
    });

    test('negative distance throws', () {
      final mode = _mode();
      const leg = JourneyLeg(modeId: 'test_mode', distanceKm: -1);
      expect(
        () => TransportCalculator.legCo2eGrams(mode, leg),
        throwsArgumentError,
      );
    });
  });

  group('journeyCo2eGrams', () {
    test('sums legs across modes', () {
      final modes = TransportCalculator.byId([
        _mode(id: 'taxi', gCo2ePerKm: 170, perVehicle: true, maxOccupants: 4),
        _mode(id: 'flight', gCo2ePerKm: 229.28),
      ]);
      const legs = [
        JourneyLeg(modeId: 'taxi', distanceKm: 20),
        JourneyLeg(modeId: 'flight', distanceKm: 515),
      ];
      expect(
        TransportCalculator.journeyCo2eGrams(modes, legs),
        closeTo(20 * 170 + 515 * 229.28, 1e-9),
      );
    });

    test('empty journey is zero', () {
      expect(TransportCalculator.journeyCo2eGrams(const {}, const []), 0);
    });

    test('unknown mode id throws', () {
      final modes = TransportCalculator.byId([_mode(id: 'known')]);
      const legs = [JourneyLeg(modeId: 'unknown', distanceKm: 1)];
      expect(
        () => TransportCalculator.journeyCo2eGrams(modes, legs),
        throwsArgumentError,
      );
    });
  });

  group('real dataset journeys', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test(
      'Tokyo-Osaka comparison: shinkansen beats flying and driving',
      () async {
        final byId = TransportCalculator.byId(await loadTransportModes());
        const rail = [JourneyLeg(modeId: 'rail_shinkansen', distanceKm: 515)];
        const fly = [
          JourneyLeg(modeId: 'car_petrol_avg', distanceKm: 20),
          JourneyLeg(modeId: 'flight_domestic', distanceKm: 515),
        ];
        const drive = [JourneyLeg(modeId: 'car_petrol_avg', distanceKm: 500)];
        final railTotal = TransportCalculator.journeyCo2eGrams(byId, rail);
        final flyTotal = TransportCalculator.journeyCo2eGrams(byId, fly);
        final driveTotal = TransportCalculator.journeyCo2eGrams(byId, drive);
        expect(railTotal, lessThan(driveTotal));
        expect(driveTotal, lessThan(flyTotal));
        expect(railTotal, closeTo(10300, 1));
      },
    );
  });
}
