import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A card displaying a single statistic with icon, value, and label.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.icon,
    required this.value,
    required this.label,
    super.key,
    this.iconColor,
    this.backgroundColor,
  });

  /// Icon to display.
  final IconData icon;

  /// The main value to display (e.g., "1,234").
  final String value;

  /// Label describing the value (e.g., "Total Points").
  final String label;

  /// Optional custom icon color.
  final Color? iconColor;

  /// Optional custom background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(spacingLg),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: iconColor ?? colorScheme.primary,
          ),
          const SizedBox(height: spacingMd),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingXs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// A row of two stat cards.
class StatCardRow extends StatelessWidget {
  const StatCardRow({
    required this.left,
    required this.right,
    super.key,
  });

  final StatCard left;
  final StatCard right;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: spacingMd),
        Expanded(child: right),
      ],
    );
  }
}
