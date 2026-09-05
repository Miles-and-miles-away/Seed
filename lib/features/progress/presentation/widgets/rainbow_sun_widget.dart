import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart' hide Durations;

import 'package:seed_app/core/constants/ui_constants.dart';
import 'rainbow_sun_painter.dart';

/// Animated widget that displays the Rainbow Sun visualization.
///
/// Shows a growing sun with rays extending to screen edges
/// based on daily goal completion and SDG categories completed.
class RainbowSunWidget extends StatefulWidget {
  const RainbowSunWidget({
    required this.goalCount,
    required this.goalTarget,
    required this.completedSdgs,
    required this.sdgColors,
    super.key,
  });

  /// Number of goals completed today
  final int goalCount;

  /// User's daily goal target
  final int goalTarget;

  /// List of SDG numbers completed today (1-17)
  final List<int> completedSdgs;

  /// SDG colors indexed 0-16 for goals 1-17
  final List<Color> sdgColors;

  @override
  State<RainbowSunWidget> createState() => _RainbowSunWidgetState();
}

class _RainbowSunWidgetState extends State<RainbowSunWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _previousCompletionRatio = 0;
  List<int> _previousCompletedSdgs = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: durationReveal);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Start animation on first build
    _controller.forward();
  }

  @override
  void didUpdateWidget(RainbowSunWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newCompletionRatio = _calculateCompletionRatio();
    final hasNewSdgs = !listEquals(
      widget.completedSdgs,
      _previousCompletedSdgs,
    );

    // Animate when completion changes or new SDGs are completed
    if (newCompletionRatio != _previousCompletionRatio || hasNewSdgs) {
      _previousCompletionRatio = newCompletionRatio;
      _previousCompletedSdgs = List.from(widget.completedSdgs);
      _controller.forward(from: 0);
    }
  }

  double _calculateCompletionRatio() {
    if (widget.goalTarget <= 0) return 0;
    return (widget.goalCount / widget.goalTarget).clamp(0, 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: RainbowSunPainter(
              completionRatio: _calculateCompletionRatio(),
              completedSdgs: widget.completedSdgs,
              animationValue: _animation.value,
              sdgColors: widget.sdgColors,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

/// Empty state widget shown when no goals have been completed yet.
class EmptyRainbowSun extends StatelessWidget {
  const EmptyRainbowSun({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RepaintBoundary(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.amber.shade200, Colors.orange.shade200],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: opacityMuted),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: spacingLg),
          Text(
            'Complete goals to grow your sun!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
