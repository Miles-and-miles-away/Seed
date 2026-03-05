import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_category_tabs.dart';

void main() {
  group('ActionCategoryTabs', () {
    Widget createTestWidget({
      ActionCategory? selectedCategory,
      ValueChanged<ActionCategory?>? onCategorySelected,
    }) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:
            AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ActionCategoryTabs(
            selectedCategory: selectedCategory,
            onCategorySelected:
                onCategorySelected ?? (_) {},
          ),
        ),
      );
    }

    /// Scrolls left until [finder] becomes visible.
    Future<void> scrollToVisible(
      WidgetTester tester,
      Finder finder,
    ) async {
      await tester.scrollUntilVisible(
        finder,
        -200,
        scrollable: find.byType(Scrollable),
        maxScrolls: 50,
      );
    }

    testWidgets(
      'displays All tab',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await scrollToVisible(
          tester,
          find.text('All'),
        );
        expect(find.text('All'), findsOneWidget);
      },
    );

    testWidgets(
      'displays all category tabs',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.byType(FilterChip),
          findsAtLeast(4),
        );
      },
    );

    testWidgets(
      'All tab is selected when selectedCategory is null',
      (tester) async {
        await tester.pumpWidget(
          // ignore: avoid_redundant_argument_values
          createTestWidget(selectedCategory: null),
        );
        await tester.pumpAndSettle();

        await scrollToVisible(
          tester,
          find.text('All'),
        );

        final allChipFinder = find.ancestor(
          of: find.text('All'),
          matching: find.byType(FilterChip),
        );
        final allChip =
            tester.widget<FilterChip>(allChipFinder);
        expect(allChip.selected, isTrue);
      },
    );

    testWidgets(
      'category tab is selected when matching',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            selectedCategory: ActionCategory.recycling,
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to All - should not be selected
        await scrollToVisible(
          tester,
          find.text('All'),
        );
        final allChipFinder = find.ancestor(
          of: find.text('All'),
          matching: find.byType(FilterChip),
        );
        final allChip =
            tester.widget<FilterChip>(allChipFinder);
        expect(allChip.selected, isFalse);
      },
    );

    testWidgets(
      'tapping All calls onCategorySelected with null',
      (tester) async {
        ActionCategory? selectedValue =
            ActionCategory.recycling;

        await tester.pumpWidget(
          createTestWidget(
            selectedCategory: ActionCategory.recycling,
            onCategorySelected: (category) =>
                selectedValue = category,
          ),
        );
        await tester.pumpAndSettle();

        await scrollToVisible(
          tester,
          find.text('All'),
        );
        await tester.tap(find.text('All'));
        await tester.pumpAndSettle();

        expect(selectedValue, isNull);
      },
    );

    testWidgets(
      'tapping category calls onCategorySelected',
      (tester) async {
        ActionCategory? selectedValue;

        await tester.pumpWidget(
          createTestWidget(
            // ignore: avoid_redundant_argument_values
            selectedCategory: null,
            onCategorySelected: (category) =>
                selectedValue = category,
          ),
        );
        await tester.pumpAndSettle();

        // Scroll to Recycling tab and tap it
        await scrollToVisible(
          tester,
          find.text('Recycling'),
        );
        await tester.tap(find.text('Recycling'));
        await tester.pumpAndSettle();

        expect(selectedValue, ActionCategory.recycling);
      },
    );

    testWidgets(
      'is horizontally scrollable',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);

        final listView = tester.widget<ListView>(
          find.byType(ListView),
        );
        expect(
          listView.scrollDirection,
          Axis.horizontal,
        );
      },
    );

    testWidgets(
      'has correct height',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find.byType(SizedBox).first,
        );
        expect(sizedBox.height, 48);
      },
    );

    testWidgets(
      'displays category icons',
      (tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Scroll to All tab - grid_view icon
        await scrollToVisible(
          tester,
          find.text('All'),
        );
        expect(
          find.byIcon(Icons.grid_view),
          findsOneWidget,
        );

        // Scroll to Recycling tab
        await scrollToVisible(
          tester,
          find.text('Recycling'),
        );
        expect(
          find.byIcon(Icons.recycling),
          findsOneWidget,
        );
      },
    );
  });
}
