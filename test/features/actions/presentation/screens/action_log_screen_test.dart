import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/screens/action_log_screen.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_card.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_category_tabs.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_sort_dropdown.dart';
import 'package:seed_app/features/actions/presentation/widgets/sdg_filter_chips.dart';
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
      String? initialCategory,
      bool isLoading = false,
    }) {
      return ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
          actionLibraryProvider.overrideWith((ref) {
            if (isLoading) {
              // Never completes: keeps the provider in loading state.
              return Completer<List<ActionModel>>().future;
            }
            return Future.value(actions ?? testActions);
          }),
          filteredActionsProvider.overrideWith((ref) {
            if (isLoading) {
              return const AsyncValue<List<ActionModel>>.loading();
            }
            final selected = ref.watch(selectedCategoryProvider);
            final allActions = actions ?? testActions;
            if (selected == null) {
              return AsyncValue.data(allActions);
            }
            return AsyncValue.data(
              allActions.where((a) => a.category == selected.name).toList(),
            );
          }),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: ActionLogScreen(initialCategory: initialCategory),
        ),
      );
    }

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays the shared bottom navigation bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(AppBottomNav), findsOneWidget);
    });

    testWidgets('bottom nav tab leaves the action log for the shell route', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/log-action',
        routes: [
          GoRoute(
            path: '/log-action',
            builder: (_, _) => const ActionLogScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: Text('Home Screen')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
            actionLibraryProvider.overrideWith((ref) async => testActions),
            filteredActionsProvider.overrideWith(
              (ref) => AsyncValue.data(testActions),
            ),
          ],
          child: MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.byType(ActionLogScreen), findsNothing);
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

    testWidgets('pre-selects filter from initialCategory', (tester) async {
      await tester.pumpWidget(createTestWidget(initialCategory: 'transport'));
      await tester.pumpAndSettle();

      expect(
        ProviderScope.containerOf(
          tester.element(find.byType(ActionCategoryTabs)),
        ).read(selectedCategoryProvider),
        ActionCategory.transport,
      );
      // Only the single transport action passes the filter.
      expect(find.byType(ActionCard), findsOneWidget);
    });

    testWidgets('shows all actions when initialCategory is unknown', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(initialCategory: 'not-a-category'),
      );
      await tester.pumpAndSettle();

      expect(
        ProviderScope.containerOf(
          tester.element(find.byType(ActionCategoryTabs)),
        ).read(selectedCategoryProvider),
        isNull,
      );
      expect(find.byType(ActionCard), findsAtLeast(2));
    });

    // End-to-end through the REAL filter chain (no filteredActionsProvider
    // override) to prove initialCategory actually narrows the grid.
    testWidgets('initialCategory filters the real action grid', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => Stream.value(testUser)),
            actionLibraryProvider.overrideWith((ref) async => testActions),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ActionLogScreen(initialCategory: 'transport'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Only the single transport action survives the real filter.
      expect(find.byType(ActionCard), findsOneWidget);
      expect(find.text('Bike to Work'), findsOneWidget);
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

    testWidgets('displays empty state when no actions match filter', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(actions: []));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('search field has clear button when text entered', (
      tester,
    ) async {
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
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('displays correct number of action cards', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display action cards for test data (some may be off-screen in GridView)
      expect(find.byType(ActionCard), findsAtLeast(2));
    });

    testWidgets('displays sort dropdown', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ActionSortDropdown), findsOneWidget);
    });

    testWidgets('displays SDG filter chips', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SdgFilterChips), findsOneWidget);
    });

    testWidgets('sort dropdown shows Sort label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Name (A-Z)'), findsOneWidget);
    });

    testWidgets('SDG filter shows All chip', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsAtLeast(1));
    });
  });
}
