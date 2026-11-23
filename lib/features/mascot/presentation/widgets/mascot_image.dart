import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';

/// Gaze value at full deflection.
const double mascotLookRange = 100;

/// Multiple of the mascot's own size at which the gaze saturates, so a
/// pointer inside the mascot card already reads as a strong look.
const double mascotGazeReach = 3;

/// Gaze deflection for a pointer at [pointer] (global coordinates) relative
/// to a mascot centred at [center]. Full deflection (±[mascotLookRange]) is
/// reached half of [reach] away from the centre on each axis.
Offset mascotGazeTarget(Offset pointer, Offset center, Size reach) {
  double axis(double p, double c, double extent) => extent <= 0
      ? 0
      : ((p - c) / (extent / 2)).clamp(-1.0, 1.0) * mascotLookRange;
  return Offset(
    axis(pointer.dx, center.dx, reach.width),
    axis(pointer.dy, center.dy, reach.height),
  );
}

/// Asset path of the code-drawn mascot for one species and stage.
String drawnMascotPath(String speciesId, int stage) =>
    '$_drawnPrefix/$speciesId/$stage';

const String _drawnPrefix = 'drawn';

/// The species and stage of a [drawnMascotPath], or null for a file path.
({String speciesId, int stage})? drawnMascotStage(String assetPath) {
  final parts = assetPath.split('/');
  if (parts.length != 3 || parts.first != _drawnPrefix) return null;
  final stage = int.tryParse(parts.last);
  if (stage == null) return null;
  return (
    speciesId: parts[1],
    stage: stage.clamp(1, DrawnMascotPainter.stageCount),
  );
}

/// The highest head top of any species at each stage, as a fraction of
/// the box from its top edge.
const List<double> drawnMascotHeadTops = [0.44, 0.15, 0.07, 0.02];

/// Renders a mascot, dispatching on the asset path.
///
/// A [drawnMascotPath] renders the code-drawn mascot. Everything else
/// renders as a static SVG.
class MascotImage extends StatelessWidget {
  const MascotImage({
    required this.assetPath,
    this.width,
    this.height,
    this.hero = false,
    this.wavesOnTap = false,
    this.hopOnLoad = false,
    this.waveCount = 0,
    this.routine,
    super.key,
  });

  /// A [drawnMascotPath] or a bundled `.svg` asset path.
  final String assetPath;

  final double? width;
  final double? height;

  /// Whether a code-drawn mascot is the hero; see [DrawnMascot.animate].
  /// Ignored for SVGs.
  final bool hero;

  /// See [DrawnMascot.wavesOnTap]. Ignored for SVGs.
  final bool wavesOnTap;

  /// See [DrawnMascot.hopOnLoad]. Ignored for SVGs.
  final bool hopOnLoad;

  /// See [DrawnMascot.waveCount]. Ignored for SVGs.
  final int waveCount;

  /// See [DrawnMascot.routine]; it animates a mascot that is not the hero.
  /// Ignored for SVGs.
  final MascotRoutine? routine;

  @override
  Widget build(BuildContext context) {
    final drawn = drawnMascotStage(assetPath);
    if (drawn == null) {
      return SvgPicture.asset(assetPath, width: width, height: height);
    }
    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (_, constraints) => Center(
          child: DrawnMascot(
            speciesId: drawn.speciesId,
            stage: drawn.stage,
            size: constraints.biggest.shortestSide,
            animate: hero || routine != null,
            wavesOnTap: wavesOnTap,
            hopOnLoad: hopOnLoad,
            waveCount: waveCount,
            routine: routine,
          ),
        ),
      ),
    );
  }
}
