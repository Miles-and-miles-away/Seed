import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/widgets/comparison_widgets.dart';

/// The comparison body shared by the three calculators.
///
/// [ComparisonScaffold.bestIndex] is the reason this file exists: the
/// three screens used to inline the crown expression, and transport
/// crowns unconditionally while food and energy gate it on a verdict.
/// Nothing in the suite pinned either contract before.
void main() {
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

  Widget scaffold({
    List<double> totals = const [100, 400],
    int? bestIndex,
    List<List<Widget>>? entries,
    void Function(int)? onAdd,
    Widget result = const Text('result-block'),
  }) => ComparisonScaffold(
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
