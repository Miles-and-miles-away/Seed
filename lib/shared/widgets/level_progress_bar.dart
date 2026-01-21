import 'package:flutter/material.dart';

/// A horizontal progress bar showing level progression.
class LevelProgressBar extends StatelessWidget {
  const LevelProgressBar({
    required this.progress,
    required this.currentLevel,
    super.key,
    this.height = 12,
    this.showLabel = true,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Current user level.
  final int currentLevel;

  /// Height of the progress bar.
  final double height;

  /// Whether to show the level labels.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Level $currentLevel',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Level ${currentLevel + 1}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: Stack(
            children: [
              // Background
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                ),
              ),
              // Progress fill
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.primaryContainer,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Animated version of FractionallySizedBox.
class AnimatedFractionallySizedBox extends ImplicitlyAnimatedWidget {
  const AnimatedFractionallySizedBox({
    required super.duration,
    super.key,
    super.curve,
    this.widthFactor,
    this.heightFactor,
    this.child,
  });

  final double? widthFactor;
  final double? heightFactor;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedFractionallySizedBox> createState() =>
      _AnimatedFractionallySizedBoxState();
}

class _AnimatedFractionallySizedBoxState
    extends AnimatedWidgetBaseState<AnimatedFractionallySizedBox> {
  Tween<double>? _widthFactor;
  Tween<double>? _heightFactor;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _widthFactor = visitor(
      _widthFactor,
      widget.widthFactor ?? 1.0,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    if (widget.heightFactor != null) {
      _heightFactor = visitor(
        _heightFactor,
        widget.heightFactor!,
        (dynamic value) => Tween<double>(begin: value as double),
      ) as Tween<double>?;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: _widthFactor?.evaluate(animation),
      heightFactor:
          widget.heightFactor != null ? _heightFactor?.evaluate(animation) : null,
      child: widget.child,
    );
  }
}
