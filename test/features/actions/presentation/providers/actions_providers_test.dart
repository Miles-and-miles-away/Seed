import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/data/repositories/action_log_repository.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';
import 'package:seed_app/shared/providers/clock_provider.dart';

import '../../../../helpers/test_helpers.dart';

ActionModel _a({
  required String id,
  String name = '',
  String category = 'transport',
  int co2 = 0,
  int points = 0,
  List<String> sdgs = const [],
  String nameJa = '',
  String desc = '',
}) => ActionModel(
  id: id,
  nameEn: name,
  nameJa: nameJa.isEmpty ? name : nameJa,
  category: category,
  points: points,
  co2Grams: co2,
  relatedSdgs: sdgs,
  descriptionEn: desc,
);

class _MockRepository extends Mock implements ActionLogRepository {}

void main() {
  final actions = [
    _a(id: 'walk', name: 'Walk', co2: 500, points: 20, sdgs: ['11', '13']),
    _a(id: 'bike', name: 'Bike', co2: 800, points: 15, sdgs: ['11']),
    _a(
      id: 'veggies',
      name: 'Eat veggies',
      category: 'food',
      co2: 300,
      points: 10,
      sdgs: ['2', '13'],
    ),
    _a(
      id: 'shower',
      name: 'Short shower',
      category: 'water',
      co2: 100,
      points: 5,
      sdgs: ['6'],
    ),
  ];

  Future<ProviderContainer> libraryContainer() => pumpedContainer([
    actionLibraryProvider.overrideWith((_) async => actions),
  ], warm: actionLibraryProvider);

  group('state notifiers', () {
    test('SelectedCategory: select, and select(null) clears', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(c.read(selectedCategoryProvider), isNull);
      c.read(selectedCategoryProvider.notifier).select(ActionCategory.food);
      expect(c.read(selectedCategoryProvider), ActionCategory.food);
      c.read(selectedCategoryProvider.notifier).select(null);
      expect(c.read(selectedCategoryProvider), isNull);
    });

    test('ActionSearchQuery: setQuery and clear', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(c.read(actionSearchQueryProvider), '');
      c.read(actionSearchQueryProvider.notifier).setQuery('bike');
      expect(c.read(actionSearchQueryProvider), 'bike');
      c.read(actionSearchQueryProvider.notifier).clear();
      expect(c.read(actionSearchQueryProvider), '');
    });

    test('SelectedSortOption: defaults to random and can change', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(c.read(selectedSortOptionProvider), ActionSortOption.random);
      c
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2HighToLow);
      expect(c.read(selectedSortOptionProvider), ActionSortOption.co2HighToLow);
    });

    test('SelectedSdgFilter: select and clear', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(c.read(selectedSdgFilterProvider), isNull);
      c.read(selectedSdgFilterProvider.notifier).select(11);
      expect(c.read(selectedSdgFilterProvider), 11);
      c.read(selectedSdgFilterProvider.notifier).clear();
      expect(c.read(selectedSdgFilterProvider), isNull);
    });
  });

  group('userLanguageCodeProvider', () {
    Override os(String code) =>
        osLocalesProvider.overrideWithBuild((_, _) => [Locale(code)]);

    test('follows the device language when signed out', () async {
      final c = await pumpedContainer([os('ja')]);

      expect(c.read(userLanguageCodeProvider), 'ja');
    });

    test('follows the app language, not the top-level user field', () async {
      final c = await pumpedContainer([
        os('en'),
        userOverride(AppUserModel(uid: 'u', email: 'e', language: 'ja')),
      ]);

      expect(c.read(userLanguageCodeProvider), 'en');
    });
  });

  group('baseFilteredActions', () {
    test('returns all actions when no filters applied', () async {
      final c = await libraryContainer();

      final filtered = c.read(baseFilteredActionsProvider).value;
      expect(filtered, hasLength(4));
    });

    test('filters by selected category', () async {
      final c = await libraryContainer();

      c.read(selectedCategoryProvider.notifier).select(ActionCategory.food);
      final filtered = c.read(baseFilteredActionsProvider).value!;

      expect(filtered.map((a) => a.id).toList(), ['veggies']);
    });

    test('filters by SDG number', () async {
      final c = await libraryContainer();

      c.read(selectedSdgFilterProvider.notifier).select(13);
      final filtered = c.read(baseFilteredActionsProvider).value!;

      expect(filtered.map((a) => a.id).toSet(), {'walk', 'veggies'});
    });

    test('filters by search query (case-insensitive)', () async {
      final c = await libraryContainer();

      c.read(actionSearchQueryProvider.notifier).setQuery('BIKE');
      final filtered = c.read(baseFilteredActionsProvider).value!;

      expect(filtered.map((a) => a.id).toList(), ['bike']);
    });

    test('combines all three filters', () async {
      final c = await libraryContainer();

      c
          .read(selectedCategoryProvider.notifier)
          .select(ActionCategory.transport);
      c.read(selectedSdgFilterProvider.notifier).select(13);
      c.read(actionSearchQueryProvider.notifier).setQuery('walk');

      final filtered = c.read(baseFilteredActionsProvider).value!;
      expect(filtered.map((a) => a.id).toList(), ['walk']);
    });
  });

  group('filteredActions (sort order)', () {
    Future<List<String>> sortedIds(ActionSortOption sort) async {
      final c = await libraryContainer();
      // Keep state alive across the upcoming reads.
      c
        ..listen(filteredActionsProvider, (_, _) {})
        ..listen(selectedSortOptionProvider, (_, _) {});
      c.read(selectedSortOptionProvider.notifier).select(sort);
      await Future<void>.delayed(Duration.zero);
      return c.read(filteredActionsProvider).value!.map((a) => a.id).toList();
    }

    test('alphabeticalAsc sorts by localized name ascending', () async {
      // Bike, Eat veggies, Short shower, Walk.
      expect(await sortedIds(ActionSortOption.alphabeticalAsc), [
        'bike',
        'veggies',
        'shower',
        'walk',
      ]);
    });

    test('alphabeticalDesc reverses the order', () async {
      expect(await sortedIds(ActionSortOption.alphabeticalDesc), [
        'walk',
        'shower',
        'veggies',
        'bike',
      ]);
    });

    test('co2HighToLow sorts by co2 descending', () async {
      expect(await sortedIds(ActionSortOption.co2HighToLow), [
        'bike',
        'walk',
        'veggies',
        'shower',
      ]);
    });

    test('co2LowToHigh is the reverse', () async {
      expect(await sortedIds(ActionSortOption.co2LowToHigh), [
        'shower',
        'veggies',
        'walk',
        'bike',
      ]);
    });

    test('pointsHighToLow sorts by points descending', () async {
      expect(await sortedIds(ActionSortOption.pointsHighToLow), [
        'walk',
        'bike',
        'veggies',
        'shower',
      ]);
    });

    test('pointsLowToHigh is the reverse', () async {
      expect(await sortedIds(ActionSortOption.pointsLowToHigh), [
        'shower',
        'veggies',
        'bike',
        'walk',
      ]);
    });
  });

  group('filteredActions (shuffle)', () {
    final libraryIds = [for (final a in actions) a.id];

    List<String> shuffledIds(int seed, [Iterable<String>? survivors]) {
      final order = [...libraryIds]..shuffle(Random(seed));
      return [
        for (final id in order)
          if (survivors == null || survivors.contains(id)) id,
      ];
    }

    late List<int> seeds;
    late int seedBuilds;

    setUp(() {
      seeds = [1, 2, 3, 4];
      seedBuilds = 0;
    });

    final seedOverride = actionShuffleSeedProvider.overrideWith((_) {
      seedBuilds++;
      return seeds.removeAt(0);
    });

    Future<ProviderContainer> shuffleContainer() => pumpedContainer([
      actionLibraryProvider.overrideWith((_) async => actions),
      seedOverride,
    ], warm: actionLibraryProvider);

    List<String> ids(ProviderContainer c) =>
        c.read(filteredActionsProvider).value!.map((a) => a.id).toList();

    test('defaults to random and follows the seeded rank', () async {
      final c = await shuffleContainer();
      c.listen(filteredActionsProvider, (_, _) {});

      expect(c.read(selectedSortOptionProvider), ActionSortOption.random);
      expect(ids(c), shuffledIds(1));
    });

    test('is a permutation of the filtered ids', () async {
      final c = await shuffleContainer();
      c.listen(filteredActionsProvider, (_, _) {});
      c.read(selectedSdgFilterProvider.notifier).select(13);

      final base = c.read(baseFilteredActionsProvider).value!;
      expect(ids(c), unorderedEquals(base.map((a) => a.id)));
      expect(ids(c), hasLength(base.length));
    });

    test('order holds within a visit across filter changes', () async {
      final c = await shuffleContainer();
      c.listen(filteredActionsProvider, (_, _) {});
      final first = ids(c);

      expect(ids(c), first);

      c.read(actionSearchQueryProvider.notifier).setQuery('bike');
      expect(ids(c), ['bike']);
      c.read(actionSearchQueryProvider.notifier).clear();
      expect(ids(c), first);

      c.read(selectedCategoryProvider.notifier).select(ActionCategory.food);
      expect(ids(c), ['veggies']);
      c.read(selectedCategoryProvider.notifier).select(null);
      expect(ids(c), first);

      c.read(selectedSdgFilterProvider.notifier).select(13);
      c.read(selectedSdgFilterProvider.notifier).clear();
      expect(ids(c), first);

      c.invalidate(actionLibraryProvider);
      await c.read(actionLibraryProvider.future);
      await c.pump();
      expect(ids(c), first);
      expect(seedBuilds, 1);
    });

    test('a filter keeps the unfiltered relative order', () async {
      final c = await shuffleContainer();
      c.listen(filteredActionsProvider, (_, _) {});

      c.read(selectedSdgFilterProvider.notifier).select(13);
      expect(ids(c), shuffledIds(1, {'walk', 'veggies'}));

      c.read(selectedSdgFilterProvider.notifier).clear();
      c
          .read(selectedCategoryProvider.notifier)
          .select(ActionCategory.transport);
      expect(ids(c), shuffledIds(1, {'walk', 'bike'}));
    });

    test('a new visit draws a new seed', () async {
      final c = await shuffleContainer();
      final visit = c.listen(filteredActionsProvider, (_, _) {});
      expect(ids(c), shuffledIds(1));

      visit.close();
      await c.pump();
      c.listen(filteredActionsProvider, (_, _) {});

      expect(ids(c), shuffledIds(2));
      expect(seedBuilds, 2);
    });

    test('a chosen sort lasts the session, the seed does not', () async {
      final c = await shuffleContainer();
      final visit = c.listen(filteredActionsProvider, (_, _) {});
      c
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2HighToLow);
      expect(ids(c), ['bike', 'walk', 'veggies', 'shower']);

      visit.close();
      await c.pump();
      c.listen(filteredActionsProvider, (_, _) {});

      expect(c.read(selectedSortOptionProvider), ActionSortOption.co2HighToLow);
      expect(ids(c), ['bike', 'walk', 'veggies', 'shower']);
      expect(seedBuilds, 2);
    });

    test('a cold start is random again', () async {
      final first = await shuffleContainer();
      first
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2HighToLow);

      final second = await shuffleContainer();
      expect(second.read(selectedSortOptionProvider), ActionSortOption.random);
    });

    test('a different signed-in user resets the sort to random', () async {
      final store = MemoryLanguageStore();
      final c = await pumpedContainer(
        [userIdProvider.overrideWithValue('a')],
        warm: userIdProvider,
        languageStore: store,
      );
      c.listen(selectedSortOptionProvider, (_, _) {});
      c
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2LowToHigh);

      c.updateOverrides([
        languageStoreOverride(store),
        userIdProvider.overrideWithValue('b'),
      ]);
      await c.pump();

      expect(c.read(selectedSortOptionProvider), ActionSortOption.random);
    });

    test('an account change resets the sort while nothing listens', () async {
      final auth = StreamController<User?>();
      addTearDown(auth.close);
      final c = await pumpedContainer([
        authStateChangesProvider.overrideWith((_) => auth.stream),
      ], warm: authStateChangesProvider);
      auth.add(createMockUser(uid: 'a'));
      await Future<void>.delayed(Duration.zero);

      final visit = c.listen(selectedSortOptionProvider, (_, _) {});
      c
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2LowToHigh);
      visit.close();
      await c.pump();

      auth.add(createMockUser(uid: 'b'));
      await Future<void>.delayed(Duration.zero);

      expect(c.read(selectedSortOptionProvider), ActionSortOption.random);
    });

    test('a user-document update keeps the chosen sort', () async {
      final auth = StreamController<User?>();
      final doc = StreamController<AppUserModel?>();
      addTearDown(auth.close);
      addTearDown(doc.close);
      final c = await pumpedContainer([
        authStateChangesProvider.overrideWith((_) => auth.stream),
        currentUserProvider.overrideWith((_) => doc.stream),
      ], warm: authStateChangesProvider);
      c.listen(currentUserProvider, (_, _) {});
      auth.add(createMockUser(uid: 'a'));
      doc.add(const AppUserModel(uid: 'a', email: 'e'));
      await Future<void>.delayed(Duration.zero);

      c.listen(selectedSortOptionProvider, (_, _) {});
      c
          .read(selectedSortOptionProvider.notifier)
          .select(ActionSortOption.co2LowToHigh);

      doc.add(const AppUserModel(uid: 'a', email: 'e', points: 20));
      auth.add(createMockUser(uid: 'a'));
      await Future<void>.delayed(Duration.zero);

      expect(c.read(currentUserProvider).value?.points, 20);
      expect(c.read(selectedSortOptionProvider), ActionSortOption.co2LowToHigh);
    });

    test('picking Shuffle reshuffles, even when already active', () async {
      final c = await shuffleContainer();
      c.listen(filteredActionsProvider, (_, _) {});
      final sort = c.read(selectedSortOptionProvider.notifier);
      expect(ids(c), shuffledIds(1));

      sort.select(ActionSortOption.random);
      expect(ids(c), shuffledIds(2));
      expect(seedBuilds, 2);

      sort.select(ActionSortOption.alphabeticalAsc);
      expect(seedBuilds, 2);
      sort.select(ActionSortOption.random);
      expect(ids(c), shuffledIds(3));
      expect(seedBuilds, 3);
    });
  });

  group('log streams', () {
    final now = DateTime(2026, 6, 17, 15, 30);
    late _MockRepository repo;

    setUp(() {
      repo = _MockRepository();
      when(
        () => repo.watchActionLogsForRange(any(), any(), any()),
      ).thenAnswer((_) => Stream.value(const []));
      when(
        () => repo.watchUserActionLogs(any(), limit: any(named: 'limit')),
      ).thenAnswer((_) => Stream.value(const []));
    });

    Future<ProviderContainer> streamContainer() => pumpedContainer([
      clockProvider.overrideWithValue(() => now),
      userIdProvider.overrideWithValue('u'),
      actionLogRepositoryProvider.overrideWith((_) async => repo),
    ], warm: userIdProvider);

    test('todayActions queries from local midnight to the next', () async {
      final c = await streamContainer();
      c.listen(todayActionsProvider, (_, _) {});

      await c.read(todayActionsProvider.future);

      verify(
        () => repo.watchActionLogsForRange(
          'u',
          DateTime(2026, 6, 17),
          DateTime(2026, 6, 18),
        ),
      ).called(1);
    });

    test('userActionLogs grows by one page per loadMore', () async {
      final c = await streamContainer();
      c.listen(userActionLogsProvider, (_, _) {});

      await c.read(userActionLogsProvider.future);
      verify(
        () => repo.watchUserActionLogs('u', limit: actionHistoryPageSize),
      ).called(1);

      c.read(actionHistoryPagesProvider.notifier).loadMore();
      await Future<void>.delayed(Duration.zero);
      await c.read(userActionLogsProvider.future);
      verify(
        () => repo.watchUserActionLogs('u', limit: 2 * actionHistoryPageSize),
      ).called(1);
    });
  });
}
