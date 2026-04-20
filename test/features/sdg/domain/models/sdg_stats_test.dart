import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/domain/models/sdg_stats.dart';

void main() {
  group('SdgStats', () {
    test('defaults counts and co2 to zero', () {
      const s = SdgStats(sdgNumber: 5);

      expect(s.actionsLogged, 0);
      expect(s.co2SavedGrams, 0);
    });

    test('fromJson parses all fields', () {
      final s = SdgStats.fromJson({
        'sdgNumber': 3,
        'actionsLogged': 7,
        'co2SavedGrams': 2100,
      });

      expect(s.sdgNumber, 3);
      expect(s.actionsLogged, 7);
      expect(s.co2SavedGrams, 2100);
    });

    test('equality is value-based (Freezed)', () {
      const a = SdgStats(sdgNumber: 3, actionsLogged: 7, co2SavedGrams: 100);
      const b = SdgStats(sdgNumber: 3, actionsLogged: 7, co2SavedGrams: 100);

      expect(a, equals(b));
    });
  });
}
