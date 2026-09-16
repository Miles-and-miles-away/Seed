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
