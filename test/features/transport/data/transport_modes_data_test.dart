import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/transport/transport.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadTransportModes dataset validation', () {
    test('loads exactly $TRANSPORT_MODE_COUNT modes', () async {
      final modes = await loadTransportModes();
      expect(modes.length, TRANSPORT_MODE_COUNT);
    });

    test('ids are unique', () async {
      final modes = await loadTransportModes();
      final ids = modes.map((m) => m.id).toSet();
      expect(ids.length, modes.length);
    });

    test('groups are from the known set', () async {
      const validGroups = {
        'active',
        'micro',
        'car',
        'taxi',
        'bus',
        'rail',
        'water',
        'air',
        'high_impact',
      };
      final modes = await loadTransportModes();
      for (final mode in modes) {
        expect(
          validGroups.contains(mode.group),
          isTrue,
          reason: 'Invalid group "${mode.group}" for ${mode.id}',
        );
      }
    });

    test('all three locale names are present', () async {
      final modes = await loadTransportModes();
      for (final mode in modes) {
        expect(mode.nameEn, isNotEmpty, reason: mode.id);
        expect(mode.nameJa, isNotEmpty, reason: mode.id);
        expect(mode.nameEs, isNotEmpty, reason: mode.id);
      }
    });

    test('factors are >= 0; only human-powered modes are zero', () async {
      const zeroAllowed = {'walk', 'cycle'};
      final modes = await loadTransportModes();
      for (final mode in modes) {
        expect(mode.gCo2ePerKm, greaterThanOrEqualTo(0), reason: mode.id);
        if (!zeroAllowed.contains(mode.id)) {
          expect(mode.gCo2ePerKm, greaterThan(0), reason: mode.id);
        }
      }
    });

    test('every mode has at least one complete source', () async {
      final modes = await loadTransportModes();
      for (final mode in modes) {
        expect(mode.sources, isNotEmpty, reason: mode.id);
        for (final source in mode.sources) {
          expect(source.name, isNotEmpty, reason: mode.id);
          expect(
            source.url,
            startsWith('https://'),
            reason: '${mode.id}: ${source.url}',
          );
          expect(source.quote, isNotEmpty, reason: mode.id);
          expect(source.accessed, isNotEmpty, reason: mode.id);
        }
      }
    });

    test('every mode documents its calculation', () async {
      final modes = await loadTransportModes();
      for (final mode in modes) {
        expect(mode.calculationNotes, isNotEmpty, reason: mode.id);
      }
    });

    test('per-vehicle modes have sane occupancy limits', () async {
      final modes = await loadTransportModes();
      for (final mode in modes) {
        if (mode.perVehicle) {
          expect(mode.maxOccupants, inInclusiveRange(1, 8), reason: mode.id);
        }
        if (mode.group == 'car' && mode.id != 'motorbike') {
          expect(mode.perVehicle, isTrue, reason: mode.id);
          expect(mode.maxOccupants, 4, reason: mode.id);
        }
      }
    });

    test('motorbike stays per-vehicle with pillion capacity', () async {
      final modes = await loadTransportModes();
      final motorbike = modes.firstWhere((m) => m.id == 'motorbike');
      expect(motorbike.perVehicle, isTrue);
      expect(motorbike.maxOccupants, 2);
    });

    test('taxi is per-vehicle, divided by passenger count', () async {
      // Decision R2-D1: vehicle-km 208.06 ships; DEFRA's
      // passenger-km variant embeds a dated occupancy (1.4,
      // L.E.K. 2002) invisibly, so it does not.
      final modes = await loadTransportModes();
      final taxi = modes.firstWhere((m) => m.id == 'taxi');
      expect(taxi.perVehicle, isTrue);
      expect(taxi.maxOccupants, 4);
      expect(taxi.gCo2ePerKm, 208.06);
    });

    test('non-vehicle modes are per passenger-km', () async {
      final modes = await loadTransportModes();
      final nonVehicleGroups = {
        'active',
        'micro',
        'bus',
        'rail',
        'water',
        'air',
        'high_impact',
      };
      for (final mode in modes) {
        if (nonVehicleGroups.contains(mode.group)) {
          expect(mode.perVehicle, isFalse, reason: mode.id);
        }
      }
    });
  });

  group('loadTransportMetadata', () {
    test('carries the scope contract for the methodology sheet', () async {
      final metadata = await loadTransportMetadata();
      expect(metadata['version'], 1);
      expect(metadata['grid_factor_g_per_kwh'], 386);
      final scope = metadata['scope'] as String;
      expect(scope, contains('radiative'));
      expect(scope.toLowerCase(), contains('manufactur'));
      final primary = metadata['primary_source'] as String;
      expect(primary, contains('DEFRA'));
    });
  });
}
