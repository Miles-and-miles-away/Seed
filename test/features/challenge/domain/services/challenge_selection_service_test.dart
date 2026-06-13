import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/domain/services/challenge_selection_service.dart';

DailyChallengeTemplate _t(String id, {String category = 'transport'}) =>
    DailyChallengeTemplate(
      id: id,
      category: category,
      titleEn: id,
      titleEs: '',
      titleJa: '',
    );

void main() {
  group('dailySeed', () {
    test('returns stable value for same user and date', () {
      final date = DateTime(2026, 4, 19);

      expect(dailySeed('u1', date), dailySeed('u1', date));
    });

    test('differs across users on the same date', () {
      final date = DateTime(2026, 4, 19);

      expect(dailySeed('u1', date), isNot(dailySeed('u2', date)));
    });

    test('differs across dates for the same user', () {
      expect(
        dailySeed('u1', DateTime(2026, 4, 19)),
        isNot(dailySeed('u1', DateTime(2026, 4, 20))),
      );
    });

    test('matches the FNV-1a snapshot (cross-platform stability)', () {
      // String.hashCode is not stable across platforms/SDKs; the seed
      // uses explicit FNV-1a. If this snapshot ever changes, today's
      // challenge would silently change for every user mid-day.
      expect(dailySeed('u1', DateTime(2026, 4, 19)), 1761451693);
    });
  });

  group('selectDailyChallenge', () {
    test('returns deterministic result for same inputs', () {
      final date = DateTime(2026, 4, 19);
      final templates = [_t('a'), _t('b'), _t('c')];

      final first = selectDailyChallenge('u1', date, [], templates);
      final second = selectDailyChallenge('u1', date, [], templates);

      expect(first.id, second.id);
    });

    test('excludes recent IDs when unexcluded alternatives remain', () {
      final date = DateTime(2026, 4, 19);
      final templates = [_t('a'), _t('b'), _t('c')];

      for (var i = 0; i < 10; i++) {
        final pick = selectDailyChallenge(
          'seed-$i',
          date,
          ['a', 'b'],
          templates,
        );
        expect(pick.id, 'c');
      }
    });

    test('falls back to full pool when all templates are recent', () {
      final date = DateTime(2026, 4, 19);
      final templates = [_t('a'), _t('b')];

      // All IDs are in recent list but we must still pick one.
      final pick = selectDailyChallenge(
        'user-seed',
        date,
        ['a', 'b', 'x'],
        templates,
      );

      expect(['a', 'b'], contains(pick.id));
    });

    test('only the first limit recent IDs are excluded', () {
      final date = DateTime(2026, 4, 19);
      // Recent list is longer than the cap. IDs past the cap should
      // still be eligible (because only the first N are blocked).
      final limit = AppConstants.recentChallengeIdsLimit;
      final recent = List<String>.generate(limit + 3, (i) => 'blocked-$i');
      final templates = [
        ...List.generate(limit, (i) => _t('blocked-$i')),
        _t('blocked-$limit'),
        _t('blocked-${limit + 1}'),
        _t('blocked-${limit + 2}'),
      ];

      final pick = selectDailyChallenge('u1', date, recent, templates);

      // The first `limit` blocked-* ids should never be picked.
      for (var i = 0; i < limit; i++) {
        expect(pick.id, isNot('blocked-$i'));
      }
    });

    test('produces a spread of picks across users', () {
      final date = DateTime(2026, 4, 19);
      final templates = [_t('a'), _t('b'), _t('c'), _t('d')];

      final ids = {
        for (var i = 0; i < 20; i++)
          selectDailyChallenge('user-$i', date, const [], templates).id,
      };

      expect(ids.length, greaterThan(1));
    });
  });
}
