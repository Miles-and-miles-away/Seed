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
    this.wow = 0,
    this.kickL = 0,
    this.kickR = 0,
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

  /// 0 is calm, 1 is wide eyes and a round open mouth.
  final double wow;

  /// 1 kicks that foot up and out; 0 keeps it on the ground.
  final double kickL;
  final double kickR;

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
    double? wow,
    double? kickL,
    double? kickR,
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
    wow: wow ?? this.wow,
    kickL: kickL ?? this.kickL,
    kickR: kickR ?? this.kickR,
  );
}

/// A body motion as a function of the seconds since it began.
typedef MascotRoutine = MascotPose Function(MascotPose pose, double seconds);

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

// Frames at 60 fps; the first three match the hop of the cheer overlay.
const double hopCrouchFrames = 46;
const double hopRiseFrames = 12;
const double hopFallFrames = 12;
const double _hopSettleFrames = 14;
const double hopSeconds =
    (hopCrouchFrames + hopRiseFrames + hopFallFrames + _hopSettleFrames) / 60;
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

const double _hopCrouch = -0.14;
const double _hopLand = -0.08;
const double _hopArms = 0.9;

/// Crouch, spring up with a smile, land and settle; [progress] runs 0..1.
///
/// The pose stays in place: the owner moves the widget for the air time.
MascotPose hop(MascotPose pose, double progress) {
  final frame = progress.clamp(0.0, 1.0) * hopSeconds * 60;
  final takeoff = hopCrouchFrames;
  final landing = takeoff + hopRiseFrames + hopFallFrames;
  final double squash;
  final double air;
  if (frame < takeoff) {
    squash = _hopCrouch * Curves.easeOut.transform(frame / takeoff);
    air = 0;
  } else if (frame < landing) {
    final t = (frame - takeoff) / (landing - takeoff);
    // No stretch: the tallest stage has no headroom in the design box.
    squash = _hopCrouch * (1 - math.min(t * 4, 1));
    air = 1;
  } else {
    final t = (frame - landing) / _hopSettleFrames;
    squash = _hopLand * math.sin(math.min(t, 1) * math.pi);
    air = 1 - Curves.easeOut.transform(t.clamp(0.0, 1.0));
  }
  return pose.copyWith(
    squash: pose.squash + squash,
    armL: pose.armL + air * _hopArms,
    armR: pose.armR + air * _hopArms,
    smile: math.max(pose.smile, air),
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

const double danceBeatSeconds = 0.5;
const double _rampSeconds = 0.3;
const double _danceLean = 0.08;
const double _danceDip = -0.07;
const double _danceArm = 0.9;
const double _danceArmSwing = 0.75;
const double _danceSway = 0.16;

double _ramp(double seconds) =>
    Curves.easeOut.transform((seconds / _rampSeconds).clamp(0.0, 1.0));

/// A side-to-side groove, one step per beat: the body dips through the
/// middle, the arm away from the lean goes up and the free foot kicks.
MascotPose dance(MascotPose pose, double seconds) {
  final amount = _ramp(seconds);
  final phase = seconds / danceBeatSeconds * math.pi;
  final side = math.sin(phase);
  final dip = math.cos(phase);
  return pose.copyWith(
    squash: pose.squash + amount * _danceDip * dip * dip,
    lean: pose.lean + amount * _danceLean * side,
    armL: pose.armL + amount * (_danceArm + _danceArmSwing * side),
    armR: pose.armR + amount * (_danceArm - _danceArmSwing * side),
    kickL: math.max(pose.kickL, amount * math.pow(math.max(side, 0), 2)),
    kickR: math.max(pose.kickR, amount * math.pow(math.max(-side, 0), 2)),
    topSway: pose.topSway - amount * _danceSway * side,
    smile: 1,
  );
}

const double cheerHz = 2.4;
const double _cheerRaise = 2;
const double _cheerPump = 0.35;
const double _cheerDip = -0.06;
const double _cheerWiggle = 0.06;
const double _cheerStomp = 0.6;
const double _cheerSway = 0.12;

/// Both arms up and pumping, stamping from foot to foot.
MascotPose cheer(MascotPose pose, double seconds) {
  final amount = _ramp(seconds);
  final pump = math.sin(seconds * cheerHz * 2 * math.pi);
  final arms = amount * (_cheerRaise + _cheerPump * pump);
  return pose.copyWith(
    squash: pose.squash + amount * _cheerDip * (1 - pump.abs()),
    lean: pose.lean + amount * _cheerWiggle * pump,
    armL: pose.armL + arms,
    armR: pose.armR + arms,
    kickL: math.max(pose.kickL, amount * _cheerStomp * math.max(pump, 0)),
    kickR: math.max(pose.kickR, amount * _cheerStomp * math.max(-pump, 0)),
    topSway: pose.topSway + amount * _cheerSway * pump,
    smile: 1,
  );
}

const double _gaspRiseSeconds = 0.25;
const double _gaspFadeSeconds = 0.2;
const double _gaspArms = 0.5;

// Wide eyes that rise fast and, over the last moment of [length], give way
// to the smile of whatever follows.
MascotPose _gasp(MascotPose pose, double seconds, double length) {
  final rise = Curves.easeOut.transform(
    (seconds / _gaspRiseSeconds).clamp(0.0, 1.0),
  );
  final fade = ((seconds - length + _gaspFadeSeconds) / _gaspFadeSeconds).clamp(
    0.0,
    1.0,
  );
  final wow = rise * (1 - fade);
  return pose.copyWith(
    wow: wow,
    smile: math.max(pose.smile, fade),
    armL: pose.armL + _gaspArms * wow,
    armR: pose.armR + _gaspArms * wow,
  );
}

const double evolveGaspSeconds = 1.8;
const double _evolveCrouchSeconds = 0.35;
const double _evolveLook = 0.9;
const double _evolveCrouch = -0.12;

/// Evolution: a wide-eyed look down at the new body and back up, a crouch,
/// then the dance.
MascotPose evolve(MascotPose pose, double seconds) {
  if (seconds < evolveGaspSeconds) {
    final look = math.sin(seconds / evolveGaspSeconds * math.pi);
    return _gasp(
      pose.copyWith(gaze: Offset(0, _evolveLook * look)),
      seconds,
      evolveGaspSeconds,
    );
  }
  final after = seconds - evolveGaspSeconds;
  if (after < _evolveCrouchSeconds) {
    final crouch = math.sin(after / _evolveCrouchSeconds * math.pi);
    return pose.copyWith(
      squash: pose.squash + _evolveCrouch * crouch,
      smile: 1,
    );
  }
  return dance(pose, after - _evolveCrouchSeconds);
}

const double _hatchWakeSeconds = 0.7;
const double _hatchOpenSeconds = 1.1;
const double _hatchLookSeconds = 2.7;
const double hatchGaspSeconds = 3.3;
const double _hatchDoze = 0.02;
const double _hatchLook = 0.9;
const double _hatchLookLean = 0.05;

/// A hatchling: it wakes, looks around, gasps, then dances.
MascotPose hatch(MascotPose pose, double seconds) {
  if (seconds < _hatchOpenSeconds) {
    final open = Curves.easeOut.transform(
      ((seconds - _hatchWakeSeconds) / (_hatchOpenSeconds - _hatchWakeSeconds))
          .clamp(0.0, 1.0),
    );
    return pose.copyWith(
      eyeOpen: math.min(pose.eyeOpen, open),
      squash: pose.squash + _hatchDoze * math.sin(seconds * 2 * math.pi),
    );
  }
  if (seconds < _hatchLookSeconds) {
    final t =
        (seconds - _hatchOpenSeconds) / (_hatchLookSeconds - _hatchOpenSeconds);
    final look = -math.sin(t * 2 * math.pi);
    return pose.copyWith(
      gaze: Offset(_hatchLook * look, 0),
      lean: pose.lean + _hatchLookLean * look,
    );
  }
  if (seconds < hatchGaspSeconds) {
    return _gasp(
      pose,
      seconds - _hatchLookSeconds,
      hatchGaspSeconds - _hatchLookSeconds,
    );
  }
  return dance(pose, seconds - hatchGaspSeconds);
}
