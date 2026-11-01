import 'package:flutter/material.dart';

/// The SDG numbers in 1..17, ascending; anything else is dropped.
List<int> parsedSdgNumbers(List<String> sdgNumbers) =>
    sdgNumbers
        .map(int.tryParse)
        .whereType<int>()
        .where((n) => n >= 1 && n <= 17)
        .toList()
      ..sort();

/// A numbered circle in the goal's colour.
class SdgNumberBadge extends StatelessWidget {
  const SdgNumberBadge(this.label, this.color, {this.diameter = 22, super.key});

  final String label;
  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) => Container(
    width: diameter,
    height: diameter,
    padding: const EdgeInsets.all(2),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    // Shrinks only when "+14" or large accessibility text overfills it.
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
