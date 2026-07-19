import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

void main() {
  group('TransportMode.fromJson', () {
    test('parses snake_case keys and nested sources', () {
      final mode = TransportMode.fromJson(const {
        'id': 'car_bev',
        'group': 'car',
        'name_en': 'Electric car',
        'name_ja': '電気自動車',
        'name_es': 'Coche eléctrico',
        'g_co2e_per_km': 73,
        'per_vehicle': true,
        'max_occupants': 4,
        'calculation_notes': '0.188 kWh/km x 386 g/kWh',
        'sources': [
          {
            'name': 'EV Database',
            'url': 'https://ev-database.org/x',
            'quote': 'Average: 188 Wh/km',
            'accessed': '2026-07-17',
          },
        ],
      });
      expect(mode.id, 'car_bev');
      expect(mode.gCo2ePerKm, 73.0);
      expect(mode.perVehicle, isTrue);
      expect(mode.maxOccupants, 4);
      expect(mode.sources, hasLength(1));
      expect(mode.sources.first.name, 'EV Database');
    });

    test('integer factors parse as doubles', () {
      final mode = TransportMode.fromJson(const {
        'id': 'walk',
        'group': 'active',
        'name_en': 'Walking',
        'name_ja': '徒歩',
        'name_es': 'Caminar',
        'g_co2e_per_km': 0,
      });
      expect(mode.gCo2ePerKm, isA<double>());
      expect(mode.gCo2ePerKm, 0.0);
    });

    test('missing optional fields fall back to defaults', () {
      final mode = TransportMode.fromJson(const {
        'id': 'metro',
        'group': 'rail',
        'name_en': 'Metro',
        'name_ja': '地下鉄',
        'name_es': 'Metro',
        'g_co2e_per_km': 27.8,
      });
      expect(mode.perVehicle, isFalse);
      expect(mode.maxOccupants, 1);
      expect(mode.calculationNotes, isEmpty);
      expect(mode.sources, isEmpty);
    });
  });

  group('TransportMode.name', () {
    test('resolves locale with English fallback', () {
      final mode = TransportMode.fromJson(const {
        'id': 'cycle',
        'group': 'active',
        'name_en': 'Cycling',
        'name_ja': '自転車',
        'name_es': 'Bicicleta',
        'g_co2e_per_km': 16,
      });
      expect(mode.name('ja'), '自転車');
      expect(mode.name('es'), 'Bicicleta');
      expect(mode.name('en'), 'Cycling');
      expect(mode.name('fr'), 'Cycling');
    });
  });
}
