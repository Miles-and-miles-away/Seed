import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/calculator_chooser_sheet.dart';

void main() {
  Widget buildSheet() => const MaterialApp(
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: CalculatorChooserSheet()),
  );

  group('CalculatorChooserSheet', () {
    testWidgets('offers all three calculators', (tester) async {
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Home energy'), findsOneWidget);
    });

    testWidgets('each tile wears its own category colour', (tester) async {
      // All three used to be the same primaryContainer blue, which said
      // nothing about which domain each one leads to.
      await tester.pumpWidget(buildSheet());
      await tester.pumpAndSettle();

      Color avatarColour(String label) => tester
          .widget<CircleAvatar>(
            find
                .ancestor(
                  of: find.byType(Icon),
                  matching: find.byType(CircleAvatar),
                )
                .at(const ['Transport', 'Food', 'Home energy'].indexOf(label)),
          )
          .backgroundColor!;

      for (final (label, category) in const [
        ('Transport', ActionCategory.transport),
        ('Food', ActionCategory.food),
        ('Home energy', ActionCategory.energy),
      ]) {
        expect(
          avatarColour(label),
          category.color.withValues(alpha: opacityLight),
          reason: '$label tile should carry its category colour',
        );
      }
      // ...and three distinct colours, not one repeated.
      expect({
        for (final l in const ['Transport', 'Food', 'Home energy'])
          avatarColour(l),
      }, hasLength(3));
    });
  });
}
