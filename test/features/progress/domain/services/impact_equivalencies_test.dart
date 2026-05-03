import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';

void main() {
  group('ImpactEquivalencies.from', () {
    test('returns four equivalencies in fixed order', () {
      final results = ImpactEquivalencies.from(0);

      expect(results.length, 4);
      expect(results[0].type, EquivalencyType.trees);
      expect(results[1].type, EquivalencyType.carKm);
      expect(results[2].type, EquivalencyType.phoneCharges);
      expect(results[3].type, EquivalencyType.burgers);
    });

    test('zero grams yields zero values for every type', () {
      final results = ImpactEquivalencies.from(0);
      for (final eq in results) {
        expect(eq.value, 0.0);
      }
    });

    test('values match documented conversion factors', () {
      // 21,000 g of CO2 = 1 tree-year, 105 km, 2625 charges, 7 burgers.
      final results = ImpactEquivalencies.from(21000);
      final byType = {for (final e in results) e.type: e.value};

      expect(byType[EquivalencyType.trees], 1.0);
      expect(byType[EquivalencyType.carKm], 105.0);
      expect(byType[EquivalencyType.phoneCharges], 2625.0);
      expect(byType[EquivalencyType.burgers], 7.0);
    });

    test('values scale linearly with input', () {
      final small = ImpactEquivalencies.from(1000);
      final big = ImpactEquivalencies.from(10000);
      for (var i = 0; i < small.length; i++) {
        expect(big[i].value, closeTo(small[i].value * 10, 1e-9));
      }
    });

    test('produces sub-unit values for tiny totals', () {
      // 4,200 g => 0.2 tree-years; meaningful for early users.
      final results = ImpactEquivalencies.from(4200);
      final byType = {for (final e in results) e.type: e.value};
      expect(byType[EquivalencyType.trees], closeTo(0.2, 1e-9));
    });
  });
}
