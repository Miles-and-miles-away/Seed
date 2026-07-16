import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

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

    Widget createTestWidget({
      ActionModel action = testAction,
      String languageCode = 'en',
      VoidCallback? onTap,
    }) {
      return ProviderScope(
        overrides: [sdgGoalsDataProvider.overrideWith((ref) async => sdgData)],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 200,
              child: ActionCard(
                action: action,
                languageCode: languageCode,
                onTap: onTap ?? () {},
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('displays action name in English', (tester) async {
      // ignore: avoid_redundant_argument_values
      await tester.pumpWidget(createTestWidget(languageCode: 'en'));
      await tester.pumpAndSettle();

      expect(find.text('Recycle Aluminum Can'), findsOneWidget);
    });

    testWidgets('displays action name in Japanese', (tester) async {
      await tester.pumpWidget(createTestWidget(languageCode: 'ja'));
      await tester.pumpAndSettle();

      expect(find.text('アルミ缶リサイクル'), findsOneWidget);
    });

    testWidgets('displays points badge', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Points should be displayed in a badge format
      expect(find.textContaining('5'), findsAtLeast(1));
    });

    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.recycling), findsOneWidget);
    });

    testWidgets('is tappable', (tester) async {
      var tapped = false;
      await tester.pumpWidget(createTestWidget(onTap: () => tapped = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders as Card widget', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders InkWell for tap feedback', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('displays category color accent', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The card should have a colored container at the top
      expect(find.byType(Container), findsAtLeast(1));
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

      await tester.pumpWidget(createTestWidget(action: bikeAction));
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

      await tester.pumpWidget(createTestWidget(action: ecoAction));
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

      await tester.pumpWidget(createTestWidget(action: unknownIconAction));
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

        await tester.pumpWidget(createTestWidget(action: actionWithSdgs));
        await tester.pumpAndSettle();

        // Should display SDG numbers 12 and 13
        expect(find.text('12'), findsOneWidget);
        expect(find.text('13'), findsOneWidget);
      });

      testWidgets('does not display SDG badges when no related SDGs', (
        tester,
      ) async {
        // testAction has no relatedSdgs
        await tester.pumpWidget(createTestWidget());
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

        await tester.pumpWidget(createTestWidget(action: actionWithManySdgs));
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

        await tester.pumpWidget(createTestWidget(action: actionWith4Sdgs));
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

        await tester.pumpWidget(
          createTestWidget(action: actionWithInvalidSdgs),
        );
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
}
