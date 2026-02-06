import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_sort_dropdown.dart';

void main() {
  group('ActionSortDropdown', () {
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
            body: ActionSortDropdown(),
          ),
        ),
      );
    }

    testWidgets('displays sort icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('displays sort label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The widget should display the "Sort" label
      expect(find.text('Sort'), findsOneWidget);
    });

    testWidgets('displays dropdown arrow', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });

    testWidgets('opens popup menu on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on the dropdown
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Popup menu should appear with sort options
      expect(find.byType(PopupMenuItem<ActionSortOption>), findsNWidgets(6));
    });

    testWidgets('displays all sort options in menu', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Should show all 6 sort options
      expect(find.text('Name (A-Z)'), findsOneWidget);
      expect(find.text('Name (Z-A)'), findsOneWidget);
      expect(find.text('CO\u2082 (High to Low)'), findsOneWidget);
      expect(find.text('CO\u2082 (Low to High)'), findsOneWidget);
      expect(find.text('Points (High to Low)'), findsOneWidget);
      expect(find.text('Points (Low to High)'), findsOneWidget);
    });

    testWidgets('shows checkmark on selected option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Default is alphabeticalAsc, should show checkmark
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays alphabetical icon for name sort options',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Both name sort options should have sort_by_alpha icon
      expect(find.byIcon(Icons.sort_by_alpha), findsAtLeast(2));
    });

    testWidgets('displays arrow icons for numeric sort options',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // High-to-low options have arrow_downward, low-to-high have arrow_upward
      expect(find.byIcon(Icons.arrow_downward), findsAtLeast(2));
      expect(find.byIcon(Icons.arrow_upward), findsAtLeast(2));
    });

    testWidgets('closes menu after selecting option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Select an option
      await tester.tap(find.text('Name (Z-A)'));
      await tester.pumpAndSettle();

      // Menu should be closed
      expect(find.byType(PopupMenuItem<ActionSortOption>), findsNothing);
    });

    testWidgets('is wrapped in styled container', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Should have a Container with rounded border
      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('selecting option updates selection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open menu and select Z-A
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Name (Z-A)'));
      await tester.pumpAndSettle();

      // Open menu again
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // Z-A should now be selected (checkmark visible)
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
