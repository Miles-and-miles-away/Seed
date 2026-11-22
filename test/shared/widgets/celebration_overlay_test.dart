import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';

void main() {
  testWidgets('two celebrations requested together show one at a time', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );

    final dismissers = <String, VoidCallback>{};
    Widget body(String label, VoidCallback onDismiss) {
      dismissers[label] = onDismiss;
      return Text(label);
    }

    var firstClosed = false;
    unawaited(
      showCelebrationOverlay(
        context,
        (d) => body('first', d),
      ).then((_) => firstClosed = true),
    );
    unawaited(showCelebrationOverlay(context, (d) => body('second', d)));
    await tester.pump();

    expect(find.text('first'), findsOneWidget);
    expect(find.text('second'), findsNothing);

    dismissers['first']!();
    await tester.pump();
    await tester.pump();

    expect(firstClosed, isTrue);
    expect(find.text('first'), findsNothing);
    expect(find.text('second'), findsOneWidget);

    dismissers['second']!();
    await tester.pump();
    expect(find.text('second'), findsNothing);
  });
}
