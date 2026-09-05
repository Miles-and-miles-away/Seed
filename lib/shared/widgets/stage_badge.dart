import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Pill badge naming a mascot evolution stage: a star icon plus [label].
class StageBadge extends StatelessWidget {
  const StageBadge({
    required this.label,
    required this.background,
    required this.foreground,
    this.iconColor,
    super.key,
  });

  final String label;
  final Color background;
  final Color foreground;

  /// Star tint when it differs from the text colour; defaults to [foreground].
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: spacingMd, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: borderRadiusXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: iconColor ?? foreground),
          const SizedBox(width: spacingSm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
