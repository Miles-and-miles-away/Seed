import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/widgets/sdg_filter_chips.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';

void main() {
  group('SdgFilterChips', () {
    Widget createTestWidget() {
      return ProviderScope(
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SdgFilterChips(),
          ),
        ),
      );
    }

    testWidgets('renders as horizontal ListView', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays All chip as first item', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('displays visible chips in horizontal list', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // ListView only renders visible chips; we expect All + some SDG chips
      // The total count depends on viewport size, but we should have at least 4
      expect(find.byType(FilterChip), findsAtLeast(4));
    });

    testWidgets('All chip is selected by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the "All" FilterChip and check it's selected
      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      expect(allChipFinder, findsOneWidget);

      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isTrue);
    });

    testWidgets('SDG chip shows number in avatar when not selected',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // SDG 1 should show "1" in its avatar
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('SDG chips show short titles', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Check for visible SDG short titles (first few that fit in viewport)
      expect(find.text('No Poverty'), findsOneWidget);
      expect(find.text('Zero Hunger'), findsOneWidget);
      // Note: Later SDGs like "Climate Action" may not be visible without scrolling
    });

    testWidgets('selecting SDG chip deselects All chip', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on No Poverty (SDG 1) - visible without scrolling
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // All chip should not be selected
      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isFalse);

      // No Poverty chip should be selected
      final noPovertyChipFinder = find.ancestor(
        of: find.text('No Poverty'),
        matching: find.byType(FilterChip),
      );
      final noPovertyChip = tester.widget<FilterChip>(noPovertyChipFinder);
      expect(noPovertyChip.selected, isTrue);
    });

    testWidgets('SDG chips have colored avatars', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should find CircleAvatars for visible unselected SDG chips
      // ListView only renders visible items, so we check for at least a few
      expect(find.byType(CircleAvatar), findsAtLeast(3));
    });

    testWidgets('has fixed height of 40', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.byType(ListView),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.height, 40);
    });

    testWidgets('chips are scrollable horizontally', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, Axis.horizontal);
    });

    testWidgets('tapping selected SDG chip clears selection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select No Poverty (visible without scrolling)
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // Tap No Poverty again to deselect
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // All should be selected now
      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isTrue);
    });

    testWidgets('tapping All chip when SDG is selected clears selection',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select an SDG first (visible without scrolling)
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // Tap All chip
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // After rebuild, All should be selected
      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isTrue);
    });

    testWidgets('SDG colors match official SDG colors', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify that SDG 1 (No Poverty) has the correct red color
      final sdg1 = sdgGoals.firstWhere((g) => g.number == 1);
      expect(sdg1.color, const Color(0xFFE5233D));

      // Verify that SDG 13 (Climate Action) has the correct green color
      final sdg13 = sdgGoals.firstWhere((g) => g.number == 13);
      expect(sdg13.color, const Color(0xFF407F46));
    });
  });
}
