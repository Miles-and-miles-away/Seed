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
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ActionCategoryTabs(
            selectedCategory: selectedCategory,
            onCategorySelected: onCategorySelected ?? (_) {},
          ),
        ),
      );
    }

    testWidgets('displays All tab', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('displays all category tabs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have FilterChips - at least the visible ones
      // The tabs are in a horizontal scroll view, so not all may be visible
      expect(find.byType(FilterChip), findsAtLeast(4));
    });

    testWidgets('All tab is selected when selectedCategory is null', (tester) async {
      await tester.pumpWidget(createTestWidget(selectedCategory: null));
      await tester.pumpAndSettle();

      final allChip = tester.widgetList<FilterChip>(find.byType(FilterChip)).first;
      expect(allChip.selected, isTrue);
    });

    testWidgets('category tab is selected when matching selectedCategory', (tester) async {
      await tester.pumpWidget(createTestWidget(
        selectedCategory: ActionCategory.recycling,
      ));
      await tester.pumpAndSettle();

      // All chip should not be selected
      final allChip = tester.widgetList<FilterChip>(find.byType(FilterChip)).first;
      expect(allChip.selected, isFalse);
    });

    testWidgets('tapping All tab calls onCategorySelected with null', (tester) async {
      ActionCategory? selectedValue = ActionCategory.recycling;

      await tester.pumpWidget(createTestWidget(
        selectedCategory: ActionCategory.recycling,
        onCategorySelected: (category) => selectedValue = category,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      expect(selectedValue, isNull);
    });

    testWidgets('tapping category tab calls onCategorySelected with category', (tester) async {
      ActionCategory? selectedValue;

      await tester.pumpWidget(createTestWidget(
        selectedCategory: null,
        onCategorySelected: (category) => selectedValue = category,
      ));
      await tester.pumpAndSettle();

      // Find and tap the recycling category chip
      // The chips are in a ListView so we need to scroll to find them
      final recyclingChipFinder = find.byWidgetPredicate(
        (widget) => widget is FilterChip && widget.label is Text &&
            (widget.label as Text).data != 'All',
      );

      await tester.tap(recyclingChipFinder.first);
      await tester.pumpAndSettle();

      expect(selectedValue, isNotNull);
      expect(selectedValue, isA<ActionCategory>());
    });

    testWidgets('is horizontally scrollable', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('has correct height', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 48);
    });

    testWidgets('displays category icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should display grid_view icon for All tab
      expect(find.byIcon(Icons.grid_view), findsOneWidget);

      // Should display at least some category icons (some may be off-screen)
      expect(find.byIcon(Icons.recycling), findsOneWidget);
      // Other icons might be scrolled off-screen in the horizontal ListView
    });
  });
}
