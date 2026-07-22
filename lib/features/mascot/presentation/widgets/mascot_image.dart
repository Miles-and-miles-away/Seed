import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart' as rive;

/// View model property names authored in the mascot Rive files.
///
/// The Face artboard binds its gaze and expressions to these; the app
/// drives them via data binding (see MascotDisplay).
const String mascotVmLookX = 'lookX';
const String mascotVmLookY = 'lookY';
const String mascotVmSmile = 'smile';

/// Number the app raises (0->1) while holding the smile so the FaceRig
/// script defers blinks; a blink during the held smile looks like a pause
/// on shut eyes.
const String mascotVmSmileHold = 'smileHold';

/// Value sent to lookX/lookY at full gaze deflection.
const double mascotLookRange = 100;

/// Gaze deflection for a pointer at [pointer] (global coordinates) relative
/// to a mascot centred at [center]. Full deflection (±[mascotLookRange]) is
/// reached at the screen edges.
Offset mascotGazeTarget(Offset pointer, Offset center, Size screen) {
  double axis(double p, double c, double extent) => extent <= 0
      ? 0
      : ((p - c) / (extent / 2)).clamp(-1.0, 1.0) * mascotLookRange;
  return Offset(
    axis(pointer.dx, center.dx, screen.width),
    axis(pointer.dy, center.dy, screen.height),
  );
}

/// Renders a mascot asset, dispatching on file extension.
///
/// Animated Rive mascots (`.riv`) play their default state machine;
/// everything else renders as a static SVG.
class MascotImage extends StatefulWidget {
  const MascotImage({
    required this.assetPath,
    this.artboardName,
    this.width,
    this.height,
    this.onRiveInit,
    super.key,
  });

  /// Bundled asset path, either `.riv` or `.svg`.
  final String assetPath;

  /// Artboard to render for multi-artboard `.riv` files (case-sensitive
  /// editor name). Null renders the file's default artboard. Ignored
  /// for SVGs.
  final String? artboardName;

  final double? width;
  final double? height;

  /// Called when a `.riv` asset finishes loading. Never called for SVGs.
  final void Function(rive.RiveWidgetController controller)? onRiveInit;

  @override
  State<MascotImage> createState() => _MascotImageState();
}

/// Process-wide cache of Rive file loaders, keyed by asset path.
///
/// Loaders are shared and never disposed on widget teardown. Disposing a
/// loader while its `File.asset` decode is still in flight crashes rive
/// 0.14.7 (dispose() nulls the load completer that the resumed decode then
/// force-unwraps) -- easily hit when a screen tears down mid-load (logout,
/// navigation). Sharing also avoids re-decoding the multi-MB mascot file on
/// every screen. Artboard selection happens in the builder, so one loader
/// per file serves every artboard.
final Map<String, rive.FileLoader> _riveLoaderCache = {};

rive.FileLoader _sharedRiveLoader(String assetPath) {
  return _riveLoaderCache.putIfAbsent(
    assetPath,
    // Flutter renderer: the Rive renderer needs a GPU context and
    // aborts under flutter_tester (widget tests).
    () =>
        rive.FileLoader.fromAsset(assetPath, riveFactory: rive.Factory.flutter),
  );
}

class _MascotImageState extends State<MascotImage> {
  rive.FileLoader? _fileLoader;

  @override
  void initState() {
    super.initState();
    _resolveLoader();
  }

  @override
  void didUpdateWidget(covariant MascotImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Artboard changes are handled by the builder's key; only the asset
    // path decides which shared loader to use.
    if (oldWidget.assetPath != widget.assetPath) {
      _resolveLoader();
    }
  }

  void _resolveLoader() {
    _fileLoader = widget.assetPath.endsWith('.riv')
        ? _sharedRiveLoader(widget.assetPath)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final fileLoader = _fileLoader;
    if (fileLoader == null) {
      return SvgPicture.asset(
        widget.assetPath,
        width: widget.width,
        height: widget.height,
      );
    }
    final artboardName = widget.artboardName;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: rive.RiveWidgetBuilder(
        // Force a fresh builder when the target artboard changes; the
        // builder resolves its artboard once on load.
        key: ValueKey('${widget.assetPath}#${artboardName ?? ''}'),
        fileLoader: fileLoader,
        artboardSelector: artboardName == null
            ? rive.ArtboardSelector.byDefault()
            : rive.ArtboardSelector.byName(artboardName),
        onLoaded: (state) => widget.onRiveInit?.call(state.controller),
        builder: (context, state) => switch (state) {
          rive.RiveLoaded(:final controller) => rive.RiveWidget(
            controller: controller,
          ),
          _ => SizedBox(width: widget.width, height: widget.height),
        },
      ),
    );
  }
}
