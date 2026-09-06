import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  late SdgGoalsData sdgData;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    sdgData = await loadSdgGoals();
  });

  group('ActionCard', () {
    const testAction = ActionModel(
      id: 'action1',
      nameEn: 'Recycle Aluminum Can',
      nameJa: 'アルミ缶リサイクル',
      descriptionEn: 'Recycle an aluminum can',
      descriptionJa: 'アルミ缶をリサイクルする',
      category: 'recycling',
      points: 5,
      co2Grams: 150,
      iconName: 'recycling',
    );

    Widget buildCard({
      ActionModel action = testAction,
      String languageCode = 'en',
      VoidCallback? onTap,
    }) {
      return createTestWidget(
        overrides: [sdgGoalsDataProvider.overrideWith((ref) async => sdgData)],
        scaffold: true,
        child: SizedBox(
          width: 200,
          height: 200,
          child: ActionCard(
            action: action,
            languageCode: languageCode,
            onTap: onTap ?? () {},
          ),
        ),
      );
    }

    testWidgets('displays action name in English', (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(buildCard(languageCode: 'en'));
      await tester.pumpAndSettle();

      expect(find.text('Recycle Aluminum Can'), findsOneWidget);
    });

    testWidgets('displays action name in Japanese', (tester) async {
      await tester.pumpWidget(buildCard(languageCode: 'ja'));
      await tester.pumpAndSettle();

      expect(find.text('アルミ缶リサイクル'), findsOneWidget);
    });

    testWidgets('displays points badge', (tester) async {
      await tester.pumpWidget(buildCard());
      await tester.pumpAndSettle();

      // Points should be displayed in a badge format
      expect(find.textContaining('5'), findsAtLeast(1));
    });

    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(buildCard());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.recycling), findsOneWidget);
    });

    testWidgets('is tappable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildCard(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('displays category color accent', (tester) async {
      await tester.pumpWidget(buildCard());
      await tester.pumpAndSettle();

      final accents = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.color == ActionCategory.recycling.color);
      expect(accents, isNotEmpty);
    });

    testWidgets('handles different icon names', (tester) async {
      const bikeAction = ActionModel(
        id: 'action2',
        nameEn: 'Bike to Work',
        nameJa: '自転車通勤',
        category: 'transport',
        points: 20,
        iconName: 'bike',
      );

      await tester.pumpWidget(buildCard(action: bikeAction));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.pedal_bike), findsOneWidget);
    });

    testWidgets('handles default eco icon', (tester) async {
      const ecoAction = ActionModel(
        id: 'action3',
        nameEn: 'Eco Action',
        nameJa: 'エコアクション',
        category: 'recycling',
        points: 10,
        // ignore: avoid_redundant_argument_values
        iconName: 'eco',
      );

      await tester.pumpWidget(buildCard(action: ecoAction));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    testWidgets('handles unknown icon name with fallback', (tester) async {
      const unknownIconAction = ActionModel(
        id: 'action4',
        nameEn: 'Unknown Icon Action',
        nameJa: '不明アイコン',
        category: 'recycling',
        points: 10,
        iconName: 'unknown_icon_name',
      );

      await tester.pumpWidget(buildCard(action: unknownIconAction));
      await tester.pumpAndSettle();

      // Should fall back to eco icon
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });

    group('SDG badges', () {
      testWidgets('displays SDG badges when action has related SDGs', (
        tester,
      ) async {
        const actionWithSdgs = ActionModel(
          id: 'action5',
          nameEn: 'Recycle Paper',
          nameJa: '紙リサイクル',
          category: 'recycling',
          points: 5,
          iconName: 'recycling',
          relatedSdgs: ['12', '13'],
        );

        await tester.pumpWidget(buildCard(action: actionWithSdgs));
        await tester.pumpAndSettle();

        // Should display SDG numbers 12 and 13
        expect(find.text('12'), findsOneWidget);
        expect(find.text('13'), findsOneWidget);
      });

      testWidgets('does not display SDG badges when no related SDGs', (
        tester,
      ) async {
        // testAction has no relatedSdgs
        await tester.pumpWidget(buildCard());
        await tester.pumpAndSettle();

        // Should not find any SDG numbers (1-17)
        for (var i = 1; i <= 17; i++) {
          expect(find.text('$i'), findsNothing);
        }
      });

      testWidgets('limits visible SDG badges to 3 with +N indicator', (
        tester,
      ) async {
        const actionWithManySdgs = ActionModel(
          id: 'action6',
          nameEn: 'Sustainable Action',
          nameJa: 'サステナブルアクション',
          category: 'consumption',
          points: 25,
          relatedSdgs: ['1', '2', '3', '4', '5'],
        );

        await tester.pumpWidget(buildCard(action: actionWithManySdgs));
        await tester.pumpAndSettle();

        // Should show first 3 SDGs
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);

        // Should show +2 indicator for remaining SDGs
        expect(find.text('+2'), findsOneWidget);
      });

      testWidgets('displays 4 badges without +N when exactly 4 SDGs', (
        tester,
      ) async {
        const actionWith4Sdgs = ActionModel(
          id: 'action7',
          nameEn: 'Four SDG Action',
          nameJa: '4つのSDGアクション',
          category: 'energy',
          points: 15,
          iconName: 'bolt',
          relatedSdgs: ['7', '11', '12', '13'],
        );

        await tester.pumpWidget(buildCard(action: actionWith4Sdgs));
        await tester.pumpAndSettle();

        // Should show all 4 SDGs
        expect(find.text('7'), findsOneWidget);
        expect(find.text('11'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
        expect(find.text('13'), findsOneWidget);

        // Should not show +N indicator
        expect(find.textContaining('+'), findsNothing);
      });

      testWidgets('filters out invalid SDG numbers', (tester) async {
        const actionWithInvalidSdgs = ActionModel(
          id: 'action8',
          nameEn: 'Invalid SDG Action',
          nameJa: '無効SDGアクション',
          category: 'water',
          points: 10,
          iconName: 'water_drop',
          relatedSdgs: ['0', '12', '18', '13', 'invalid'],
        );

        await tester.pumpWidget(buildCard(action: actionWithInvalidSdgs));
        await tester.pumpAndSettle();

        // Should only show valid SDGs (12 and 13)
        expect(find.text('12'), findsOneWidget);
        expect(find.text('13'), findsOneWidget);

        // Should not show invalid values
        expect(find.text('0'), findsNothing);
        expect(find.text('18'), findsNothing);
      });
    });
  });

  group('ActionTile badge', () {
    testWidgets('the label reads against its own tint', (tester) async {
      // The badge used the raw category colour on a 10% tint of itself,
      // about 1.5:1. The bar and the icon keep the raw colour; the
      // words do not.
      const category = ActionCategory.energy;
      await tester.pumpWidget(
        createTestWidget(
          scaffold: true,
          child: ActionTile(
            accentColor: category.color,
            contentColor: category.color,
            icon: Icons.bolt,
            title: 'Heat yourself, not the room',
            badgeLabel: '18 points',
            onTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final label = tester.widget<Text>(find.text('18 points'));
      final tint = category.color.withValues(alpha: opacityFaint);
      final onWhite = Color.alphaBlend(tint, Colors.white);
      expect(
        contrastRatio(label.style!.color!, onWhite),
        greaterThanOrEqualTo(4.5),
        reason: 'the badge label sits on a tint of its own colour',
      );
      // The icon is a graphic and keeps the category colour as it is.
      expect(
        tester.widget<Icon>(find.byIcon(Icons.bolt)).color,
        category.color,
      );
    });
  });
}
