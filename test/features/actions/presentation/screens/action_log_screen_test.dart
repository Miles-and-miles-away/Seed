import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/screens/action_log_screen.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_category_tabs.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

void main() {
  group('ActionLogScreen', () {
    final testActions = [
      const ActionModel(
        id: 'action1',
        nameEn: 'Recycle Aluminum Can',
        nameJa: 'アルミ缶リサイクル',
        category: 'recycling',
        points: 5,
        iconName: 'recycling',
      ),
      const ActionModel(
        id: 'action2',
        nameEn: 'Bike to Work',
        nameJa: '自転車通勤',
        category: 'transport',
        points: 20,
        iconName: 'bike',
      ),
      const ActionModel(
        id: 'action3',
        nameEn: 'Meatless Meal',
        nameJa: '肉なしの食事',
        category: 'food',
        points: 15,
        iconName: 'restaurant',
      ),
    ];

    const testUser = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
      // ignore: avoid_redundant_argument_values
      language: 'en',
    );

    Widget createTestWidget({
      List<ActionModel>? actions,
      ActionCategory? selectedCategory,
      bool isLoading = false,
    }) {
      return ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(
            (ref) => Stream.value(testUser),
          ),
          actionLibraryProvider.overrideWith((ref) {
            if (isLoading) {
              return const Stream.empty();
            }
            return Stream.value(actions ?? testActions);
          }),
          filteredActionsProvider.overrideWith((ref) {
            final selected = ref.watch(selectedCategoryProvider);
            final allActions = actions ?? testActions;
            if (selected == null) return allActions;
            return allActions
                .where((a) => a.category == selected.name)
                .toList();
          }),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActionLogScreen(),
        ),
      );
    }

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays search text field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('displays category tabs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ActionCategoryTabs), findsOneWidget);
    });

    testWidgets('displays action cards when data is loaded', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ActionCard), findsAtLeast(1));
    });

    testWidgets('displays loading indicator when loading', (tester) async {
      await tester.pumpWidget(createTestWidget(isLoading: true));
      // Use pump instead of pumpAndSettle for loading states
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays GridView for actions', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays empty state when no actions match filter', (tester) async {
      await tester.pumpWidget(createTestWidget(actions: []));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('search field has clear button when text entered', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially no clear button
      expect(find.byIcon(Icons.clear), findsNothing);

      // Enter text in search field
      await tester.enterText(find.byType(TextField), 'recycle');
      await tester.pump();

      // Clear button should appear
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clear button clears search text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter text
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Text field should be empty
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });

    testWidgets('grid has 2 columns', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('displays correct number of action cards', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display action cards for test data (some may be off-screen in GridView)
      expect(find.byType(ActionCard), findsAtLeast(2));
    });
  });
}
