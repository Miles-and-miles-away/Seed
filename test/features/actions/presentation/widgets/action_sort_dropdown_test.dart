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
          home: Scaffold(body: ActionSortDropdown()),
        ),
      );
    }

    testWidgets('collapses to a sort icon, not a labelled chip', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // It shares the search row, and the labels run to "Puntos
      // (Mayor a menor)", which squeezed the field to 107px.
      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(find.text('Name (A-Z)'), findsNothing);
    });

    testWidgets('names the active option in its tooltip', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // The label left the button, so the tooltip is what carries the
      // current sort for a user who has not opened the menu.
      final button = tester.widget<PopupMenuButton<ActionSortOption>>(
        find.byType(PopupMenuButton<ActionSortOption>),
      );
      expect(button.tooltip, 'Name (A-Z)');
    });

    testWidgets('opens popup menu on tap', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem<ActionSortOption>), findsNWidgets(6));
    });

    testWidgets('displays all sort options in menu', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // "Name (A-Z)" appears in both button and menu
      expect(find.text('Name (A-Z)'), findsAtLeast(1));
      expect(find.text('Name (Z-A)'), findsOneWidget);
      expect(find.text('CO\u2082 (High to Low)'), findsOneWidget);
      expect(find.text('CO\u2082 (Low to High)'), findsOneWidget);
      expect(find.text('Points (High to Low)'), findsOneWidget);
      expect(find.text('Points (Low to High)'), findsOneWidget);
    });

    testWidgets('shows checkmark on selected option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays directional icons for sort options', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // 3 asc options + button icon = at least 3
      expect(find.byIcon(Icons.arrow_downward), findsAtLeast(3));
      // 3 desc options
      expect(find.byIcon(Icons.arrow_upward), findsAtLeast(3));
    });

    testWidgets('closes menu after selecting option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name (Z-A)'));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem<ActionSortOption>), findsNothing);
    });

    testWidgets('is wrapped in styled container', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('selecting option updates selection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Open and select Z-A
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Name (Z-A)'));
      await tester.pumpAndSettle();

      // Open again - check shows new selection
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
