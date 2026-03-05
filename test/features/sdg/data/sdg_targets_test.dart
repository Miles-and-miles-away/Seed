import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';

void main() {
  group('SdgTarget', () {
    test('creates target with code and description', () {
      const target = SdgTarget(
        code: '1.1',
        description: 'End extreme poverty',
      );

      expect(target.code, '1.1');
      expect(target.description, 'End extreme poverty');
    });

    test('getDescription returns EN by default', () {
      const target = SdgTarget(
        code: '1.1',
        description: 'End poverty',
        descriptionJa: 'JA text',
        descriptionEs: 'ES text',
      );
      expect(target.getDescription('en'), 'End poverty');
      expect(target.getDescription('fr'), 'End poverty');
    });

    test('getDescription returns JA for ja locale', () {
      const target = SdgTarget(
        code: '1.1',
        description: 'End poverty',
        descriptionJa: 'JA text',
        descriptionEs: 'ES text',
      );
      expect(target.getDescription('ja'), 'JA text');
    });

    test('getDescription returns ES for es locale', () {
      const target = SdgTarget(
        code: '1.1',
        description: 'End poverty',
        descriptionJa: 'JA text',
        descriptionEs: 'ES text',
      );
      expect(target.getDescription('es'), 'ES text');
    });

    test('getDescription falls back to EN if empty', () {
      const target = SdgTarget(
        code: '1.1',
        description: 'End poverty',
      );
      expect(target.getDescription('ja'), 'End poverty');
      expect(target.getDescription('es'), 'End poverty');
    });
  });

  group('sdgTargets', () {
    test('contains all 17 goals', () {
      expect(sdgTargets.length, 17);
    });

    test('keys are 1 through 17', () {
      for (var i = 1; i <= 17; i++) {
        expect(
          sdgTargets.containsKey(i),
          isTrue,
          reason: 'Missing goal $i',
        );
      }
    });

    test('each goal has at least one target', () {
      for (final entry in sdgTargets.entries) {
        expect(
          entry.value,
          isNotEmpty,
          reason: 'Goal ${entry.key} has no targets',
        );
      }
    });

    test('total target count is 169', () {
      final total =
          sdgTargets.values.fold<int>(0, (sum, list) => sum + list.length);
      expect(total, 169);
    });

    test('expected target counts per goal', () {
      const expectedCounts = <int, int>{
        1: 7,
        2: 8,
        3: 13,
        4: 10,
        5: 9,
        6: 8,
        7: 5,
        8: 12,
        9: 8,
        10: 10,
        11: 10,
        12: 11,
        13: 5,
        14: 10,
        15: 12,
        16: 12,
        17: 19,
      };
      for (final entry in expectedCounts.entries) {
        expect(
          sdgTargets[entry.key]!.length,
          entry.value,
          reason: 'Goal ${entry.key} expected ${entry.value}'
              ' targets',
        );
      }
    });

    test('all targets have non-empty codes', () {
      for (final entry in sdgTargets.entries) {
        for (final target in entry.value) {
          expect(
            target.code,
            isNotEmpty,
            reason: 'Goal ${entry.key} has empty target code',
          );
        }
      }
    });

    test('all targets have non-empty descriptions', () {
      for (final entry in sdgTargets.entries) {
        for (final target in entry.value) {
          expect(
            target.description,
            isNotEmpty,
            reason: 'Target ${target.code} has empty '
                'description',
          );
        }
      }
    });

    test('target codes start with goal number', () {
      for (final entry in sdgTargets.entries) {
        for (final target in entry.value) {
          expect(
            target.code,
            startsWith('${entry.key}.'),
            reason: 'Target ${target.code} does not '
                'start with goal ${entry.key}',
          );
        }
      }
    });

    test('no duplicate target codes within a goal', () {
      for (final entry in sdgTargets.entries) {
        final codes = entry.value.map((t) => t.code).toSet();
        expect(
          codes.length,
          entry.value.length,
          reason: 'Goal ${entry.key} has duplicate codes',
        );
      }
    });

    test('goal 1 first target is 1.1', () {
      expect(sdgTargets[1]!.first.code, '1.1');
    });

    test('goal 17 has implementation targets', () {
      final codes = sdgTargets[17]!.map((t) => t.code).toList();
      expect(codes, contains('17.1'));
      expect(codes, contains('17.19'));
    });

    test('all targets have JA descriptions', () {
      for (final entry in sdgTargets.entries) {
        for (final target in entry.value) {
          expect(
            target.descriptionJa,
            isNotEmpty,
            reason: 'Target ${target.code} has '
                'empty JA description',
          );
        }
      }
    });

    test('all targets have ES descriptions', () {
      for (final entry in sdgTargets.entries) {
        for (final target in entry.value) {
          expect(
            target.descriptionEs,
            isNotEmpty,
            reason: 'Target ${target.code} has '
                'empty ES description',
          );
        }
      }
    });
  });
}
