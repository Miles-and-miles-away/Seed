import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/widgets/sdg_filter_chips.dart';
import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

void main() {
  group('SdgFilterChips', () {
    late SdgGoalsData testData;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      testData = await loadSdgGoals();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [sdgGoalsDataProvider.overrideWith((ref) async => testData)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SdgFilterChips()),
        ),
      );
    }

    /// Scrolls the infinite list until [finder] is built
    /// and then ensures it is centered in the viewport.
    Future<void> scrollToVisible(WidgetTester tester, Finder finder) async {
      await tester.scrollUntilVisible(
        finder,
        -200,
        scrollable: find.byType(Scrollable),
      );
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
    }

    testWidgets('renders as horizontal ListView', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('displays All chip', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await scrollToVisible(tester, find.text('All'));

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('displays visible chips in horizontal list', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // ListView renders visible chips; expect at
      // least a few FilterChips
      expect(find.byType(FilterChip), findsAtLeast(4));
    });

    testWidgets('All chip is selected by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await scrollToVisible(tester, find.text('All'));

      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      expect(allChipFinder, findsOneWidget);

      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isTrue);
    });

    testWidgets('SDG chip shows number in avatar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to SDG 1
      await scrollToVisible(tester, find.text('No Poverty'));

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('SDG chips show short titles', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await scrollToVisible(tester, find.text('No Poverty'));
      expect(find.text('No Poverty'), findsOneWidget);

      await scrollToVisible(tester, find.text('Zero Hunger'));
      expect(find.text('Zero Hunger'), findsOneWidget);
    });

    testWidgets('selecting SDG chip deselects All chip', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Scroll to and tap No Poverty
      await scrollToVisible(tester, find.text('No Poverty'));
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // Scroll back to All - should not be selected
      await scrollToVisible(tester, find.text('All'));

      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isFalse);

      // Scroll back to No Poverty - should be selected
      await scrollToVisible(tester, find.text('No Poverty'));
      final sdgChipFinder = find.ancestor(
        of: find.text('No Poverty'),
        matching: find.byType(FilterChip),
      );
      final sdgChip = tester.widget<FilterChip>(sdgChipFinder);
      expect(sdgChip.selected, isTrue);
    });

    testWidgets('SDG chips have colored avatars', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

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

      // Select No Poverty
      await scrollToVisible(tester, find.text('No Poverty'));
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // Tap again to deselect
      await scrollToVisible(tester, find.text('No Poverty'));
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // All should be selected again
      await scrollToVisible(tester, find.text('All'));
      final allChipFinder = find.ancestor(
        of: find.text('All'),
        matching: find.byType(FilterChip),
      );
      final allChip = tester.widget<FilterChip>(allChipFinder);
      expect(allChip.selected, isTrue);
    });

    testWidgets('tapping All chip when SDG selected clears it', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select an SDG first
      await scrollToVisible(tester, find.text('No Poverty'));
      await tester.tap(find.text('No Poverty'));
      await tester.pumpAndSettle();

      // Tap All chip
      await scrollToVisible(tester, find.text('All'));
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();

      // All should be selected
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

      final sdg1 = testData.goals.firstWhere((g) => g.number == 1);
      expect(sdg1.color, const Color(0xFFE5233D));

      final sdg13 = testData.goals.firstWhere((g) => g.number == 13);
      expect(sdg13.color, const Color(0xFF407F46));
    });
  });
}
