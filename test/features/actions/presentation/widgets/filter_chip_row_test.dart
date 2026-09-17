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

    testWidgets('opens on All and scrolls both ways', (tester) async {
      final seen = <int>[];
      await tester.pumpWidget(wrap(optionCount: 3, seen: seen));
      await tester.pumpAndSettle();

      final position = tester
          .state<ScrollableState>(find.byType(Scrollable))
          .position;
      expect(position.minScrollExtent, lessThan(0));
      expect(position.maxScrollExtent, greaterThan(0));
      expect(find.text('All'), findsWidgets);
      // Opening must only build what the viewport shows, not walk a
      // long list to a mid-way offset (one open used to build ~1300
      // chips during layout).
      expect(seen.length, lessThan(40));
    });

    testWidgets('an option count of zero still renders All', (tester) async {
      await tester.pumpWidget(wrap(optionCount: 0));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('All'), findsWidgets);
    });
  });
}
