import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';

import '../../../../helpers/test_helpers.dart';

final _keyPoses = <String, MascotPose>{
  'rest': const MascotPose(),
  'half blink': const MascotPose(eyeOpen: 0.45),
  'shut': const MascotPose(eyeOpen: 0),
  'look left': const MascotPose(gaze: Offset(-1, 0)),
  'look up right': const MascotPose(gaze: Offset(0.8, -0.8)),
  'look down': const MascotPose(gaze: Offset(0, 1)),
  'smile': const MascotPose(smile: 1),
  'wave': wave(const MascotPose(), 0.5),
};

const _stages = [1, 2, 3, 4];
const _heroSize = 120.0;
const _thumbSize = 48.0;
const _thumbPoses = ['rest', 'smile', 'wave'];
const _sheetSize = Size(1200, 600);
const _lineUpSize = Size(1200, 460);
const _opaque = 128;
const _pixelsPerUnit = 2;
const _eyeSamples = 32;
const _clearanceStep = 0.05;
const _minEyeClearance = 0.3;
const _minGazeClearance = 0.2;

class _Raster {
  _Raster(this.side, this.rgba);

  final int side;
  final ByteData rgba;

  bool opaque(int x, int y) => rgba.getUint8((y * side + x) * 4 + 3) >= _opaque;

  Iterable<int> get _range => Iterable.generate(side);

  int get lowestRow => _range.lastWhere((y) => _range.any((x) => opaque(x, y)));

  bool get touchesBorder => _range.any(
    (i) =>
        opaque(i, 0) ||
        opaque(i, side - 1) ||
        opaque(0, i) ||
        opaque(side - 1, i),
  );
}

Future<_Raster> _rasterise(
  WidgetTester tester,
  DrawnMascotPainter painter,
) async {
  const side = DrawnMascotPainter.designSize * _pixelsPerUnit;
  final recorder = ui.PictureRecorder();
  painter.paint(Canvas(recorder), const Size.square(side));
  final picture = recorder.endRecording();
  final rgba = await tester.runAsync(() async {
    final image = await picture.toImage(side.toInt(), side.toInt());
    final bytes = await image.toByteData();
    image.dispose();
    return bytes;
  });
  picture.dispose();
  return _Raster(side.toInt(), rgba!);
}

// The clear space between the eyes and the body outline, in eye widths.
double _eyeClearance(DrawnMascotPainter painter) {
  bool clear(double gap) => painter.eyeBounds.every((eye) {
    final grown = eye.inflate(gap);
    return Iterable<int>.generate(_eyeSamples).every((i) {
      final angle = i * 2 * math.pi / _eyeSamples;
      final reach = Offset(
        math.cos(angle) * grown.width / 2,
        math.sin(angle) * grown.height / 2,
      );
      return painter.bodyOutline.contains(grown.center + reach);
    });
  });

  var gap = 0.0;
  while (clear(gap + _clearanceStep)) {
    gap += _clearanceStep;
  }
  return gap / painter.rig.eyeSize;
}

Widget _cell(DrawnMascotPainter painter, double size, String label) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    CustomPaint(size: Size.square(size), painter: painter),
    Text(label),
  ],
);

Widget _band(Brightness brightness, List<Widget> rows) {
  final scheme = appTheme(brightness).colorScheme;
  return Expanded(
    child: ColoredBox(
      color: scheme.primaryContainer,
      child: DefaultTextStyle(
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          color: scheme.onPrimaryContainer,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows,
        ),
      ),
    ),
  );
}

Future<void> _expectGolden(
  WidgetTester tester,
  Size size,
  List<Widget> bands,
  String file,
) async {
  sizeViewport(tester, size: size);
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(child: Column(children: bands)),
    ),
  );
  await expectLater(
    find.byType(RepaintBoundary).first,
    matchesGoldenFile('goldens/$file'),
  );
}

