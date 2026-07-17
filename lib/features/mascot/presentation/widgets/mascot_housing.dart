import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';

/// Rounded gradient card that houses the mascot wherever it appears
/// (home card, mascot screen), keeping backgrounds consistent across
/// contexts. Colors come from the species-seeded theme, so the
/// housing tints per character (blue for Coral, green for Seed, ...).
class MascotHousing extends StatelessWidget {
  const MascotHousing({
    required this.child,
    this.padding = const EdgeInsets.all(spacingXl),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: borderRadiusXxl,
      ),
      child: child,
    );
  }
}
