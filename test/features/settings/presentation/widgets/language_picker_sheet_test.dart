import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_picker_sheet.dart';
import 'package:seed_app/features/settings/presentation/widgets/language_tile.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  Future<void> pumpSheet(WidgetTester tester, {String language = 'en'}) =>
      tester.pumpWidget(
        createTestWidget(
          child: const LanguagePickerSheet(),
          scaffold: true,
          locale: Locale(language),
          overrides: [
            osLocalesProvider.overrideWithBuild((_, _) => [Locale(language)]),
          ],
        ),
      );

  Finder tile(String code) => find.byWidgetPredicate(
    (w) => w is LanguageTile && w.language.code == code,
  );

  testWidgets('lists the three languages with the current one selected', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await pumpSheet(tester);

    expect(find.text('Choose your language'), findsOneWidget);
    for (final code in ['en', 'es', 'ja']) {
      expect(tile(code), findsOneWidget);
    }
    expect(
      tester.getSemantics(
        find.descendant(of: tile('en'), matching: find.byType(ListTile)),
      ),
      isSemantics(isSelected: true, isInMutuallyExclusiveGroup: true),
    );
    expect(
      tester.getSemantics(
        find.descendant(of: tile('ja'), matching: find.byType(ListTile)),
      ),
      isSemantics(isSelected: false, isInMutuallyExclusiveGroup: true),
    );
    semantics.dispose();
  });

  testWidgets('native names carry their own locale', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpSheet(tester);

    final label = tester
        .getSemantics(
          find.descendant(of: tile('ja'), matching: find.byType(ListTile)),
        )
        .attributedLabel;
    final locales = label.attributes.whereType<LocaleStringAttribute>().map(
      (a) => (a.locale, label.string.substring(a.range.start, a.range.end)),
    );
    expect(locales, contains((const Locale('ja'), '日本語')));
    semantics.dispose();
  });

  for (final language in ['ja', 'es']) {
    for (final width in testPhoneWidths) {
      testWidgets('fits in $language at ${width}pt and text scale 2', (
        tester,
      ) async {
        await loadTestFonts();
        sizeViewport(tester, size: Size(width, 900));
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await pumpSheet(tester, language: language);

        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('showLanguagePickerSheet completes when dismissed', (
    tester,
  ) async {
    var closed = false;
    await tester.pumpWidget(
      createTestWidget(
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              await showLanguagePickerSheet(context);
              closed = true;
            },
            child: const Text('open'),
          ),
        ),
        scaffold: true,
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(LanguagePickerSheet), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.byType(LanguagePickerSheet), findsNothing);
    expect(closed, isTrue);
  });
}
