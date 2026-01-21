import 'package:flutter/material.dart';

/// An animated overlay that shows points earned and auto-dismisses.
class PointsAnimationOverlay extends StatefulWidget {
  const PointsAnimationOverlay({
    required this.points,
    required this.onDismiss,
    this.color,
    super.key,
  });

  final int points;
  final VoidCallback onDismiss;
  final Color? color;

  /// Shows the points animation overlay.
  static void show(
    BuildContext context, {
    required int points,
    Color? color,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => PointsAnimationOverlay(
        points: points,
        color: color,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<PointsAnimationOverlay> createState() => _PointsAnimationOverlayState();
}

class _PointsAnimationOverlayState extends State<PointsAnimationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Scale up quickly, then hold
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0.8),
        weight: 20,
      ),
    ]).animate(_controller);

    // Fade in quickly, hold, then fade out
    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 30,
      ),
    ]).animate(_controller);

    // Float upward
    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -50),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: _positionAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.points} points',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
