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

/// Value sent to lookX/lookY at full gaze deflection.
const double mascotLookRange = 100;

/// Renders a mascot asset, dispatching on file extension.
///
/// Animated Rive mascots (`.riv`) play their default state machine;
/// everything else renders as a static SVG.
class MascotImage extends StatefulWidget {
  const MascotImage({
    required this.assetPath,
    this.width,
    this.height,
    this.onRiveInit,
    super.key,
  });

  /// Bundled asset path, either `.riv` or `.svg`.
  final String assetPath;

  final double? width;
  final double? height;

  /// Called when a `.riv` asset finishes loading. Never called for SVGs.
  final void Function(rive.RiveWidgetController controller)? onRiveInit;

  @override
  State<MascotImage> createState() => _MascotImageState();
}

class _MascotImageState extends State<MascotImage> {
  // Owned here: RiveWidgetBuilder does not dispose the loader's file.
  rive.FileLoader? _fileLoader;

  @override
  void initState() {
    super.initState();
    _createLoader();
  }

  @override
  void didUpdateWidget(covariant MascotImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _fileLoader?.dispose();
      _fileLoader = null;
      _createLoader();
    }
  }

  @override
  void dispose() {
    _fileLoader?.dispose();
    super.dispose();
  }

  void _createLoader() {
    if (widget.assetPath.endsWith('.riv')) {
      // Flutter renderer: the Rive renderer needs a GPU context and
      // aborts under flutter_tester (widget tests).
      _fileLoader = rive.FileLoader.fromAsset(
        widget.assetPath,
        riveFactory: rive.Factory.flutter,
      );
    }
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
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: rive.RiveWidgetBuilder(
        fileLoader: fileLoader,
        onLoaded: (state) => widget.onRiveInit?.call(state.controller),
        builder: (context, state) => switch (state) {
          rive.RiveLoaded(:final controller) =>
            rive.RiveWidget(controller: controller),
          _ => SizedBox(width: widget.width, height: widget.height),
        },
      ),
    );
  }
}