Widget _spread(List<Widget> cells) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  crossAxisAlignment: CrossAxisAlignment.end,
  children: cells,
);

void main() {
  setUpAll(loadTestFonts);

  // Anti-aliasing differs per platform; the goldens are macOS renders.
  group('approved look', skip: !Platform.isMacOS, () {
    testWidgets('the cast line-up', (tester) async {
      await _expectGolden(tester, _lineUpSize, [
        for (final brightness in Brightness.values.reversed)
          _band(brightness, [
            for (final size in [_heroSize, _thumbSize])
              _spread([
                for (final speciesId in drawnSpeciesIds)
                  for (final stage in _stages)
                    _cell(
                      drawnMascotPainter(speciesId, stage),
                      size,
                      size == _heroSize
                          ? '$speciesId $stage'
                          : '${size.toInt()} dp',
                    ),
              ]),
          ]),
      ], 'cast_line_up.png');
    });

    for (final speciesId in drawnSpeciesIds) {
      testWidgets('the $speciesId contact sheet', (tester) async {
        await _expectGolden(tester, _sheetSize, [
          _band(Brightness.light, [
            for (final stage in _stages)
              _spread([
                Text('stage $stage'),
                for (final pose in _keyPoses.entries)
                  _cell(
                    drawnMascotPainter(speciesId, stage, pose.value),
                    _heroSize,
                    pose.key,
                  ),
                for (final pose in _thumbPoses)
                  _cell(
                    drawnMascotPainter(speciesId, stage, _keyPoses[pose]!),
                    _thumbSize,
                    '${_thumbSize.toInt()} dp',
                  ),
              ]),
          ]),
        ], '${speciesId}_contact_sheet.png');
      });
    }
  });

  for (final speciesId in drawnSpeciesIds) {
    test('the $speciesId body grows wider and taller at every stage', () {
      final bodies = [
        for (final stage in _stages) drawnMascotPainter(speciesId, stage).body,
      ];
      for (var i = 1; i < bodies.length; i++) {
        final (smaller, larger) = (bodies[i - 1], bodies[i]);
        expect(larger.halfWidth, greaterThan(smaller.halfWidth));
        expect(
          larger.bottom - larger.top,
          greaterThan(smaller.bottom - smaller.top),
        );
      }
    });

    for (final stage in _stages) {
      group('$speciesId stage $stage', () {
        test('keeps the eyes clear of the body outline', () {
          for (final entry in _keyPoses.entries) {
            final minimum = entry.value.gaze == Offset.zero
                ? _minEyeClearance
                : _minGazeClearance;
            expect(
              _eyeClearance(drawnMascotPainter(speciesId, stage, entry.value)),
              greaterThanOrEqualTo(minimum),
              reason: entry.key,
            );
          }
        });

        testWidgets('stands on the ground line in every key pose', (
          tester,
        ) async {
          const ground = DrawnMascotPainter.groundY * _pixelsPerUnit;
          for (final entry in _keyPoses.entries) {
            final raster = await _rasterise(
              tester,
              drawnMascotPainter(speciesId, stage, entry.value),
            );
            expect(
              raster.lowestRow,
              inInclusiveRange(ground - 2, ground + 2),
              reason: entry.key,
            );
          }
        });

        testWidgets('every key pose stays inside the design box', (
          tester,
        ) async {
          const box = Rect.fromLTWH(
            0,
            0,
            DrawnMascotPainter.designSize,
            DrawnMascotPainter.designSize,
          );
          for (final entry in _keyPoses.entries) {
            final painter = drawnMascotPainter(speciesId, stage, entry.value);
            final raster = await _rasterise(tester, painter);
            expect(raster.touchesBorder, isFalse, reason: entry.key);

            final joints = painter.joints;
            for (final joint in [
              joints.faceAnchor,
              joints.topAnchor,
              joints.handL,
              joints.handR,
              joints.footL,
              joints.footR,
            ]) {
              expect(
                box.contains(joint),
                isTrue,
                reason: '${entry.key} $joint',
              );
            }
            final face = joints.faceAnchor * _pixelsPerUnit.toDouble();
            expect(
              raster.opaque(face.dx.round(), face.dy.round()),
              isTrue,
              reason: '${entry.key} face anchor is on the body',
            );
          }
        });

        // What grows from the top may be lopsided; the body may not.
        testWidgets('is symmetric below the face anchor at rest', (
          tester,
        ) async {
          final painter = drawnMascotPainter(speciesId, stage);
          final raster = await _rasterise(tester, painter);
          final face = painter.joints.faceAnchor;
          final firstRow = (face.dy * _pixelsPerUnit).ceil();
          for (var y = firstRow; y <= raster.lowestRow; y++) {
            final columns = [
              for (var x = 0; x < raster.side; x++)
                if (raster.opaque(x, y)) x,
            ];
            expect(
              columns.first + columns.last,
              closeTo(raster.side - 1, 1),
              reason: 'row $y',
            );
          }
        });
      });
    }
  }

  group('DrawnMascot', () {
    Future<void> pumpMascot(WidgetTester tester, {required bool animate}) =>
        tester.pumpWidget(
          ProviderScope(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: DrawnMascot(
                  speciesId: drawnSpeciesIds.first,
                  stage: 2,
                  size: 100,
                  animate: animate,
                ),
              ),
            ),
          ),
        );

    MascotPose pose(WidgetTester tester) {
      final paint = tester.widget<CustomPaint>(
        find.descendant(
          of: find.byType(DrawnMascot),
          matching: find.byType(CustomPaint),
        ),
      );
      return (paint.painter! as DrawnMascotPainter).pose;
    }

    testWidgets('a static instance owns no ticker', (tester) async {
      await pumpMascot(tester, animate: false);
      expect(tester.binding.transientCallbackCount, 0);
    });

    testWidgets('the hero smiles on the trigger, then relaxes', (tester) async {
      await pumpMascot(tester, animate: true);
      expect(tester.binding.transientCallbackCount, greaterThan(0));
      ProviderScope.containerOf(
        tester.element(find.byType(DrawnMascot)),
      ).read(mascotSmileTriggerProvider.notifier).triggerSmile();
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).smile, greaterThan(0.8));
      for (var i = 0; i < 180; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).smile, lessThan(0.05));
    });

    testWidgets('the hero waves when tapped', (tester) async {
      await pumpMascot(tester, animate: true);
      await tester.tap(find.byType(DrawnMascot));
      for (var i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).armR, greaterThan(1));
      for (var i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).armR, lessThan(0.2));
    });

    testWidgets('the eyes follow a pointer and recentre on release', (
      tester,
    ) async {
      await pumpMascot(tester, animate: true);
      final gesture = await tester.startGesture(Offset.zero);
      for (var i = 0; i < 40; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).gaze.dx, lessThan(-0.8));
      expect(pose(tester).gaze.dy, lessThan(-0.8));
      await gesture.up();
      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }
      expect(pose(tester).gaze.distance, lessThan(0.05));
    });
  });

  test('a blink opens more slowly than it closes', () {
    expect(blinkOpenSeconds, greaterThan(blinkCloseSeconds));
    expect(blinkEyeOpen(-0.01), 1);
    expect(blinkEyeOpen(0), 1);
    expect(blinkEyeOpen(blinkCloseSeconds + blinkHoldSeconds / 2), 0);
    expect(blinkEyeOpen(blinkSeconds), 1);
    final closing = blinkEyeOpen(blinkCloseSeconds / 2);
    final opening = blinkEyeOpen(blinkSeconds - blinkOpenSeconds / 2);
    expect(closing, inExclusiveRange(0, 1));
    expect(opening, inExclusiveRange(0, 1));
  });
}
