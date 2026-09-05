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

/// Bold white headline that fades in and drops into place after [delay].
class CelebrationTitle extends StatelessWidget {
  const CelebrationTitle(this.text, {this.delay = Duration.zero, super.key});

  final String text;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideY(begin: -0.2, end: 0);
  }
}

/// Large pill-shaped dismiss button that fades in and rises into place
/// once [delay] has elapsed.
class CelebrationButton extends StatelessWidget {
  const CelebrationButton({
    required this.label,
    required this.onPressed,
    this.delay = Duration.zero,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: spacingHuge,
          vertical: spacingLg,
        ),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusLg),
      ),
      child: Text(label),
    ).animate(delay: delay).fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0);
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
