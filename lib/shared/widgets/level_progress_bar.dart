import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

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
          const SizedBox(height: spacingSm),
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
              TweenAnimationBuilder<double>(
                tween: Tween(end: progress.clamp(0.0, 1.0)),
                duration: durationNormal,
                curve: Curves.easeOut,
                builder: (_, widthFactor, child) => FractionallySizedBox(
                  widthFactor: widthFactor,
                  child: child,
                ),
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
