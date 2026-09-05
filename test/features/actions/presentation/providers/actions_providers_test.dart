import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';

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

    test('SelectedSortOption: defaults to alphabeticalAsc and can change', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);

      expect(
        c.read(selectedSortOptionProvider),
        ActionSortOption.alphabeticalAsc,
      );
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
    test('defaults to en when no user', () async {
      final c = await pumpedContainer([]);

      expect(c.read(userLanguageCodeProvider), 'en');
    });

    test('reads from user language', () async {
      final c = await pumpedContainer([
        userOverride(AppUserModel(uid: 'u', email: 'e', language: 'ja')),
      ]);

      expect(c.read(userLanguageCodeProvider), 'ja');
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
}
