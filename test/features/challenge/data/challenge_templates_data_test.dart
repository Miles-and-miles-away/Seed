import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
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

    test('every multi-day template has a non-empty English title', () async {
      final data = await loadChallengeTemplates();

      for (final t in data.multiDay) {
        expect(t.titleEn, isNotEmpty, reason: 'multi-day ${t.id}');
      }
    });

    test('daily: three per loggable category, none for learning', () async {
      final data = await loadChallengeTemplates();

      expect(data.daily, hasLength(24));
      final perCategory = <String, int>{};
      for (final t in data.daily) {
        perCategory[t.category] = (perCategory[t.category] ?? 0) + 1;
      }
      expect(perCategory.keys.toSet(), {
        for (final c in ActionCategory.values)
          if (c != ActionCategory.learning) c.name,
      });
      expect(perCategory.values, everyElement(3));
    });

    test('every daily action is active in its category in the seed', () async {
      final data = await loadChallengeTemplates();
      final seed =
          jsonDecode(
                File('data/seed/co2_actions_database.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      final actions = {
        for (final a in seed['actions'] as List<dynamic>)
          (a as Map<String, dynamic>)['action_id'] as String: a,
      };

      for (final t in data.daily) {
        final action = actions[t.actionId];
        expect(action, isNotNull, reason: t.actionId);
        expect(action!['is_active'], isTrue, reason: t.actionId);
        expect(action['category'], t.category, reason: t.actionId);
      }
    });
  });
}
