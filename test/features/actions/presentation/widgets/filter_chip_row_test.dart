import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/actions/presentation/widgets/filter_chip_row.dart';

void main() {
  group('FilterChipRow', () {
    Widget wrap({required int optionCount, List<int>? seen}) => MaterialApp(
      home: Scaffold(
        body: FilterChipRow(
          optionCount: optionCount,
          itemBuilder: (context, index) {
            seen?.add(index);
            return SizedBox(
              width: 100,
              child: Text(index == 0 ? 'All' : 'opt$index'),
            );
          },
        ),
      ),
    );

    testWidgets('builds index 0 as All and wraps at the cycle', (tester) async {
      final seen = <int>[];
      await tester.pumpWidget(wrap(optionCount: 3, seen: seen));
      await tester.pumpAndSettle();

      // Whatever slice is on screen, every index stays inside the
      // cycle: the modulo is what makes the repeat look endless.
      expect(seen, isNotEmpty);
      expect(seen.every((i) => i >= 0 && i <= 3), isTrue);
      expect(find.text('opt4'), findsNothing);
    });

    testWidgets('opens mid-list so it scrolls both ways', (tester) async {
      await tester.pumpWidget(wrap(optionCount: 3));
      await tester.pumpAndSettle();

      final position = tester
          .state<ScrollableState>(find.byType(Scrollable))
          .position;
      expect(position.pixels, greaterThan(0));
      expect(position.pixels, lessThan(position.maxScrollExtent));
    });

    testWidgets('an option count of zero still renders All', (tester) async {
      await tester.pumpWidget(wrap(optionCount: 0));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('All'), findsWidgets);
    });
  });
}
