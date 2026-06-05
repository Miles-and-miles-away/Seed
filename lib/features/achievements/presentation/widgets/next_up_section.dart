import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_checker.dart';
import 'package:seed_app/features/achievements/domain/services/achievement_progress.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_card.dart';

/// "Next Up" — the top locked achievements with the highest numeric
/// progress, so the user can see what they are about to earn.
/// Special (binary) criteria are excluded because they have no
/// meaningful progress to display in this context.
class NextUpSection extends StatelessWidget {
  const NextUpSection({
    required this.definitions,
    required this.unlockedIds,
    required this.state,
    super.key,
    this.maxItems = 3,
  });

  final List<AchievementDefinition> definitions;
  final Set<String> unlockedIds;
  final AchievementUserState state;
  final int maxItems;

  @override
  Widget build(BuildContext context) {
    final candidates = definitions
        .where((d) => !unlockedIds.contains(d.id))
        .map(
          (d) => (def: d, progress: achievementProgressOf(d.criteria, state)),
        )
        .where((e) => e.progress.hasProgress)
        .toList()
      ..sort((a, b) => b.progress.fraction.compareTo(a.progress.fraction));

    final top = candidates.take(maxItems).toList(growable: false);

    if (top.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < top.length; i++) ...[
          if (i > 0) const SizedBox(height: spacingMd),
          AchievementCard(
            definition: top[i].def,
            progress: top[i].progress,
            isUnlocked: false,
          ),
        ],
      ],
    );
  }
}
