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
Widget sdgNumberBadge(
  String label,
  Color color, {
  double diameter = 18,
  double fontSize = 9,
}) {
  return Container(
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Center(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
