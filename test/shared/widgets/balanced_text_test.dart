import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/shared/widgets/balanced_text.dart';

void main() {
  group('balancedBreakIndex', () {
    test('leaves single-line text untouched', () {
      // Three words of width 10, spaces 2 -> 34 total, fits in 100.
      expect(balancedBreakIndex([10, 10, 10], 2, 100), -1);
    });

    test('rebalances an orphaned word into an even two-line split', () {
      // Within width 34, greedy packs the first three words (34) and orphans
      // the last (2) on line two. The balanced split breaks at index 2 so the
      // lines are 22 and 14 wide instead of 34 and 2.
      final widths = [10.0, 10.0, 10.0, 2.0];
      expect(balancedBreakIndex(widths, 2, 34), 2);
    });

    test('returns -1 when wrapping needs three or more lines', () {
      // Four wide words, each 30, cannot pair within width 35 -> 4 lines.
      expect(balancedBreakIndex([30, 30, 30, 30], 2, 35), -1);
    });

    test('returns -1 when a single word already exceeds max width', () {
      expect(balancedBreakIndex([50, 10], 2, 40), -1);
    });
  });
}
