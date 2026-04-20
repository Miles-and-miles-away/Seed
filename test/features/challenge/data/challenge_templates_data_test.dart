import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/challenge/data/challenge_templates_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadChallengeTemplates', () {
    test('returns both daily and multi-day lists', () async {
      final data = await loadChallengeTemplates();

      expect(data.daily, isNotEmpty);
      expect(data.multiDay, isNotEmpty);
    });

    test('daily template IDs are unique', () async {
      final data = await loadChallengeTemplates();

      final ids = data.daily.map((t) => t.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('multi-day templates have positive targetDays', () async {
      final data = await loadChallengeTemplates();

      for (final t in data.multiDay) {
        expect(t.targetDays, greaterThan(0), reason: 'template ${t.id}');
      }
    });

    test('every template has a non-empty English title', () async {
      final data = await loadChallengeTemplates();

      for (final t in data.daily) {
        expect(t.titleEn, isNotEmpty, reason: 'daily ${t.id}');
      }
      for (final t in data.multiDay) {
        expect(t.titleEn, isNotEmpty, reason: 'multi-day ${t.id}');
      }
    });
  });
}
