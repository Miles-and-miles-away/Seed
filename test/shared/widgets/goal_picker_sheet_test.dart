import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/goal_picker_sheet.dart';

void main() {
  Widget createTestWidget({String? initialGoal}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final goal = await GoalPickerSheet.show(
                context,
                initialGoal: initialGoal,
              );
              if (goal != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('result:$goal')),
                );
              }
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  Future<void> openSheet(WidgetTester tester) async {
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  // The sheet content is taller than the test viewport; scroll the
  // sheet's scrollable until the target is tappable.
  Future<void> scrollSheetTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  group('localizedPersonalGoal', () {
    testWidgets('resolves preset IDs and passes through custom text',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      final context = tester.element(find.text('open'));
      final l10n = AppLocalizations.of(context);

      expect(localizedPersonalGoal('save_world', l10n), 'Save the world');
      expect(
        localizedPersonalGoal('Plant 100 trees', l10n),
        'Plant 100 trees',
      );
    });
  });

  group('GoalPickerSheet', () {
    testWidgets('renders all presets and custom option', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openSheet(tester);

      expect(find.text('Choose your goal'), findsOneWidget);
      expect(find.text('Reduce long-haul flights'), findsOneWidget);
      expect(find.text('Save the world'), findsOneWidget);
      expect(find.text('Write your own'), findsOneWidget);
    });

    testWidgets('save is disabled until an option is selected', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openSheet(tester);

      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('selecting a preset and saving returns its ID', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openSheet(tester);

      await tester.tap(find.text('Save the world'));
      await tester.pumpAndSettle();
      await scrollSheetTo(tester, find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('result:save_world'), findsOneWidget);
    });

    testWidgets('custom option shows text field and returns trimmed text',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openSheet(tester);

      await scrollSheetTo(tester, find.text('Write your own'));
      await tester.tap(find.text('Write your own'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '  Plant 100 trees  ');
      await tester.pumpAndSettle();
      await scrollSheetTo(tester, find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('result:Plant 100 trees'), findsOneWidget);
    });

    testWidgets('empty custom text keeps save disabled', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await openSheet(tester);

      await tester.tap(find.text('Write your own'));
      await tester.pumpAndSettle();

      final saveButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Save'),
      );
      expect(saveButton.onPressed, isNull);
    });

    testWidgets('preselects stored preset goal', (tester) async {
      await tester.pumpWidget(createTestWidget(initialGoal: 'plant_based'));
      await openSheet(tester);

      final tile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Eat more plant-based meals'),
      );
      expect(tile.selected, isTrue);
    });

    testWidgets('preselects custom option for stored free text',
        (tester) async {
      await tester.pumpWidget(
        createTestWidget(initialGoal: 'Plant 100 trees'),
      );
      await openSheet(tester);

      expect(find.text('Plant 100 trees'), findsOneWidget);
      final tile = tester.widget<ListTile>(
        find.widgetWithText(ListTile, 'Write your own'),
      );
      expect(tile.selected, isTrue);
    });
  });
}
