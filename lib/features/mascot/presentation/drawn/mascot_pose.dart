import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Joint values that every code-drawn mascot understands.
///
/// Angles are radians. Arm angles add to the rest angle of the species
/// and raise the arm. `L` and `R` are screen sides.
@immutable
class MascotPose {
  const MascotPose({
    this.squash = 0,
    this.lean = 0,
    this.armL = 0,
    this.armR = 0,
    this.topSway = 0,
    this.gaze = Offset.zero,
    this.eyeOpen = 1,
    this.smile = 0,
    this.wink = 0,
  });

  /// Body height change as a fraction; the width compensates.
  final double squash;
  final double lean;
  final double armL;
  final double armR;

  /// Rotation of whatever grows from the top anchor.
  final double topSway;

  /// Gaze deflection, each axis in -1..1.
  final Offset gaze;

  /// 1 is open, 0 is shut.
  final double eyeOpen;

  /// 0 is the rest mouth, 1 is the open happy mouth.
  final double smile;

  /// 1 shuts the screen-right eye and keeps the other eye open.
  final double wink;

  MascotPose copyWith({
    double? squash,
    double? lean,
    double? armL,
    double? armR,
    double? topSway,
    Offset? gaze,
    double? eyeOpen,
    double? smile,
    double? wink,
  }) => MascotPose(
    squash: squash ?? this.squash,
    lean: lean ?? this.lean,
    armL: armL ?? this.armL,
    armR: armR ?? this.armR,
    topSway: topSway ?? this.topSway,
    gaze: gaze ?? this.gaze,
    eyeOpen: eyeOpen ?? this.eyeOpen,
    smile: smile ?? this.smile,
    wink: wink ?? this.wink,
  );
}

/// Positions of the shared rig joints for one pose, in design units.
typedef MascotJoints = ({
  Offset faceAnchor,
  Offset topAnchor,
  Offset handL,
  Offset handR,
  Offset footL,
  Offset footR,
});

const double breathePeriodSeconds = 3.6;
const double waveSeconds = 1.6;
const double blinkCloseSeconds = 0.083;
const double blinkHoldSeconds = 0.05;
const double blinkOpenSeconds = 0.133;
const double blinkSeconds =
    blinkCloseSeconds + blinkHoldSeconds + blinkOpenSeconds;
const double blinkMinGapSeconds = 2.5;
const double blinkMaxGapSeconds = 7;

const double _breatheSquash = 0.016;
const double _breatheSway = 0.05;
const double _breatheArm = 0.06;
const double _waveRaise = 1.68;
const double _waveSwing = 0.3;
const double _waveSwings = 3;
const double _waveLean = -0.045;
const double _waveEdge = 0.22;

/// Slow idle motion; the leaves trail the body by a fraction of a cycle.
MascotPose breathe(MascotPose pose, double seconds) {
  final phase = seconds / breathePeriodSeconds * 2 * math.pi;
  final arms = _breatheArm * math.sin(phase);
  return pose.copyWith(
    squash: pose.squash + _breatheSquash * math.sin(phase),
    topSway: pose.topSway + _breatheSway * math.sin(phase - 0.9),
    armL: pose.armL + arms,
    armR: pose.armR + arms,
  );
}

/// Wave with the screen-right hand; [progress] runs 0..1.
MascotPose wave(MascotPose pose, double progress) {
  final p = progress.clamp(0.0, 1.0);
  final edge = math.min(p, 1 - p) / _waveEdge;
  final amount = Curves.easeInOut.transform(edge.clamp(0.0, 1.0));
  final swing = math.sin(p * 2 * math.pi * _waveSwings);
  return pose.copyWith(
    armR: pose.armR + amount * (_waveRaise + _waveSwing * swing),
    armL: pose.armL + amount * 0.25,
    lean: pose.lean + amount * _waveLean,
    topSway: pose.topSway - amount * 0.12 * swing,
    smile: math.max(pose.smile, amount),
  );
}

/// Eye opening during a blink that began [seconds] ago.
double blinkEyeOpen(double seconds) {
  if (seconds < 0 || seconds >= blinkSeconds) return 1;
  if (seconds < blinkCloseSeconds) {
    return 1 - Curves.easeIn.transform(seconds / blinkCloseSeconds);
  }
  final opening = seconds - blinkCloseSeconds - blinkHoldSeconds;
  if (opening < 0) return 0;
  return Curves.easeOut.transform(opening / blinkOpenSeconds);
}
