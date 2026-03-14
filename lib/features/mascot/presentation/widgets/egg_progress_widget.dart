import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/mascot_providers.dart';

/// Displays the egg with a circular progress ring showing
/// hatching progress (Day X/30). Wobbles when close to
/// hatching (day 25+).
class EggProgressWidget extends ConsumerWidget {
  const EggProgressWidget({
    this.size = 80,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final egg = ref.watch(currentEggProvider);
    if (egg == null) return const SizedBox.shrink();

    final progress = ref.watch(eggHatchingProgressProvider);
    final streakDays = egg.hatchingStreakDays;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final isCloseToHatching = streakDays >= 25;

    Widget eggIcon = Icon(
      Icons.egg_outlined,
      size: size * 0.5,
      color: const Color(0xFFF5F5DC),
    );

    // Wobble when close to hatching
    if (isCloseToHatching) {
      eggIcon = eggIcon
          .animate(
            onPlay: (c) => c.repeat(reverse: true),
          )
          .rotate(
            begin: -0.05,
            end: 0.05,
            duration: 300.ms,
            curve: Curves.easeInOut,
          );
    }

    return SizedBox(
      width: size,
      height: size + 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: size * 0.85,
                  height: size * 0.85,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      isCloseToHatching
                          ? const Color(0xFFFFD700)
                          : colorScheme.primary,
                    ),
                  ),
                ),
                eggIcon,
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.eggProgressLabel(
              streakDays,
              AppConstants.eggHatchingStreakRequired,
            ),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
