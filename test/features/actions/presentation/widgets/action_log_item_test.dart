import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_log_item.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  ActionLogModel log({
    String name = 'Walk',
    String category = 'transport',
    int points = 20,
    int co2 = 500,
    String? note,
  }) => ActionLogModel(
    id: 'l1',
    actionId: 'walk',
    actionName: name,
    category: category,
    points: points,
    loggedAt: DateTime(2026, 4, 19, 14, 30),
    co2Grams: co2,
    note: note,
  );

  testWidgets('renders action name and points badge', (tester) async {
    await tester.pumpWidget(wrap(ActionLogItem(actionLog: log())));

    expect(find.text('Walk'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets('shows category icon for a known category', (tester) async {
    await tester.pumpWidget(wrap(ActionLogItem(actionLog: log())));

    expect(find.byIcon(Icons.directions_bike), findsOneWidget);
  });

  testWidgets('falls back to generic eco icon for unknown category', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(ActionLogItem(actionLog: log(category: 'bogus'))),
    );

    expect(find.byIcon(Icons.eco), findsWidgets);
  });

  testWidgets('shows CO2 badge only when co2Grams > 0', (tester) async {
    await tester.pumpWidget(wrap(ActionLogItem(actionLog: log())));
    expect(find.text('500g'), findsOneWidget);

    await tester.pumpWidget(wrap(ActionLogItem(actionLog: log(co2: 0))));
    expect(find.textContaining('g', findRichText: true), findsNothing);
  });

  testWidgets('renders note when provided', (tester) async {
    await tester.pumpWidget(
      wrap(ActionLogItem(actionLog: log(note: 'felt great'))),
    );

    expect(find.text('felt great'), findsOneWidget);
  });

  testWidgets('onTap handler fires when the card is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrap(ActionLogItem(actionLog: log(), onTap: () => taps++)),
    );
    await tester.tap(find.byType(InkWell));
    await tester.pump();

    expect(taps, 1);
  });
}
