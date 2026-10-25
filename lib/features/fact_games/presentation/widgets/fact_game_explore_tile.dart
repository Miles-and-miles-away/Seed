import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/explore/presentation/explore_entries.dart';
import 'package:seed_app/features/explore/presentation/widgets/explore_tile.dart';
import 'package:seed_app/features/fact_games/domain/fact_games_pool.dart';
import 'package:seed_app/features/fact_games/presentation/providers/fact_games_providers.dart';

/// A fact game's Explore tile: while the pool is too small it shows the
/// user's progress and a lock, but stays tappable so the game's screen
/// can explain how to unlock it.
class FactGameExploreTile extends ConsumerWidget {
  const FactGameExploreTile({
    required this.entry,
    this.dimmed = false,
    super.key,
  });

  final ExploreEntry entry;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pool = ref.watch(factGamesPoolProvider).value;
    final count = pool == null ? null : distinctFigureCount(pool);
    final locked = count != null && count < factGamesMinFacts;
    return ExploreTile(
      entry: entry,
      dimmed: dimmed,
      subtitle: locked
          ? AppLocalizations.of(
              context,
            ).factGamesLockedProgress(count, factGamesMinFacts)
          : null,
      trailingIcon: locked ? Icons.lock_outline : null,
    );
  }
}
