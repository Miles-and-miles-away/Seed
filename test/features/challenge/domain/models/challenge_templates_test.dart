import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/challenge/domain/models/active_multi_day_challenge.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';

void main() {
  group('DailyChallengeTemplate.fromJson', () {
    test('parses actionId and category, and uses the action id as id', () {
      final t = DailyChallengeTemplate.fromJson({
        'actionId': 'walk_instead_drive',
        'category': 'transport',
      });

      expect(t.actionId, 'walk_instead_drive');
      expect(t.category, 'transport');
      expect(t.id, t.actionId);
    });
  });

  group('MultiDayChallengeTemplate.fromJson', () {
    test('parses required and optional fields', () {
      final t = MultiDayChallengeTemplate.fromJson({
        'id': 'md1',
        'category': 'food',
        'targetDays': 7,
        'titleEn': 'No meat week',
        'titleEs': '',
        'titleJa': '',
        'descriptionEn': 'Seven days meatless',
        'descriptionEs': '',
        'descriptionJa': '',
      });

      expect(t.id, 'md1');
      expect(t.category, 'food');
      expect(t.targetDays, 7);
      expect(t.description('en'), 'Seven days meatless');
    });

    test('accepts a null category for any-action challenges', () {
      final t = MultiDayChallengeTemplate.fromJson({
        'id': 'md2',
        'category': null,
        'targetDays': 3,
        'titleEn': 'Any 3 days',
        'titleEs': '',
        'titleJa': '',
        'descriptionEn': '',
        'descriptionEs': '',
        'descriptionJa': '',
      });

      expect(t.category, isNull);
    });

    test('title/description fall back to English for unknown locale', () {
      const t = MultiDayChallengeTemplate(
        id: 'x',
        category: null,
        targetDays: 1,
        titleEn: 'EN',
        titleEs: 'ES',
        titleJa: 'JA',
        descriptionEn: 'desc',
        descriptionEs: 'd-es',
        descriptionJa: 'd-ja',
      );

      expect(t.title('fr'), 'EN');
      expect(t.description('fr'), 'desc');
    });
  });

  group('ActiveMultiDayChallenge.fromMap', () {
    test('returns null for null or empty map', () {
      expect(ActiveMultiDayChallenge.fromMap(null), isNull);
      expect(ActiveMultiDayChallenge.fromMap(const {}), isNull);
    });

    test('returns null when templateId is missing or empty', () {
      expect(ActiveMultiDayChallenge.fromMap(const {'currentDay': 1}), isNull);
      expect(ActiveMultiDayChallenge.fromMap(const {'templateId': ''}), isNull);
    });

    test('parses all fields from a well-formed map', () {
      final a = ActiveMultiDayChallenge.fromMap(const {
        'templateId': 'md-1',
        'currentDay': 3,
        'targetDays': 5,
        'lastCompletionDate': '2026-04-18',
      });

      expect(a, isNotNull);
      expect(a!.templateId, 'md-1');
      expect(a.currentDay, 3);
      expect(a.targetDays, 5);
      expect(a.lastCompletionDate, '2026-04-18');
    });

    test('coerces numeric fields from doubles', () {
      final a = ActiveMultiDayChallenge.fromMap(const {
        'templateId': 'md-1',
        'currentDay': 3.0,
        'targetDays': 5.0,
      });

      expect(a!.currentDay, 3);
      expect(a.targetDays, 5);
    });

    test('defaults lastCompletionDate to empty string when missing', () {
      final a = ActiveMultiDayChallenge.fromMap(const {
        'templateId': 'md-1',
        'currentDay': 1,
        'targetDays': 3,
      });

      expect(a!.lastCompletionDate, '');
    });
  });

  group('localized fallbacks', () {
    test('an empty translation falls back to English', () {
      const multi = MultiDayChallengeTemplate(
        id: 'm',
        category: null,
        targetDays: 3,
        titleEn: 'Three days',
        titleEs: '',
        titleJa: '',
        descriptionEn: 'Keep going',
        descriptionEs: '',
        descriptionJa: '',
      );

      expect(multi.title('ja'), 'Three days');
      expect(multi.description('es'), 'Keep going');
    });
  });
}
