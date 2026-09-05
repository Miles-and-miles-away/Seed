import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

/// Dump real frames to [_frameDir] to inspect the motion by eye:
///   CONFETTI_FRAMES=1 flutter test \
///     test/shared/widgets/confetti_painter_test.dart
final _dumpFrames = Platform.environment.containsKey('CONFETTI_FRAMES');
const _frameDir = 'build/confetti_frames';

const _palette = [
  Color(0xFFFFC93C),
  Color(0xFF4CAF50),
  Color(0xFF42A5F5),
  Color(0xFFEC407A),
  Color(0xFFAB47BC),
];

void main() {
  group('ConfettiParticle', () {
    final sample = List.generate(500, (_) => ConfettiParticle.random());

    test('speed survives quantisation into more than one fall rate', () {
      // Regression: the loop factor was missing, so every particle
      // rounded to a single cycle and the field fell in lockstep.
      expect(sample.map((p) => p.fallCycles).toSet().length, greaterThan(1));
      expect(sample.every((p) => p.fallCycles >= 1), isTrue);
    });

    test('most particles actually spin', () {
      // Regression: the same missing factor froze 52% of particles.
      final still = sample.where((p) => p.spinTurns == 0).length;
      expect(still / sample.length, lessThan(0.25));
    });

    test('seed phase spreads across the whole fall span', () {
      // Regression: seeds sat in a 0.5-wide band, so the field showed
      // as one clump sweeping down with a large empty gap behind it.
      final ys = sample.map((p) => p.y).toList()..sort();
      expect(ys.first, lessThan(0));
      expect(ys.last, greaterThan(0.9));
      final occupied = ys.map((y) => ((y + 0.1) / 1.3 * 10).floor()).toSet();
      expect(occupied.length, greaterThanOrEqualTo(9));
    });
  });

  testWidgets('renders a full loop', (tester) async {
    final particles = List.generate(40, (_) => ConfettiParticle.random());
    final key = GlobalKey();
    const steps = 6;

    for (var i = 0; i < steps; i++) {
      final progress = i / steps;
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ColoredBox(
              color: const Color(0xFF12161C),
              child: CustomPaint(
                size: Size.infinite,
                painter: ConfettiPainter(
                  particles: particles,
                  colors: _palette,
                  progress: progress,
                ),
              ),
            ),
          ),
        ),
      );

      if (!_dumpFrames) continue;
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      // toImage drives the real raster pipeline, which the widget test's
      // fake clock never pumps; runAsync gives it a live zone.
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        Directory(_frameDir).createSync(recursive: true);
        File(
          '$_frameDir/frame_$i.png',
        ).writeAsBytesSync(png!.buffer.asUint8List());
      });
    }

    if (_dumpFrames) {
      // ignore: avoid_print
      print('wrote $steps frames to $_frameDir (loop: $durationParticleLoop)');
    }
    expect(tester.takeException(), isNull);
  });
}
