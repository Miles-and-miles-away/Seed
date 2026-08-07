import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/food/data/models/food_item_model.dart';
import 'package:seed_app/features/food/presentation/widgets/food_display.dart';
import 'package:seed_app/features/food/presentation/widgets/food_item_picker.dart';

FoodItem _item(
  String id,
  String group,
  String en, {
  String ja = '',
  String es = '',
  List<String> termsEn = const [],
  List<String> termsJa = const [],
  List<String> termsEs = const [],
}) => FoodItem(
  id: id,
  group: group,
  nameEn: en,
  nameJa: ja,
  nameEs: es,
  kgCo2ePerKg: 1,
  searchTermsEn: termsEn,
  searchTermsJa: termsJa,
  searchTermsEs: termsEs,
);

final _items = <FoodItem>[
  _item('beef', 'meat', 'Beef', ja: '牛肉', es: 'Carne de res'),
  _item('chicken', 'meat', 'Chicken', ja: '鶏肉', es: 'Pollo'),
  _item('bananas', 'fruit', 'Bananas', ja: 'バナナ', es: 'Plátano'),
  _item('chilli', 'vegetables', 'Chilli', ja: '唐辛子', es: 'Jalapeño'),
  _item('tofu', 'plant_protein', 'Tofu', ja: '豆腐', es: 'Tofu'),
];

