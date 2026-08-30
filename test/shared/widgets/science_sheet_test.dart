import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/models/emission_source_model.dart';
import 'package:seed_app/shared/widgets/science_sheet.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// The chrome and the source list the three calculator science sheets
/// share (Phase 8.4 / 8.10 / 8.16). Each feature's own `_body` builder
/// is covered beside that feature; energy's no-sources branch lives in
/// energy_widgets_test.dart.
void main() {
  late AppLocalizations l10n;

  Widget wrap(Widget child) => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
    // MarkdownWidget wraps its body in a VisibilityDetector, which
    // re-arms a 500ms timer on every paint and so never drains under
    // the test binding's pending-timer check.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('sourcesMarkdown', () {
    test('renders a bullet, its quote and its access date', () {
      final markdown = sourcesMarkdown(const [
        EmissionSource(
          name: 'DEFRA 2024',
          url: 'https://example.org/defra',
          quote: 'Grid intensity fell to 162 g/kWh.',
          accessed: '2026-01-04',
        ),
      ], l10n);

      expect(markdown, contains('### ${l10n.scienceSourcesHeading}'));
      expect(markdown, contains('- [DEFRA 2024](https://example.org/defra)'));
      expect(markdown, contains('  > Grid intensity fell to 162 g/kWh.'));
      expect(markdown, contains(l10n.scienceAccessed('2026-01-04')));
    });

    test('omits the quote and date lines when they are empty', () {
      final markdown = sourcesMarkdown(const [
        EmissionSource(name: 'IPCC AR6', url: 'https://example.org/ar6'),
      ], l10n);

      expect(markdown, contains('- [IPCC AR6](https://example.org/ar6)'));
      expect(markdown, isNot(contains('>')));
      // "Accessed " with no date would read as a missing value.
      expect(markdown, isNot(contains('Accessed')));
    });

    test('lists every source in dataset order', () {
      final markdown = sourcesMarkdown(const [
        EmissionSource(name: 'First', url: 'https://example.org/1'),
        EmissionSource(name: 'Second', url: 'https://example.org/2'),
      ], l10n);

      expect(markdown.indexOf('First'), lessThan(markdown.indexOf('Second')));
    });
  });

  group('ScienceSheet', () {
    // Always exercised through show(): a DraggableScrollableSheet
    // rendered outside a route leaves its ballistics timer pending.
    Future<void> open(
      WidgetTester tester, {
      required String title,
      required String markdown,
    }) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () =>
                  ScienceSheet.show(context, title: title, markdown: markdown),
              child: const Text('info'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('info'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the title and the markdown body', (tester) async {
      await open(
        tester,
        title: 'Electric shower',
        markdown: '**0.25 kWh per minute**',
      );

      expect(find.text('Electric shower'), findsOneWidget);
      expect(find.textContaining('0.25 kWh per minute'), findsOneWidget);
      expect(find.byType(ScienceSheet), findsOneWidget);
    });

    testWidgets('stays closed until the caller opens it', (tester) async {
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => ScienceSheet.show(
                context,
                title: 'Rice cooker',
                markdown: 'notes',
              ),
              child: const Text('info'),
            ),
          ),
        ),
      );

      expect(find.text('Rice cooker'), findsNothing);
      await tester.tap(find.text('info'));
      await tester.pumpAndSettle();

      expect(find.text('Rice cooker'), findsOneWidget);
    });

    testWidgets('marks external links with the leaving-app arrow', (
      tester,
    ) async {
      await open(
        tester,
        title: 'Kettle',
        markdown: '- [DEFRA](https://example.org/defra)',
      );

      expect(find.textContaining('\u2197'), findsOneWidget);
    });
  });
}
