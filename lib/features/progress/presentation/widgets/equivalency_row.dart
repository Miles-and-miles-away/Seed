import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';

/// Horizontally scrollable strip of impact-equivalency cards rendered
/// beneath the headline total card on the Impact dashboard.
///
/// Card width is fixed (see [EquivalencyCard.width]) so the row
/// overflows gracefully on narrow screens rather than shrinking each
/// card past legibility.
class EquivalencyRow extends StatelessWidget {
  const EquivalencyRow({required this.totalGrams, super.key});

  static const double height = 120;

  final int totalGrams;

  @override
  Widget build(BuildContext context) {
    final equivalencies = ImpactEquivalencies.from(totalGrams);
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: equivalencies.length,
        separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
        itemBuilder: (_, i) => EquivalencyCard(equivalency: equivalencies[i]),
      ),
    );
  }
}
