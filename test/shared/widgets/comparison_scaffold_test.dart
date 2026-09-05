import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

import '../../helpers/test_helpers.dart';

/// The comparison body shared by the three calculators.
///
/// [ComparisonScaffold.bestIndex] is the reason this file exists: the
/// three screens used to inline the crown expression, and transport
/// crowns unconditionally while food and energy gate it on a verdict.
/// Nothing in the suite pinned either contract before.
void main() {
  Widget wrap(Widget child, {ThemeData? theme}) => MaterialApp(
    theme: theme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  Widget scaffold({
    List<double> totals = const [100, 400],
    int? bestIndex,
    List<List<Widget>>? entries,
    void Function(int)? onAdd,
    Widget result = const Text('result-block'),
    Color? accentColor,
  }) => ComparisonScaffold(
    accentColor: accentColor,
    totals: totals,
    entries:
        entries ??
        const [
          [Text('a-entry')],
          [Text('b-entry')],
        ],
    emptyHint: 'nothing here yet',
    addLabel: 'Add',
    onAdd: onAdd ?? (_) {},
    bestIndex: bestIndex,
    result: result,
  );

  List<OptionColumn> columns(WidgetTester tester) =>
      tester.widgetList<OptionColumn>(find.byType(OptionColumn)).toList();

  // Both slots used to be fixed-height children of a Column: the result
  // overflowed the bottom the moment it outgrew what the columns left
  // it (the energy card does at textScale 1.5), and squeezing the
  // columns then overflowed their own fixed title/total/bar header.
  for (final scale in [1.0, 2.0]) {
    testWidgets('a tall result scrolls, never overflows, at scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: wrap(
            scaffold(
              result: const SizedBox(
                key: Key('tall-result'),
                height: 2000,
                child: Text('tall'),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final slot = tester.getSize(
        find.ancestor(
          of: find.byKey(const Key('tall-result')),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      expect(slot.height, lessThan(640 * 0.6));
    });
  }

  testWidgets('the add buttons keep dark ink on a light accent in the dark '
      'theme', (tester) async {
    // onSurface is light in the dark theme, so choosing it as the ink on
    // an amber fill gave light on light.
    await tester.pumpWidget(
      wrap(
        scaffold(accentColor: const Color(0xFFFFC107)),
        theme: ThemeData.dark(),
      ),
    );
    final button = tester.widget<FilledButton>(
      find
          .ancestor(
            of: find.text('Add').first,
            matching: find.byType(FilledButton),
          )
          .first,
    );
    const states = <WidgetState>{};
    final fill = button.style!.backgroundColor!.resolve(states)!;
    final ink = button.style!.foregroundColor!.resolve(states)!;
    expect(
      contrastRatio(Color.alphaBlend(ink, fill), fill),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('renders one column per option plus the result block', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(scaffold()));

    expect(columns(tester), hasLength(optionCount));
    expect(find.text('a-entry'), findsOneWidget);
    expect(find.text('b-entry'), findsOneWidget);
    expect(find.text('result-block'), findsOneWidget);
  });

  testWidgets('crowns exactly the column bestIndex names', (tester) async {
    await tester.pumpWidget(wrap(scaffold(bestIndex: optionA)));

    expect(columns(tester).map((c) => c.isBest), [true, false]);
  });

  testWidgets('crowns the second column when bestIndex is B', (tester) async {
    await tester.pumpWidget(
      wrap(scaffold(totals: const [400, 100], bestIndex: optionB)),
    );

    expect(columns(tester).map((c) => c.isBest), [false, true]);
  });

  testWidgets('crowns nothing when bestIndex is null', (tester) async {
    // Food and energy pass null whenever their verdict gate refuses:
    // crowning a column is a verdict in its own right.
    await tester.pumpWidget(wrap(scaffold()));

    expect(columns(tester).every((c) => !c.isBest), isTrue);
  });

  testWidgets('scales each bar against the worst column', (tester) async {
    await tester.pumpWidget(wrap(scaffold(totals: const [400, 100])));

    expect(columns(tester).map((c) => c.fraction), [1.0, 0.25]);
  });

  testWidgets('an all-zero comparison scales to zero rather than dividing', (
    tester,
  ) async {
    // Reachable: line_dry in both energy columns, or walk vs cycle.
    await tester.pumpWidget(wrap(scaffold(totals: const [0, 0])));

    expect(columns(tester).map((c) => c.fraction), [0.0, 0.0]);
  });

  testWidgets('an empty column shows the hint instead of its cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(
        scaffold(
          entries: const [
            [],
            [Text('b-entry')],
          ],
        ),
      ),
    );

    expect(columns(tester).map((c) => c.isEmpty), [true, false]);
    expect(find.text('nothing here yet'), findsOneWidget);
  });

  testWidgets('columns start at the floor and grow with their entries', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrap(
        scaffold(
          entries: [
            [
              for (var i = 0; i < 5; i++)
                const SizedBox(height: 60, child: Text('a-entry')),
            ],
            const [],
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    final a = tester.getSize(find.byType(OptionColumn).at(0));
    final b = tester.getSize(find.byType(OptionColumn).at(1));
    // The region above the result runs from the columns' top edge to
    // the top of the result slot; an empty column is pinned to 30% of
    // it, a filled one grows past that with its entries.
    final regionTop = tester.getTopLeft(find.byType(OptionColumn).at(1)).dy;
    final resultTop = tester
        .getTopLeft(
          find.ancestor(
            of: find.text('result-block'),
            matching: find.byType(SingleChildScrollView),
          ),
        )
        .dy;
    expect(b.height, closeTo((resultTop - regionTop) * 0.3, 1));
    expect(a.height, greaterThan(b.height));

    // Both add buttons ride at the same height, directly under the
    // taller column: one button per column left them 206px apart
    // with a filled column beside an empty one.
    final buttons = find.widgetWithText(FilledButton, 'Add');
    expect(
      tester.getTopLeft(buttons.at(0)).dy,
      tester.getTopLeft(buttons.at(1)).dy,
    );
    expect(
      tester.getTopLeft(buttons.at(0)).dy -
          tester.getBottomLeft(find.byType(OptionColumn).at(0)).dy,
      closeTo(8, 1),
    );

    // The result stays pinned to the bottom of the body.
    expect(
      tester.getBottomLeft(find.text('result-block')).dy,
      closeTo(640 - 12, 1),
    );
  });

  testWidgets('an overfull column caps at the region and scrolls inside', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      wrap(
        scaffold(
          entries: [
            [
              for (var i = 0; i < 30; i++)
                SizedBox(height: 60, child: Text('a-$i')),
            ],
            const [],
          ],
        ),
      ),
    );
    expect(tester.takeException(), isNull);

    // The column plus its button never push the result off the body.
    final buttons = find.widgetWithText(FilledButton, 'Add');
    final resultTop = tester.getTopLeft(find.text('result-block')).dy;
    expect(tester.getBottomLeft(buttons.at(0)).dy, lessThan(resultTop));
    // 1800px of entries in a bounded card only works if the list
    // scrolls internally.
    expect(find.text('a-29'), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await tester.pump();
    expect(find.text('a-29'), findsOneWidget);
  });

  testWidgets('each add button reports its own column', (tester) async {
    final tapped = <int>[];
    await tester.pumpWidget(wrap(scaffold(onAdd: tapped.add)));

    final buttons = find.widgetWithText(FilledButton, 'Add');
    expect(buttons, findsNWidgets(optionCount));
    await tester.tap(buttons.at(optionB));
    await tester.tap(buttons.at(optionA));

    expect(tapped, [optionB, optionA]);
  });
}
