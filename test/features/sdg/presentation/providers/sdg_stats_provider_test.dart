import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_stats_provider.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('sdgStatsProvider', () {
    test('returns zeros when user is null', () async {
      final c = await pumpedContainer([userOverride(null)]);

      final stats = c.read(sdgStatsProvider(11));

      expect(stats.sdgNumber, 11);
      expect(stats.actionsLogged, 0);
      expect(stats.co2SavedGrams, 0);
    });

    test('reads count and co2 from user.sdgStats', () async {
      final user = AppUserModel(
        uid: 'u1',
        email: 'a@b.com',
        sdgStats: const {
          '11': {'count': 5, 'co2': 400},
          '13': {'count': 2, 'co2': 100},
        },
      );
      final c = await pumpedContainer([userOverride(user)]);

      final sdg11 = c.read(sdgStatsProvider(11));
      final sdg13 = c.read(sdgStatsProvider(13));

      expect(sdg11.actionsLogged, 5);
      expect(sdg11.co2SavedGrams, 400);
      expect(sdg13.actionsLogged, 2);
      expect(sdg13.co2SavedGrams, 100);
    });

    test('returns zero stats for SDG not in user map', () async {
      final user = AppUserModel(
        uid: 'u1',
        email: 'a@b.com',
        sdgStats: const {
          '11': {'count': 1, 'co2': 50},
        },
      );
      final c = await pumpedContainer([userOverride(user)]);

      final stats = c.read(sdgStatsProvider(7));

      expect(stats.actionsLogged, 0);
      expect(stats.co2SavedGrams, 0);
    });
  });

  group('sdgRelatedActionsProvider', () {
    test('filters by SDG number', () async {
      const a1 = ActionModel(
        id: 'a1',
        nameEn: '',
        nameJa: '',
        category: 'transport',
        points: 10,
        relatedSdgs: ['11'],
      );
      const a2 = ActionModel(
        id: 'a2',
        nameEn: '',
        nameJa: '',
        category: 'transport',
        points: 10,
        relatedSdgs: ['13'],
      );
      const a3 = ActionModel(
        id: 'a3',
        nameEn: '',
        nameJa: '',
        category: 'transport',
        points: 10,
        relatedSdgs: ['11', '13'],
      );

      final c = await pumpedContainer([
        actionLibraryProvider.overrideWith((ref) async => [a1, a2, a3]),
      ], warm: actionLibraryProvider);

      final eleven = c.read(sdgRelatedActionsProvider(11));
      expect(eleven.map((a) => a.id).toList(), ['a1', 'a3']);
    });

    test('returns empty list when no matches', () async {
      final c = ProviderContainer(
        overrides: [
          actionLibraryProvider.overrideWith((ref) async => const []),
        ],
      );
      addTearDown(c.dispose);

      expect(c.read(sdgRelatedActionsProvider(1)), isEmpty);
    });
  });
}
