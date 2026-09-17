import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart' as rive;

/// Guards the face rig contract inside the mascot `.riv` exports.
///
/// Data binding resolves `face/lookX` and friends even when the Face
/// artboard is empty, so a face-less export ships silently: the app writes
/// gaze and smile, the FaceRig script converts them, and nothing moves.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<rive.File> load(String asset) async {
    final bytes = Uint8List.fromList(
      File('assets/animations/$asset.riv').readAsBytesSync(),
    );
    return (await rive.File.decode(bytes, riveFactory: rive.Factory.flutter))!;
  }

  for (final e in {
    'sprout_mascot': 'Sprout',
    'coral_mascot': 'Coral',
  }.entries) {
    group(e.key, () {
      test('Face artboard carries the gaze and mouth rig', () async {
        final face = (await load(e.key)).artboard('Face')!;
        for (final name in [
          'gaze',
          'Eye_L',
          'Eye_R',
          'Pupil',
          'Iris',
          'IrisRim',
          'Sclera',
          'mouth',
          'mouth_rest',
          'mouth_happy',
        ]) {
          expect(
            face.component(name),
            isNotNull,
            reason: 'Face artboard is missing "$name"',
          );
        }
      });

      // Drives lookX like the app and lets the FaceRig script produce
      // pupilX and blink, so an unsigned build (script inert) fails here.
      test('FaceRig script runs and its outputs reach the eyes', () async {
        final file = await load(e.key);
        final face = file.artboard('Face')!;
        final sm = face.defaultStateMachine()!;
        final vm = file.defaultArtboardViewModel(face)!.createDefaultInstance()!;
        sm.bindViewModelInstance(vm);
        final gaze = face.component('gaze')!;
        final eyes = [face.component('Eye_L')!, face.component('Eye_R')!];
        final designScale = eyes.first.scaleY;
        final pupilX = vm.number('pupilX')!;
        final blink = vm.number('blink')!;
        vm.number('lookX')!.value = 100;

        var minBlink = 1.0;
        for (var t = 0.0; t < 8; t += 1 / 60) {
          sm.advanceAndApply(1 / 60);
          if (blink.value < minBlink) minBlink = blink.value;
          for (final eye in eyes) {
            expect(
              eye.scaleY,
              closeTo(blink.value * designScale, 0.001),
              reason: 'eye Scale-Y must follow blink at the design scale',
            );
          }
        }
        expect(
          pupilX.value,
          greaterThan(10),
          reason: 'FaceRig did not run; build the .riv with --publish',
        );
        expect(gaze.x, closeTo(pupilX.value, 0.01), reason: 'gaze.x not bound');
        expect(minBlink, lessThan(0.5), reason: 'no blink within 8s');
      });

      // A gaze node that carries the eye offset itself reads fine at rest
      // and drops the pupil the moment pupilY (0) is bound over it.
      test('pupil rests centred on the sclera once binds apply', () async {
        final file = await load(e.key);
        final face = file.artboard('Face')!;
        final vm = file.defaultArtboardViewModel(face)!.createDefaultInstance()!;
        face.defaultStateMachine()!.bindViewModelInstance(vm);
        vm.number('pupilX')!.value = 0;
        vm.number('pupilY')!.value = 0;
        face.defaultStateMachine()!.advanceAndApply(1 / 60);
        final gaze = face.component('gaze')!;
        final pupil = face.component('Pupil')!;
        final sclera = face.component('Sclera')!;
        expect(gaze.x + pupil.x, closeTo(sclera.x, 2));
        expect(gaze.y + pupil.y, closeTo(sclera.y, 2));
      });

      test('every stage artboard nests the Face', () async {
        final file = await load(e.key);
        for (var s = 1; s <= 4; s++) {
          final stage = '${e.value}_stage$s';
          expect(
            file.artboard(stage)!.component('Face'),
            isNotNull,
            reason: '$stage has no nested Face component',
          );
        }
      });
    });
  }
}
