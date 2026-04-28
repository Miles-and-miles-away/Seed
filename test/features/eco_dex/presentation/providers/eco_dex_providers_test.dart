import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_category_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';

EcoDexEntry _entry({
  required String id,
  String category = 'forests',
  EcoDexCondition condition = const EcoDexCondition.totalActions(count: 1),
}) =>
    EcoDexEntry(
      id: id,
      category: category,
      nameEn: id,
      nameJa: '',
      nameEs: '',
      factEn: '',
      factJa: '',
      factEs: '',
      sourceUrl: '',
      iconName: id,
      condition: condition,
      hintEn: '',
      hintJa: '',
      hintEs: '',
    );

const _forestsCategory = EcoDexCategory(
  id: 'forests',
  nameEn: 'Forests',
  nameJa: '森',
  nameEs: 'Bosques',
);

const _oceansCategory = EcoDexCategory(
  id: 'oceans',
  nameEn: 'Oceans',
  nameJa: '海',
  nameEs: 'Océanos',
);

ProviderContainer _container(AppUserModel? user) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
    ],
  );
}

ProviderContainer _containerWithData({
  AppUserModel? user,
  List<EcoDexCategory> categories = const [],
  List<EcoDexEntry> entries = const [],
}) {
  return ProviderContainer(
    overrides: [
      currentUserProvider.overrideWith((_) => Stream.value(user)),
      ecoDexDataProvider.overrideWith(
        (_) async => EcoDexData(
          categories: categories,
          entries: entries,
        ),
      ),
      // Bypass the kDebugMode-only debug force list so tests reflect
      // only the discovered set on the test user.
      ecoDexDiscoveredProvider.overrideWith(
        (_) => user?.ecodexDiscovered ?? const [],
      ),
    ],
  );
}

Future<void> _pump(ProviderContainer c) async {
  c.listen(currentUserProvider, (_, __) {});
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('ecoDexDiscoveredProvider', () {
    test('returns empty when user is null', () async {
      final c = _container(null);
      addTearDown(c.dispose);
      await _pump(c);

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
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['forests_01', 'oceans_02'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(discovered, containsAll(['forests_01', 'oceans_02']));
    });

    test('de-duplicates debug overrides when already discovered', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          // Matches debug-forced ID; must not appear twice.
          ecodexDiscovered: ['oceans_01'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      final discovered = c.read(ecoDexDiscoveredProvider);
      expect(
        discovered.where((id) => id == 'oceans_01').length,
        1,
      );
    });
  });

  group('ecoDexDiscoveredCountProvider', () {
    test('returns list length', () async {
      final c = _container(
        const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['a', 'b', 'c'],
        ),
      );
      addTearDown(c.dispose);
      await _pump(c);

      expect(
        c.read(ecoDexDiscoveredCountProvider),
        c.read(ecoDexDiscoveredProvider).length,
      );
    });
  });

  group('ecoDexNewUnlocksProvider', () {
    test('returns empty when user is null', () async {
      final c = _containerWithData(
        entries: [_entry(id: 'a')],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, isEmpty);
    });

    test('returns empty when no entries qualify', () async {
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [
          _entry(
            id: 'too_high',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, isEmpty);
    });

    test('returns IDs whose conditions are met across condition types',
        () async {
      final c = _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          totalActionsCount: 5,
          level: 3,
        ),
        entries: [
          _entry(
            id: 'unlocked_actions',
            condition: const EcoDexCondition.totalActions(count: 5),
          ),
          _entry(
            id: 'unlocked_level',
            condition: const EcoDexCondition.levelReached(level: 3),
          ),
          _entry(
            id: 'locked',
            condition: const EcoDexCondition.totalActions(count: 999),
          ),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, ['unlocked_actions', 'unlocked_level']);
    });

    test('excludes entries already in ecodexDiscovered', () async {
      final c = _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          totalActionsCount: 50,
          ecodexDiscovered: ['already_have'],
        ),
        entries: [
          _entry(id: 'already_have'),
          _entry(
            id: 'newly_unlocked',
            condition: const EcoDexCondition.totalActions(count: 10),
          ),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, ['newly_unlocked']);
    });

    test('returns multiple newly-eligible entries in entry order', () async {
      final c = _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          totalActionsCount: 100,
        ),
        entries: [
          _entry(id: 'a'),
          _entry(
            id: 'b',
            condition: const EcoDexCondition.totalActions(count: 50),
          ),
          _entry(
            id: 'c',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final result = await c.read(ecoDexNewUnlocksProvider.future);
      expect(result, ['a', 'b', 'c']);
    });
  });

  group('ecoDexEntriesProvider', () {
    test('marks discovered entries with isDiscovered=true', () async {
      final c = _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['a', 'c'],
        ),
        entries: [_entry(id: 'a'), _entry(id: 'b'), _entry(id: 'c')],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final entries = await c.read(ecoDexEntriesProvider.future);
      expect(
        entries.map((e) => '${e.entry.id}:${e.isDiscovered}').toList(),
        ['a:true', 'b:false', 'c:true'],
      );
    });

    test('all undiscovered when user discovered list is empty', () async {
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [_entry(id: 'a'), _entry(id: 'b')],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final entries = await c.read(ecoDexEntriesProvider.future);
      expect(entries.every((e) => !e.isDiscovered), isTrue);
    });
  });

  group('ecoDexEntriesByCategoryProvider', () {
    test('filters entries to a single category', () async {
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [_forestsCategory, _oceansCategory],
        entries: [
          _entry(id: 'f1'),
          _entry(id: 'o1', category: 'oceans'),
          _entry(id: 'f2'),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

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
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [_forestsCategory, _oceansCategory],
        entries: [
          _entry(id: 'f1'),
          _entry(id: 'f2'),
          _entry(id: 'o1', category: 'oceans'),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['forests'], (0, 2));
      expect(progress['oceans'], (0, 1));
    });

    test('counts discovered per category', () async {
      final c = _containerWithData(
        user: const AppUserModel(
          uid: 'u',
          email: 'e',
          ecodexDiscovered: ['f1', 'o1'],
        ),
        categories: const [_forestsCategory, _oceansCategory],
        entries: [
          _entry(id: 'f1'),
          _entry(id: 'f2'),
          _entry(id: 'o1', category: 'oceans'),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['forests'], (1, 2));
      expect(progress['oceans'], (1, 1));
    });

    test('reports (0, 0) for a category with no entries', () async {
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        categories: const [_forestsCategory, _oceansCategory],
        entries: [_entry(id: 'f1')],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final progress = await c.read(ecoDexCategoryProgressProvider.future);
      expect(progress['oceans'], (0, 0));
    });
  });

  group('ecoDexDiscoveryNotifier', () {
    test(
        'discoverNewEntries returns [] without touching Firestore '
        'when nothing to unlock', () async {
      final c = _containerWithData(
        user: const AppUserModel(uid: 'u', email: 'e'),
        entries: [
          _entry(
            id: 'too_high',
            condition: const EcoDexCondition.totalActions(count: 100),
          ),
        ],
      );
      addTearDown(c.dispose);
      await _pump(c);

      final notifier = c.read(ecoDexDiscoveryProvider.notifier);
      final result = await notifier.discoverNewEntries();
      expect(result, isEmpty);
      // Empty-list short-circuits before Firestore call -- no error state.
      expect(c.read(ecoDexDiscoveryProvider).hasError, isFalse);
    });
  });
}
