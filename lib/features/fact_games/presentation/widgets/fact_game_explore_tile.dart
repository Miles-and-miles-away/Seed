import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/explore/presentation/explore_entries.dart';
import 'package:seed_app/features/explore/presentation/widgets/explore_tile.dart';

/// A fact game's Explore tile: until the user has discovered [needed]
/// Eco-Dex entries it shows their progress and a lock, but stays tappable
/// so the game's screen can explain how to unlock it. Until the user
/// document loads it shows neither, so an unlocked user never sees a lock.
class FactGameExploreTile extends ConsumerWidget {
  const FactGameExploreTile({
    required this.entry,
    required this.needed,
    this.dimmed = false,
    super.key,
  });

  final ExploreEntry entry;
  final int needed;
  final bool dimmed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loaded = ref.watch(currentUserProvider.select((u) => u.hasValue));
    final count = ref.watch(ecoDexDiscoveredCountProvider);
    final locked = loaded && count < needed;
    return ExploreTile(
      entry: entry,
      dimmed: dimmed,
      subtitle: locked
          ? AppLocalizations.of(context).factGamesLockedProgress(count, needed)
          : null,
      trailingIcon: locked ? Icons.lock_outline : null,
    );
  }
}
