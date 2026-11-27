import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Full-screen scaffold shared by every celebration overlay: a transparent
/// [Material], a dark fade-in backdrop, and a [Stack] for the caller's
/// animated layers. The backdrop sits in its own [RepaintBoundary] so the
/// fade does not invalidate the animated content above it (Impeller).
class CelebrationOverlay extends StatelessWidget {
  const CelebrationOverlay({required this.children, this.clearRect, super.key});

  /// Layers stacked above the backdrop, in paint order.
  final List<Widget> children;

  /// Screen rect the backdrop leaves clear, full width, so the surface
  /// being explained stays visible. Null covers everything.
  final Rect? clearRect;

  @override
  Widget build(BuildContext context) {
    final backdrop = RepaintBoundary(
      child: Container(
        color: Colors.black.withValues(alpha: opacityNearOpaque),
      ).animate().fadeIn(duration: durationNormal),
    );
    final clear = clearRect;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (clear == null)
            backdrop
          else ...[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: clear.top,
              child: backdrop,
            ),
            Positioned(
              top: clear.bottom,
              left: 0,
              right: 0,
              bottom: 0,
              child: backdrop,
            ),
          ],
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

/// Full-height column for a celebration body. Free space is split evenly
/// between [children], as equal [Spacer]s would (a `SizedBox.shrink()`
/// adds one more share), and the body scrolls instead of overflowing
/// when large text does not fit.
class CelebrationScrollBody extends StatelessWidget {
  const CelebrationScrollBody({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}

final _celebrationQueues = Expando<Future<void>>();
final _celebrationCounts = Expando<ValueNotifier<int>>();

ValueNotifier<int> _countOn(NavigatorState navigator) =>
    _celebrationCounts[navigator] ??= ValueNotifier(0);

/// Presents [builder]'s widget as a full-screen celebration: transparent
/// barrier, no transition, dismiss wired to pop. The shared launcher every
/// `show*Celebration` helper delegates to. The dismiss callback pops once:
/// a rapid double tap must not pop the dialog and then the route beneath.
///
/// Celebrations on one root navigator show one at a time, in call order.
/// The future completes when this one closes, or at once when [context]
/// is gone by its turn.
Future<void> showCelebrationOverlay(
  BuildContext context,
  Widget Function(VoidCallback onDismiss) builder,
) {
  final navigator = Navigator.of(context, rootNavigator: true);
  final previous = _celebrationQueues[navigator] ?? Future<void>.value();
  final count = _countOn(navigator)..value += 1;
  final shown = previous.then((_) {
    if (!context.mounted) return null;
    var dismissed = false;
    return showGeneralDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (context, _, _) => builder(() {
        if (dismissed) return;
        dismissed = true;
        Navigator.of(context).pop();
      }),
    );
  });
  _celebrationQueues[navigator] = shown
      .catchError((Object _) {})
      .whenComplete(() => count.value--);
  return shown;
}

/// How many celebrations are showing or queued on [context]'s root
/// navigator. Lesser reactions stand aside while it is above zero.
ValueListenable<int> celebrationsPending(BuildContext context) =>
    _countOn(Navigator.of(context, rootNavigator: true));

/// Completes once no celebration is showing or queued on [context]'s root
/// navigator, those queued during the wait included.
Future<void> celebrationsDone(BuildContext context) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  Future<void>? awaited;
  while (awaited != _celebrationQueues[navigator]) {
    awaited = _celebrationQueues[navigator];
    await awaited;
  }
}
