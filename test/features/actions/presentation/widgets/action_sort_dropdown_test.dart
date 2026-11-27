import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_sort_dropdown.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('ActionSortDropdown', () {
    Widget buildDropdown({Locale? locale}) => createTestWidget(
      overrides: [userIdProvider.overrideWithValue('test-uid')],
      scaffold: true,
      locale: locale,
      child: const ActionSortDropdown(),
    );

    Future<void> openMenu(WidgetTester tester) async {
      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();
    }

    ActionSortOption selected(WidgetTester tester) => ProviderScope.containerOf(
      tester.element(find.byType(ActionSortDropdown)),
    ).read(selectedSortOptionProvider);

    testWidgets('collapses to an icon, not a labelled chip', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      // It shares the search row, and the labels run to "Puntos
      // (Mayor a menor)", which squeezed the field to 107px.
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
      expect(find.text('Shuffle'), findsNothing);
    });

    testWidgets('the disc shows shuffle while random, sort after a pick', (
      tester,
    ) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.shuffle), findsOneWidget);
      expect(find.byIcon(Icons.sort), findsNothing);

      await openMenu(tester);
      await tester.tap(find.text('Points (High to Low)'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.sort), findsOneWidget);
      expect(find.byIcon(Icons.shuffle), findsNothing);
    });

    testWidgets('Shuffle is the first menu item, with the shuffle icon', (
      tester,
    ) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();
      await openMenu(tester);

      final first = find.byType(PopupMenuItem<ActionSortOption>).first;
      expect(
        tester.widget<PopupMenuItem<ActionSortOption>>(first).value,
        ActionSortOption.random,
      );
      expect(
        find.descendant(of: first, matching: find.text('Shuffle')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: first, matching: find.byIcon(Icons.shuffle)),
        findsOneWidget,
      );
    });

    testWidgets('tapping Shuffle selects random', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();
      await openMenu(tester);
      await tester.tap(find.text('Name (A-Z)'));
      await tester.pumpAndSettle();
      expect(selected(tester), ActionSortOption.alphabeticalAsc);

      await openMenu(tester);
      await tester.tap(find.text('Shuffle'));
      await tester.pumpAndSettle();

      expect(selected(tester), ActionSortOption.random);
    });

    for (final (locale, label) in [
      (const Locale('ja'), 'シャッフル'),
      (const Locale('es'), 'Aleatorio'),
    ]) {
      testWidgets('labels Shuffle in ${locale.languageCode}', (tester) async {
        await tester.pumpWidget(buildDropdown(locale: locale));
        await tester.pumpAndSettle();
        await openMenu(tester);

        expect(find.text(label), findsOneWidget);
      });
    }

    testWidgets('names the active option in its tooltip', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      // The label left the button, so the tooltip is what carries the
      // current sort for a user who has not opened the menu.
      final button = tester.widget<PopupMenuButton<ActionSortOption>>(
        find.byType(PopupMenuButton<ActionSortOption>),
      );
      expect(button.tooltip, 'Sort: Shuffle');
    });

    testWidgets('opens popup menu on tap', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(
        find.byType(PopupMenuItem<ActionSortOption>),
        findsNWidgets(ActionSortOption.values.length),
      );
    });

    testWidgets('displays all sort options in menu', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(find.text('Shuffle'), findsOneWidget);
      expect(find.text('Name (A-Z)'), findsOneWidget);
      expect(find.text('Name (Z-A)'), findsOneWidget);
      expect(find.text('CO\u2082 (High to Low)'), findsOneWidget);
      expect(find.text('CO\u2082 (Low to High)'), findsOneWidget);
      expect(find.text('Points (High to Low)'), findsOneWidget);
      expect(find.text('Points (Low to High)'), findsOneWidget);
    });

    testWidgets('shows checkmark on selected option', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('displays directional icons for sort options', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      // 3 asc options + button icon = at least 3
      expect(find.byIcon(Icons.arrow_downward), findsAtLeast(3));
      // 3 desc options
      expect(find.byIcon(Icons.arrow_upward), findsAtLeast(3));
    });

    testWidgets('closes menu after selecting option', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ActionSortDropdown));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Name (Z-A)'));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem<ActionSortOption>), findsNothing);
    });

    testWidgets('is wrapped in styled container', (tester) async {
      await tester.pumpWidget(buildDropdown());
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsAtLeast(1));
    });

    testWidgets('selecting option updates selection', (tester) async {
      await tester.pumpWidget(buildDropdown());
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
