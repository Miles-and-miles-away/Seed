import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
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

import '../../../../helpers/test_helpers.dart';

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
      // The energy category needs a library action of its own: an empty
      // filter result shows the "no actions" state with no tiles at all.
      const ActionModel(
        id: 'action4',
        nameEn: 'Switch Off Standby',
        nameJa: '待機電力を切る',
        category: 'energy',
        points: 10,
        iconName: 'bolt',
      ),
    ];

    const testUser = AppUserModel(
      uid: 'test-uid',
      email: 'test@example.com',
      // ignore: avoid_redundant_argument_values
      language: 'en',
    );

    Widget buildScreen({
      List<ActionModel>? actions,
      String? initialCategory,
      bool isLoading = false,
      double textScale = 1.0,
    }) {
      return createTestWidget(
        overrides: [
          userOverride(testUser),
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
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: ActionLogScreen(initialCategory: initialCategory),
        ),
      );
    }

    testWidgets('displays app bar with title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Log an Action'), findsOneWidget);
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
            userOverride(testUser),
            actionLibraryProvider.overrideWith((ref) async => testActions),
            filteredActionsProvider.overrideWith(
              (ref) => AsyncValue.data(testActions),
            ),
          ],
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
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
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('pre-selects filter from initialCategory', (tester) async {
      await tester.pumpWidget(buildScreen(initialCategory: 'transport'));
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
      await tester.pumpWidget(buildScreen(initialCategory: 'not-a-category'));
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
        createTestWidget(
          overrides: [
            userOverride(testUser),
            actionLibraryProvider.overrideWith((ref) async => testActions),
          ],
          child: const ActionLogScreen(initialCategory: 'transport'),
        ),
      );
      await tester.pumpAndSettle();

      // Only the single transport action survives the real filter.
      expect(find.byType(ActionCard), findsOneWidget);
      expect(find.text('Bike to Work'), findsOneWidget);
    });

    testWidgets('displays action cards when data is loaded', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(ActionCard), findsAtLeast(1));
    });

    testWidgets('displays loading indicator when loading', (tester) async {
      await tester.pumpWidget(buildScreen(isLoading: true));
      // Use pump instead of pumpAndSettle for loading states
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays empty state when no actions match filter', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen(actions: []));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });

    testWidgets('search field has clear button when text entered', (
      tester,
    ) async {
      await tester.pumpWidget(buildScreen());
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
      await tester.pumpWidget(buildScreen());
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

    testWidgets('tiles are as tall as their content, not taller', (
      tester,
    ) async {
      // A 0.9 aspect ratio made a 179pt-wide cell 199pt tall while the
      // tallest tile drew 180, leaving ~10pt of dead space above and
      // below every card.
      tester.view.physicalSize = const Size(402, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      final tile = tester.getRect(find.byType(ActionTile).first);
      expect(tile.height, lessThan(190));
      expect(tile.height, greaterThan(170));
    });

    testWidgets('tiles still fit their content at larger text scales', (
      tester,
    ) async {
      // The trim must not come out of accessibility: the cell grows
      // with the text scale, because the text block is the only part
      // of a tile that does.
      for (final scale in [1.0, 1.3, 2.0]) {
        tester.view.physicalSize = const Size(402, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(buildScreen(textScale: scale));
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'a tile overflowed at text scale $scale',
        );
      }
    });

    testWidgets('grid has 2 columns', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('displays correct number of action cards', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Should display action cards for test data (some may be off-screen in GridView)
      expect(find.byType(ActionCard), findsAtLeast(2));
    });

    testWidgets('displays SDG filter chips', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byType(SdgFilterChips), findsOneWidget);
    });

    testWidgets('the sort control shares the search row', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // It used to sit on a row of its own, right-aligned, with dead
      // space beside it. Same row now, and icon-only so the search
      // field keeps its width.
      expect(find.byIcon(Icons.sort), findsOneWidget);
      final search = tester.getRect(find.byType(TextField).first);
      final sort = tester.getRect(find.byType(ActionSortDropdown));
      expect(sort.center.dy, closeTo(search.center.dy, 1));
      expect(sort.left, greaterThan(search.right));
      // The labelled chip left the field 107px wide on a 360pt phone.
      expect(search.width, greaterThan(250));
    });

    testWidgets('SDG filter shows All chip', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsAtLeast(1));
    });

    // Only transport and food get a grid tile: both bank the choice
    // their calculator produces. Energy banks nothing (decision 8.18),
    // so a tile in a grid of loggable actions would promise a log it
    // cannot deliver -- its calculator lives in the AppBar chooser and
    // its two teaching surfaces are AppBar icons (decision E8).
    //
    // The grid needs a tall viewport here: at the default 800x600 the
    // second row of tiles is never built, so a missing tile and an
    // off-screen one look the same.
    void useTallView(WidgetTester tester) {
      tester.view.physicalSize = const Size(400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }

    testWidgets('the energy category shows actions only, no calculator tile', (
      tester,
    ) async {
      useTallView(tester);
      await tester.pumpWidget(buildScreen(initialCategory: 'energy'));
      await tester.pumpAndSettle();

      expect(find.text('Compare home energy use'), findsNothing);
      expect(find.text('Where your energy goes'), findsNothing);
      // Just the one energy action, and its own tile is the only one.
      expect(find.byType(ActionCard), findsOneWidget);
      expect(find.text('Switch Off Standby'), findsOneWidget);
      expect(find.byType(ActionTile), findsNWidgets(1));
    });

    testWidgets('the transport category still shows exactly one tile', (
      tester,
    ) async {
      useTallView(tester);
      await tester.pumpWidget(buildScreen(initialCategory: 'transport'));
      await tester.pumpAndSettle();

      expect(find.text('Log a Custom Transport action'), findsOneWidget);
      expect(find.byType(ActionTile), findsNWidgets(2));
    });

    testWidgets('the food category still shows exactly one tile', (
      tester,
    ) async {
      useTallView(tester);
      await tester.pumpWidget(buildScreen(initialCategory: 'food'));
      await tester.pumpAndSettle();

      expect(find.text('Log a Custom Food action'), findsOneWidget);
      expect(find.byType(ActionTile), findsNWidgets(2));
    });

    testWidgets('an empty filter result still shows no tiles', (tester) async {
      // Shipped behavior: a search that matches nothing must not leave
      // the calculator tile orphaned above the empty state. Transport,
      // because that is a category that still has a tile to orphan.
      await tester.pumpWidget(
        buildScreen(actions: [], initialCategory: 'transport'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.byType(ActionTile), findsNothing);
    });

    testWidgets('the AppBar carries the two energy surfaces in every '
        'category', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Beside the calculator chooser, and not category-dependent: the
      // discoverability problem E8 resolved was being buried two taps
      // deep.
      expect(find.byIcon(Icons.calculate_outlined), findsOneWidget);
      // The bolt is the app's own energy glyph; the quiz tooltip is
      // domain-neutral because the game rotates all three datasets.
      // Scoped to the bar: an energy action card carries a bolt too.
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.bolt),
        ),
        findsOneWidget,
      );
      expect(find.byTooltip('Where your energy goes'), findsOneWidget);
      expect(find.byTooltip('Higher or lower?'), findsOneWidget);
    });

    testWidgets('the energy AppBar icons push their own routes', (
      tester,
    ) async {
      Widget stub(String label) => Scaffold(body: Text(label));
      final router = GoRouter(
        initialLocation: '/log-action',
        routes: [
          GoRoute(
            path: '/log-action',
            builder: (_, _) => const ActionLogScreen(),
          ),
          GoRoute(
            path: '/energy-explore',
            builder: (_, _) => stub('Explore Screen'),
          ),
          GoRoute(path: '/quiz', builder: (_, _) => stub('Quiz Screen')),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userOverride(testUser),
            actionLibraryProvider.overrideWith((ref) async => testActions),
          ],
          child: MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Where your energy goes'));
      await tester.pumpAndSettle();
      expect(find.text('Explore Screen'), findsOneWidget);

      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Higher or lower?'));
      await tester.pumpAndSettle();
      expect(find.text('Quiz Screen'), findsOneWidget);
    });
  });
}
