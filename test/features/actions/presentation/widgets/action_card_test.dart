import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';

void main() {
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
      return MaterialApp(
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
      );
    }

    testWidgets('displays action name in English', (tester) async {
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
      await tester.pumpWidget(createTestWidget(
        onTap: () => tapped = true,
      ));
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

      expect(find.byIcon(Icons.directions_bike), findsOneWidget);
    });

    testWidgets('handles default eco icon', (tester) async {
      const ecoAction = ActionModel(
        id: 'action3',
        nameEn: 'Eco Action',
        nameJa: 'エコアクション',
        category: 'recycling',
        points: 10,
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
  });
}
