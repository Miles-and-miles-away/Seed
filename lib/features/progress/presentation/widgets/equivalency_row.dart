import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/services/impact_equivalencies.dart';
import 'package:seed_app/features/progress/presentation/providers/progress_providers.dart';
import 'package:seed_app/features/progress/presentation/widgets/equivalency_card.dart';

/// Impact-equivalency cards rendered beneath the headline total card on
/// the Impact dashboard: four across on wide layouts, a 2 x 2 grid on
/// phones, where four across leaves a label line too narrow for words
/// like "hamburguesas".
///
/// Cards share the available width equally, so the grid always fits
/// without horizontal scrolling; each card's value uses a FittedBox and
/// its label ellipsizes after two lines. A row's height accommodates a
/// 28px icon, the value row, and a two-line label.
///
/// Reads conversion-factor metadata from
/// [impactEquivalenciesDataProvider], which loads the bundled JSON
/// once and caches it. While the metadata is loading or errored, the
/// section shrinks to zero -- the dashboard already shows the headline
/// total, so we'd rather defer than surface a spinner here.
class EquivalencyRow extends ConsumerWidget {
  const EquivalencyRow({required this.totalGrams, super.key});

  static const double height = 120;

  /// Narrower than this, the four cards wrap into two rows of two.
  static const double fourAcrossMinWidth = 600;

  final int totalGrams;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metadataAsync = ref.watch(impactEquivalenciesDataProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth < fourAcrossMinWidth ? 2 : 4;
        return metadataAsync.when(
          data: (metadata) {
            final cards = [
              for (final e in computeImpactEquivalencies(totalGrams, metadata))
                EquivalencyCard(equivalency: e),
            ];
            return Column(
              children: [
                for (var start = 0; start < cards.length; start += perRow) ...[
                  if (start > 0) const SizedBox(height: spacingSm),
                  SizedBox(
                    height: height,
                    child: _row(cards.skip(start).take(perRow).toList()),
                  ),
                ],
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _row(List<Widget> cards) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < cards.length; i++) ...[
        if (i > 0) const SizedBox(width: spacingSm),
        Expanded(child: cards[i]),
      ],
    ],
  );
}
