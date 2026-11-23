import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/reveal_effects.dart';

const _old = Key('old');
const _new = Key('new');

Duration _seconds(double seconds) =>
    Duration(milliseconds: (seconds * 1000).round());

Future<void> _pump(WidgetTester tester, Widget effect, {bool reduce = false}) =>
    tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(child: effect),
        ),
      ),
    );

Future<Uint8List> _smokeAt(
  WidgetTester tester,
  double seconds, {
  Widget before = const SizedBox.square(dimension: 100),
  Widget after = const SizedBox.square(dimension: 100),
}) async {
  const frame = Key('frame');
  await tester.pumpWidget(const SizedBox());
  await tester.pumpWidget(
    ProviderScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: frame,
            child: ColoredBox(
              color: const Color(0xFFFFFFFF),
              child: EvolutionSmoke(size: 100, before: before, after: after),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump(_seconds(seconds));
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(frame),
  );
  final image = await tester.runAsync(boundary.toImage);
  final bytes = await tester.runAsync(image!.toByteData);
  return bytes!.buffer.asUint8List();
}

int _differentPixels(Uint8List a, Uint8List b) {
  var count = 0;
  for (var i = 0; i < a.length; i += 4) {
    final delta =
        (a[i] - b[i]).abs() +
        (a[i + 1] - b[i + 1]).abs() +
        (a[i + 2] - b[i + 2]).abs();
    if (delta > 12) count++;
  }
  return count;
}

void main() {
  const egg = HatchingEgg(size: 100, child: SizedBox.square(key: _new));
  const smoke = EvolutionSmoke(
    size: 100,
    before: SizedBox.square(key: _old),
    after: SizedBox.square(key: _new),
  );

  testWidgets('the mascot mounts only when the egg splits', (tester) async {
    await _pump(tester, egg);
    expect(find.byKey(_new), findsNothing);

    await tester.pump(_seconds(eggSplitSeconds - 0.05));
    expect(find.byKey(_new), findsNothing);

    await tester.pump(_seconds(0.1));
    expect(find.byKey(_new), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(_new), findsOneWidget);
  });

  testWidgets('the smoke swaps the stages only once it hides them', (
    tester,
  ) async {
    await _pump(tester, smoke);
    expect(find.byKey(_old), findsOneWidget);
    expect(find.byKey(_new), findsNothing);

    await tester.pump(_seconds(smokeSwapSeconds + 0.05));
    expect(find.byKey(_old), findsNothing);
    expect(find.byKey(_new), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(_new), findsOneWidget);
  });

  testWidgets('under reduce motion both show the mascot at once', (
    tester,
  ) async {
    for (final effect in const [egg, smoke]) {
      await _pump(tester, effect, reduce: true);
      expect(find.byKey(_new), findsOneWidget);
      expect(find.byKey(_old), findsNothing);
      expect(tester.binding.transientCallbackCount, 0);
    }
  });

  testWidgets('the smoke hides every stage of every species at the swap', (
    tester,
  ) async {
    const justBefore = smokeSwapSeconds - 0.02;
    const justAfter = smokeSwapSeconds + 0.02;
    final emptyBefore = await _smokeAt(tester, justBefore);
    final emptyAfter = await _smokeAt(tester, justAfter);
    for (final speciesId in drawnSpeciesIds) {
      for (var stage = 1; stage <= DrawnMascotPainter.stageCount; stage++) {
        final mascot = DrawnMascot(
          speciesId: speciesId,
          stage: stage,
          size: 100,
          animate: false,
        );
        if (stage < DrawnMascotPainter.stageCount) {
          final shown = await _smokeAt(tester, justBefore, before: mascot);
          expect(
            _differentPixels(shown, emptyBefore),
            0,
            reason: '$speciesId stage $stage shows before the swap',
          );
        }
        if (stage > 1) {
          final shown = await _smokeAt(tester, justAfter, after: mascot);
          expect(
            _differentPixels(shown, emptyAfter),
            0,
            reason: '$speciesId stage $stage shows after the swap',
          );
        }
      }
    }
  });
}
