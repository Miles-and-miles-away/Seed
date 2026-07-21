import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/transport/transport.dart';

void main() {
  group('prefillKmForMode', () {
    const suggestions = {
      kindGround: 130.0,
      kindActive: 130.0,
      kindFerry: 90.0,
      kindAir: 500.0,
    };

    TransportMode mode(String id, String group) => TransportMode(
      id: id,
      group: group,
      nameEn: id,
      nameJa: '',
      nameEs: '',
      gCo2ePerKm: 100,
    );

    test('ground kind maps to car, bus, and rail groups', () {
      expect(prefillKmForMode(mode('car_x', 'car'), suggestions), 130.0);
      expect(prefillKmForMode(mode('bus_x', 'bus'), suggestions), 130.0);
      expect(prefillKmForMode(mode('rail_x', 'rail'), suggestions), 130.0);
    });

    test('active kind maps to the cycle family', () {
      expect(prefillKmForMode(mode('cycle', 'active'), suggestions), 130.0);
      expect(prefillKmForMode(mode('ebike', 'active'), suggestions), 130.0);
    });

    test('walking is only suggested up to the walk cap', () {
      // 130 km estimate = 100 km straight-line, above the 40 km cap.
      expect(prefillKmForMode(mode('walk', 'active'), suggestions), isNull);
      final short = {kindActive: walkModeMaxKm * groundCircuityFactor};
      expect(
        prefillKmForMode(mode('walk', 'active'), short),
        walkModeMaxKm * groundCircuityFactor,
      );
    });

    test('ferry and air kinds map to water and air groups', () {
      expect(prefillKmForMode(mode('ferry_x', 'water'), suggestions), 90.0);
      expect(prefillKmForMode(mode('flight_x', 'air'), suggestions), 500.0);
    });

    test('unmapped groups are never suggested', () {
      expect(prefillKmForMode(mode('taxi', 'taxi'), suggestions), isNull);
      expect(prefillKmForMode(mode('scooter', 'micro'), suggestions), isNull);
      expect(prefillKmForMode(mode('jet', 'high_impact'), suggestions), isNull);
    });

    test('missing kinds yield no suggestion', () {
      expect(prefillKmForMode(mode('car_x', 'car'), const {}), isNull);
    });
  });
}