void main() {
  group('searchFoodItems', () {
    test('a blank query returns everything in dataset order', () {
      expect(searchFoodItems(_items, '   '), _items);
    });

    test('name-prefix matches rank above mid-word matches', () {
      // Dataset order puts the mid-word match first; ranking must
      // still surface the item the user most likely meant.
      final ranked = searchFoodItems([
        _item('snap_peas', 'vegetables', 'Snap peas'),
        _item('peas', 'vegetables', 'Peas'),
      ], 'pea');
      expect(ranked.map((i) => i.id), ['peas', 'snap_peas']);
    });

    test('matches names in a locale the user is not using', () {
      // The dataset is deliberately multi-market: someone who knows a
      // food only as 豆腐 must still find it in an English UI.
      expect(searchFoodItems(_items, '豆腐').single.id, 'tofu');
      expect(searchFoodItems(_items, 'Pollo').single.id, 'chicken');
    });

    test('accents are optional -- the ES failure mode', () {
      // Nobody types the accent on a phone keyboard. Without folding
      // these two return nothing, which is the commonest ES query.
      expect(searchFoodItems(_items, 'platano').single.id, 'bananas');
      expect(searchFoodItems(_items, 'jalapeno').single.id, 'chilli');
    });

    test('an unmatched query returns empty, not everything', () {
      expect(searchFoodItems(_items, 'zzzz'), isEmpty);
    });
  });

  test('foldForSearch strips case and accents', () {
    expect(foldForSearch('Plátano'), 'platano');
    expect(foldForSearch('JALAPEÑO'), 'jalapeno');
  });

  group('searchFoodItems aliases', () {
    // Umbrella items are the whole point: nobody searches "Root
    // vegetables", they search "carrots".
    final umbrella = <FoodItem>[
      _item(
        'root_vegetables',
        'vegetables',
        'Root vegetables',
        termsEn: ['carrot', 'carrots', 'parsnip'],
        termsJa: ['にんじん'],
        termsEs: ['zanahoria'],
      ),
      _item('potatoes', 'staples', 'Potatoes', termsEn: ['chips', 'fries']),
      _item(
        'fish_wild',
        'seafood',
        'Fish (wild-caught)',
        termsEn: ['cod', 'chip shop fish'],
      ),
      _item('carrot_cake', 'treats', 'Carrot cake'),
    ];

    test('a member term finds its umbrella item', () {
      expect(
        searchFoodItems(umbrella, 'carrots').first.nameEn,
        'Root vegetables',
      );
      expect(
        searchFoodItems(umbrella, 'parsnip').single.nameEn,
        'Root vegetables',
      );
    });

    test('a name match outranks an alias match', () {
      // "Carrot cake" owns the word; Root vegetables merely lists it.
      final ranked = searchFoodItems(umbrella, 'carrot');
      expect(ranked.first.nameEn, 'Carrot cake');
      expect(ranked.map((i) => i.nameEn), contains('Root vegetables'));
    });

    test('a whole-term alias outranks a substring alias', () {
      // Potatoes list "chips"; the fish item only contains it inside
      // "chip shop fish".
      expect(searchFoodItems(umbrella, 'chips').first.nameEn, 'Potatoes');
    });

    test('aliases match regardless of the query language', () {
      for (final query in ['zanahoria', 'にんじん', 'carrots']) {
        expect(
          searchFoodItems(umbrella, query).map((i) => i.nameEn),
          contains('Root vegetables'),
          reason: query,
        );
      }
    });

    test('an unaliased word still matches nothing', () {
      expect(searchFoodItems(umbrella, 'yoghurt'), isEmpty);
    });
  });

  group('FoodItemPicker', () {
    Widget harness({required void Function(FoodItem) onSelected}) =>
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FoodItemPicker(
              items: _items,
              onSelected: onSelected,
              onInfo: (_) {},
            ),
          ),
        );

    testWidgets('shows group headers until the user searches', (tester) async {
      await tester.pumpWidget(harness(onSelected: (_) {}));
      expect(find.text('Meat'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'tofu');
      await tester.pump();

      expect(find.text('Tofu'), findsOneWidget);
      expect(find.text('Beef'), findsNothing);
      expect(find.text('Meat'), findsNothing);
    });

    testWidgets('a non-matching query says so instead of going blank', (
      tester,
    ) async {
      await tester.pumpWidget(harness(onSelected: (_) {}));
      await tester.enterText(find.byType(TextField), 'zzzz');
      await tester.pump();

      expect(find.text('No foods match that search.'), findsOneWidget);
    });

    testWidgets('a filtered row is still selectable', (tester) async {
      FoodItem? picked;
      await tester.pumpWidget(harness(onSelected: (item) => picked = item));
      await tester.enterText(find.byType(TextField), 'platano');
      await tester.pump();
      await tester.tap(find.text('Bananas'));

      expect(picked?.id, 'bananas');
    });

    testWidgets('builds lazily -- offscreen rows are not constructed', (
      tester,
    ) async {
      // The reason this widget exists: the old picker built every tile
      // in a plain Column, so a 175-item dataset built 175 tiles on
      // every rebuild and put the tail ~20 screens out of reach.
      final many = [
        for (var i = 0; i < 300; i++) _item('item$i', 'meat', 'Food $i'),
      ];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FoodItemPicker(
              items: many,
              onSelected: (_) {},
              onInfo: (_) {},
            ),
          ),
        ),
      );

      expect(
        find.byType(ListTile, skipOffstage: false).evaluate().length,
        lessThan(300),
      );
      expect(find.text('Food 299'), findsNothing);
    });
  });

  group('FoodItemPicker rows', () {
    Widget buildPickerWith(List<FoodItem> items, List<String> recentIds) =>
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: FoodItemPicker(
              items: items,
              recentIds: recentIds,
              onSelected: (_) {},
              onInfo: (_) {},
            ),
          ),
        );

    testWidgets('recents lead the list without leaving their own group', (
      tester,
    ) async {
      await tester.pumpWidget(buildPickerWith(_items, const ['tofu']));
      await tester.pumpAndSettle();

      expect(find.text('Recent'), findsOneWidget);
      // Once under Recent, once under its own group heading.
      expect(find.text('Tofu'), findsNWidgets(2));
    });

    testWidgets('an unknown recent id is skipped, not rendered blank', (
      tester,
    ) async {
      await tester.pumpWidget(buildPickerWith(_items, const ['unicorn']));
      await tester.pumpAndSettle();
      expect(find.text('Recent'), findsNothing);
    });

    testWidgets('a narrower-boundary row says so on its own tile', (
      tester,
    ) async {
      // Required before any non-tier-1 row can sit next to the tier-1
      // anchors: a farm-gate figure reads 20-30% low against this
      // dataset's cradle-to-retail boundary.
      const squid = FoodItem(
        id: 'squid',
        group: 'seafood',
        nameEn: 'Squid',
        nameJa: '',
        nameEs: '',
        kgCo2ePerKg: 8.18,
        sourceTier: 2,
        weightBasis: 'edible',
      );
      await tester.pumpWidget(buildPickerWith(const [squid], const []));
      await tester.pumpAndSettle();

      expect(find.textContaining('shorter supply chain'), findsOneWidget);
      expect(find.textContaining('Edible weight'), findsOneWidget);
    });
  });
}
