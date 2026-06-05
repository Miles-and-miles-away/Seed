import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/progress/data/impact_equivalencies_data.dart';
import 'package:seed_app/features/progress/domain/entities/impact_equivalency.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';

/// Fixture mirroring the production JSON so tests stay deterministic
/// without touching rootBundle.
const _fixture = <EquivalencyMetadata>[
  EquivalencyMetadata(
    type: EquivalencyType.trees,
    gramsPerUnit: 21000,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.carKm,
    gramsPerUnit: 200,
    sourceName: 'DEFRA',
    sourceUrl: 'https://example.org/defra',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.phoneCharges,
    gramsPerUnit: 8,
    sourceName: 'EPA',
    sourceUrl: 'https://example.org/epa',
  ),
  EquivalencyMetadata(
    type: EquivalencyType.burgers,
    gramsPerUnit: 3000,
    sourceName: 'OWID',
    sourceUrl: 'https://example.org/owid',
  ),
];

void main() {
  group('computeImpactEquivalencies', () {
    test('returns one equivalency per metadata entry, in order', () {
      final results = computeImpactEquivalencies(0, _fixture);

      expect(results.length, 4);
      expect(results[0].type, EquivalencyType.trees);
      expect(results[1].type, EquivalencyType.carKm);
      expect(results[2].type, EquivalencyType.phoneCharges);
      expect(results[3].type, EquivalencyType.burgers);
    });

    test('zero grams yields zero values for every type', () {
      final results = computeImpactEquivalencies(0, _fixture);
      for (final eq in results) {
        expect(eq.value, 0.0);
      }
    });

    test('values match documented conversion factors', () {
      // 21,000 g of CO2 = 1 tree-year, 105 km, 2625 charges, 7 burgers.
      final results = computeImpactEquivalencies(21000, _fixture);
      final byType = {for (final e in results) e.type: e.value};

      expect(byType[EquivalencyType.trees], 1.0);
      expect(byType[EquivalencyType.carKm], 105.0);
      expect(byType[EquivalencyType.phoneCharges], 2625.0);
      expect(byType[EquivalencyType.burgers], 7.0);
    });

    test('values scale linearly with input', () {
      final small = computeImpactEquivalencies(1000, _fixture);
      final big = computeImpactEquivalencies(10000, _fixture);
      for (var i = 0; i < small.length; i++) {
        expect(big[i].value, closeTo(small[i].value * 10, 1e-9));
      }
    });

    test('produces sub-unit values for tiny totals', () {
      // 4,200 g => 0.2 tree-years; meaningful for early users.
      final results = computeImpactEquivalencies(4200, _fixture);
      final byType = {for (final e in results) e.type: e.value};
      expect(byType[EquivalencyType.trees], closeTo(0.2, 1e-9));
    });

    test('clamps negative totals to zero', () {
      // Defensive: an undo flow could briefly push totals negative;
      // we should never surface "-1.0 trees" to the user.
      final results = computeImpactEquivalencies(-5000, _fixture);
      for (final eq in results) {
        expect(eq.value, 0.0);
      }
    });

    test('respects metadata order regardless of enum order', () {
      // If the JSON shuffles, the calculator should follow.
      final shuffled = [_fixture[2], _fixture[0]];
      final results = computeImpactEquivalencies(16000, shuffled);
      expect(results[0].type, EquivalencyType.phoneCharges);
      expect(results[1].type, EquivalencyType.trees);
    });
  });

  group('EquivalencyMetadata.fromJson', () {
    test('parses a well-formed JSON map', () {
      final m = EquivalencyMetadata.fromJson({
        'type': 'trees',
        'gramsPerUnit': 21000,
        'sourceName': 'US EPA',
        'sourceUrl': 'https://www.epa.gov/example',
      });
      expect(m.type, EquivalencyType.trees);
      expect(m.gramsPerUnit, 21000);
      expect(m.sourceName, 'US EPA');
      expect(m.sourceUrl, 'https://www.epa.gov/example');
    });

    test('accepts integer gramsPerUnit as double', () {
      final m = EquivalencyMetadata.fromJson({
        'type': 'carKm',
        'gramsPerUnit': 200,
        'sourceName': 'x',
        'sourceUrl': 'https://example.org',
      });
      expect(m.gramsPerUnit, 200.0);
    });
  });
}
