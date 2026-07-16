import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// A neutral placeholder bar shown while a value is still loading, so a
/// not-yet-known field renders a skeleton instead of briefly flashing a
/// misleading empty state (e.g. "Not set").
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({this.width = 140, this.height = 16, super.key});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.onSurfaceVariant.withValues(alpha: opacityLight),
        borderRadius: borderRadiusSm,
      ),
    );
  }
}
