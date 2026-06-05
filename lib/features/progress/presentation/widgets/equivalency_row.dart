import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';

/// Static strip of impact-equivalency cards rendered beneath the
/// headline total card on the Impact dashboard.
///
/// All four cards share the available width equally so the row always
/// fits on screen without horizontal scrolling; each card's value uses
/// a FittedBox and its label ellipsizes, so narrow screens stay
/// legible. Height accommodates a 28px icon, the value row, and a
/// two-line label without the card's inner Column overflowing.
///
/// Reads conversion-factor metadata from
/// [impactEquivalenciesDataProvider], which loads the bundled JSON
/// once and caches it. While the metadata is loading or errored, the
/// row shrinks to zero -- the dashboard already shows the headline
/// total, so we'd rather defer than surface a spinner here.
class EquivalencyRow extends ConsumerWidget {
  const EquivalencyRow({required this.totalGrams, super.key});

  static const double height = 120;

  final int totalGrams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadataAsync = ref.watch(impactEquivalenciesDataProvider);

    return SizedBox(
      height: height,
      child: metadataAsync.when(
        data: (metadata) {
          final equivalencies =
              computeImpactEquivalencies(totalGrams, metadata);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < equivalencies.length; i++) ...[
                if (i > 0) const SizedBox(width: spacingSm),
                Expanded(
                  child: EquivalencyCard(equivalency: equivalencies[i]),
                ),
              ],
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
