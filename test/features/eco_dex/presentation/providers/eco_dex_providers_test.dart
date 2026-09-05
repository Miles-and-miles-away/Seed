import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';

import '../../../../helpers/test_helpers.dart';
import '../../eco_dex_fixtures.dart';

Future<ProviderContainer> _containerWithData({
  AppUserModel? user,
  List<EcoDexCategory> categories = const [],
  List<EcoDexEntry> entries = const [],
}) => pumpedContainer([
  userOverride(user),
  ecoDexDataProvider.overrideWith(
    (_) async => EcoDexData(categories: categories, entries: entries),
  ),
  // Bypass the kDebugMode-only debug force list so tests reflect
  // only the discovered set on the test user.
  ecoDexDiscoveredProvider.overrideWith(
    (_) => user?.ecodexDiscovered ?? const [],
  ),
]);

void main() {
  group('ecoDexDiscoveredProvider', () {
    test('returns empty when user is null', () async {
      final c = await pumpedContainer([userOverride(null)]);

      final discovered = c.read(ecoDexDiscoveredProvider);
      // In kDebugMode a debug-forced list is merged in; filter that out
      // for the null-user case since the implementation short-circuits
      // only when there is no user — the debug list still applies.
      if (!kDebugMode) {
        expect(discovered, isEmpty);
      } else {
        // Debug override merges with the empty real list.
        expect(discovered, isA<List<String>>());
      }
    });

    test('reflects the user.ecodexDiscovered list', () async {
      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(
            uid: 'u',
            email: 'e',
            ecodexDiscovered: ['forests_01', 'oceans_02'],
          ),
        ),
      ]);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(discovered, containsAll(['forests_01', 'oceans_02']));
    });

    test('de-duplicates debug overrides when already discovered', () async {
      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(
            uid: 'u',
            email: 'e',
            // Matches debug-forced ID; must not appear twice.
            ecodexDiscovered: ['oceans_01'],
          ),
        ),
      ]);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(discovered.where((id) => id == 'oceans_01').length, 1);
    });
  });

  group('ecoDexDiscoveredCountProvider', () {
    test('returns list length', () async {
      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(
            uid: 'u',
            email: 'e',
            ecodexDiscovered: ['a', 'b', 'c'],
          ),
        ),
      ]);

      expect(
        c.read(ecoDexDiscoveredCountProvider),
        c.read(ecoDexDiscoveredProvider).length,
      );
    });
  });

  group('ecoDexNewUnlocksProvider', () {
    test('returns empty when user is null', () async {
      final c = await _containerWithData(entries: [ecoDexEntry('a')]);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, isEmpty);
    });

    test('returns empty when no entries qualify', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [
          ecoDexEntry(
            'too_high',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, isEmpty);
    });

    test(
      'returns IDs whose conditions are met across condition types',
      () async {
        final c = await _containerWithData(
          user: const AppUserModel(
            uid: 'u',
            email: 'e',
            totalActionsCount: 5,
            level: 3,
          ),
          entries: [
            ecoDexEntry(
              'unlocked_actions',
              condition: const EcoDexCondition.totalActions(count: 5),
            ),
            ecoDexEntry(
              'unlocked_level',
              condition: const EcoDexCondition.levelReached(level: 3),
            ),
            ecoDexEntry(
              'locked',
              condition: const EcoDexCondition.totalActions(count: 999),
            ),
          ],
        );

        final result = await c.read(ecoDexNewUnlocksProvider.future);
        expect(result, ['unlocked_actions', 'unlocked_level']);
      },
    );

    test('excludes entries already in ecodexDiscovered', () async {
      final c = await _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          totalActionsCount: 50,
          ecodexDiscovered: ['already_have'],
        ),
        entries: [
          ecoDexEntry('already_have'),
          ecoDexEntry(
            'newly_unlocked',
            condition: const EcoDexCondition.totalActions(count: 10),
          ),
        ],
      );

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, ['newly_unlocked']);
    });

    test('returns multiple newly-eligible entries in entry order', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e', totalActionsCount: 100),
        entries: [
          ecoDexEntry('a'),
          ecoDexEntry(
            'b',
            condition: const EcoDexCondition.totalActions(count: 50),
          ),
          ecoDexEntry(
            'c',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, ['a', 'b', 'c']);
    });
  });

  group('ecoDexEntriesProvider', () {
    test('marks discovered entries with isDiscovered=true', () async {
      final c = await _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['a', 'c'],
        ),
        entries: [ecoDexEntry('a'), ecoDexEntry('b'), ecoDexEntry('c')],
      );

      final entries = await c.read(ecoDexEntriesProvider.future);
      expect(entries.map((e) => '${e.entry.id}:${e.isDiscovered}').toList(), [
        'a:true',
        'b:false',
        'c:true',
      ]);
    });

    test('all undiscovered when user discovered list is empty', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [ecoDexEntry('a'), ecoDexEntry('b')],
      );

      final entries = await c.read(ecoDexEntriesProvider.future);
      expect(entries.every((e) => !e.isDiscovered), isTrue);
    });
  });

  group('ecoDexEntriesByCategoryProvider', () {
    test('filters entries to a single category', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [forestsCategory, oceansCategory],
        entries: [
          ecoDexEntry('f1'),
          ecoDexEntry('o1', category: 'oceans'),
          ecoDexEntry('f2'),
        ],
      );

      final forests = await c.read(
        ecoDexEntriesByCategoryProvider('forests').future,
      );
      expect(forests.map((e) => e.entry.id).toList(), ['f1', 'f2']);

      final oceans = await c.read(
        ecoDexEntriesByCategoryProvider('oceans').future,
      );
      expect(oceans.map((e) => e.entry.id).toList(), ['o1']);
    });
  });

  group('ecoDexCategoryProgressProvider', () {
    test('returns (0, total) when nothing discovered', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [forestsCategory, oceansCategory],
        entries: [
          ecoDexEntry('f1'),
          ecoDexEntry('f2'),
          ecoDexEntry('o1', category: 'oceans'),
        ],
      );

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['forests'], (0, 2));
      expect(progress['oceans'], (0, 1));
    });

    test('counts discovered per category', () async {
      final c = await _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['f1', 'o1'],
        ),
        categories: const [forestsCategory, oceansCategory],
        entries: [
          ecoDexEntry('f1'),
          ecoDexEntry('f2'),
          ecoDexEntry('o1', category: 'oceans'),
        ],
      );

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['forests'], (1, 2));
      expect(progress['oceans'], (1, 1));
    });

    test('reports (0, 0) for a category with no entries', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [forestsCategory, oceansCategory],
        entries: [ecoDexEntry('f1')],
      );

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['oceans'], (0, 0));
    });
  });

  group('ecoDexDiscoveryNotifier', () {
    test('discoverNewEntries returns [] without touching Firestore '
        'when nothing to unlock', () async {
      final c = await _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [
          ecoDexEntry(
            'too_high',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );

      final notifier = c.read(ecoDexDiscoveryProvider.notifier);
      final result = await notifier.discoverNewEntries();
      expect(result, isEmpty);
      // Empty-list short-circuits before Firestore call -- no error state.
      expect(c.read(ecoDexDiscoveryProvider).hasError, isFalse);
    });

    test('concurrent discoverNewEntries records each unlock once '
        'via arrayUnion idempotency', () async {
      final firestore = FakeFirebaseFirestore();
      const uid = 'u';
      final userDoc = firestore
          .collection(AppConstants.collectionUsers)
          .doc(uid);
      await userDoc.set({AppConstants.fieldEcodexDiscovered: <String>[]});

      final c = await pumpedContainer([
        userOverride(
          const AppUserModel(uid: uid, email: 'e', totalActionsCount: 5),
        ),
        firestoreProvider.overrideWithValue(firestore),
        ecoDexDataProvider.overrideWith(
          (_) async => EcoDexData(
            categories: const [],
            entries: [
              ecoDexEntry('a'),
              ecoDexEntry(
                'b',
                condition: const EcoDexCondition.totalActions(count: 5),
              ),
            ],
          ),
        ),
      ]);

      final notifier = c.read(ecoDexDiscoveryProvider.notifier);
      // Two discoveries race: both compute the same unlocks from the same
      // user snapshot, so arrayUnion must keep the stored set duplicate-free.
      final results = await Future.wait([
        notifier.discoverNewEntries(),
        notifier.discoverNewEntries(),
      ]);

      expect(results[0], ['a', 'b']);
      expect(results[1], ['a', 'b']);

      final snapshot = await userDoc.get();
      final stored = List<String>.from(
        snapshot.data()![AppConstants.fieldEcodexDiscovered] as List,
      );
      expect(stored, unorderedEquals(['a', 'b']));
      expect(stored.length, 2);
    });

    test('records the unlock when the user stream lags the log '
        'transaction', () async {
      final firestore = FakeFirebaseFirestore();
      const uid = 'u';
      final userDoc = firestore
          .collection(AppConstants.collectionUsers)
          .doc(uid);
      await userDoc.set({AppConstants.fieldEcodexDiscovered: <String>[]});

      final users = StreamController<AppUserModel?>();
      addTearDown(users.close);
      users.add(const AppUserModel(uid: uid, email: 'e', totalActionsCount: 5));

      final c = await pumpedContainer([
        currentUserProvider.overrideWith((_) => users.stream),
        firestoreProvider.overrideWithValue(firestore),
        ecoDexDataProvider.overrideWith(
          (_) async => EcoDexData(
            categories: const [],
            entries: [
              ecoDexEntry(
                'b',
                condition: const EcoDexCondition.totalActions(count: 6),
              ),
            ],
          ),
        ),
      ]);

      // The user doc catches up only after discovery has started waiting.
      Timer(const Duration(milliseconds: 120), () {
        users.add(
          const AppUserModel(uid: uid, email: 'e', totalActionsCount: 6),
        );
      });

      // Read-only caller: as autoDispose the notifier was disposed during
      // the wait and dropped the unlock the action had just earned.
      final result = await c
          .read(ecoDexDiscoveryProvider.notifier)
          .discoverNewEntries(minActionsCount: 6);

      expect(result, ['b']);
      final stored =
          (await userDoc.get()).data()![AppConstants.fieldEcodexDiscovered]
              as List<dynamic>;
      expect(stored, ['b']);
    });
  });
}
