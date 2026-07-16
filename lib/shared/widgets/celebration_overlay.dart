import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Full-screen scaffold shared by every celebration overlay: a transparent
/// [Material], a dark fade-in backdrop, and a [Stack] for the caller's
/// animated layers. The backdrop sits in its own [RepaintBoundary] so the
/// fade does not invalidate the animated content above it (Impeller).
class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({required this.children, super.key});

  /// Layers stacked above the backdrop, in paint order.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          RepaintBoundary(
            child: Container(
              color: Colors.black.withValues(alpha: opacityNearOpaque),
            ).animate().fadeIn(duration: durationNormal),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Presents [builder]'s widget as a full-screen celebration: transparent
/// barrier, no transition, dismiss wired to pop. The shared launcher every
/// `show*Celebration` helper delegates to.
Future<void> showCelebrationOverlay(
  BuildContext context,
  Widget Function(VoidCallback onDismiss) builder,
) {
  return showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (context, _, _) => builder(() => Navigator.of(context).pop()),
  );
}
