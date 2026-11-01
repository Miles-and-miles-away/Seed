import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/quiz/quiz.dart';

void main() {
  Widget pair(double left, double right) => Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 212,
        child: QuizTokenPair(
          gap: 12,
          left: SizedBox(key: const ValueKey('left'), height: left),
          right: SizedBox(key: const ValueKey('right'), height: right),
        ),
      ),
    ),
  );

  testWidgets('sets both tokens at the taller height, a gap apart', (
    tester,
  ) async {
    await tester.pumpWidget(pair(40, 90));

    final left = tester.getRect(find.byKey(const ValueKey('left')));
    final right = tester.getRect(find.byKey(const ValueKey('right')));
    expect(left, const Rect.fromLTWH(0, 0, 100, 90));
    expect(right, const Rect.fromLTWH(112, 0, 100, 90));
    expect(tester.getSize(find.byType(QuizTokenPair)), const Size(212, 90));
  });

  testWidgets('follows a token that grows or shrinks', (tester) async {
    await tester.pumpWidget(pair(40, 90));
    await tester.pumpWidget(pair(130, 90));
    expect(tester.getSize(find.byKey(const ValueKey('right'))).height, 130);

    await tester.pumpWidget(pair(30, 50));
    expect(tester.getSize(find.byKey(const ValueKey('left'))).height, 50);
    expect(tester.getSize(find.byType(QuizTokenPair)).height, 50);
  });
}
