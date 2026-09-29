import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';
import 'package:seed_app/shared/widgets/balanced_text.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';

/// Full-screen celebration shown when the user discovers an Eco-Dex
/// entry. The fact itself is the reward, so it takes center stage.
/// Dismissed only via the acknowledge button -- no auto-dismiss timer
/// so a user who looks away will not silently lose the moment.
///
/// Use [showEcoDexCelebrations] (below) rather than instantiating
/// this widget directly; that helper handles the sequential queue
/// and "+N more" hint.
class EcoDexCelebrationScreen extends StatelessWidget {
  const EcoDexCelebrationScreen({
    required this.entry,
    required this.onDismiss,
    super.key,
    this.remainingInQueue = 0,
  });

  final EcoDexEntry entry;
  final VoidCallback onDismiss;

  /// How many more celebrations are queued behind this one. Drives
  /// the "+N more" hint so the user knows what they are about to see.
  final int remainingInQueue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return CelebrationOverlay(
      children: [
        const TimedConfettiLayer(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CelebrationTitle(l10n.ecoDexDiscoveryTitle),
                const SizedBox(height: spacingSm),
                // The unlock condition sits directly under the title:
                // it is the answer to "what did I just do?".
                BalancedText(
                  entry.hint(locale),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: opacityHeavy),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: spacingXxl),
                Container(
                      width: 140,
                      height: 140,
                      padding: const EdgeInsets.all(spacingLg),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: EcoDexEntryImage(
                          iconName: entry.iconName,
                          size: 96,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1, 1),
                      curve: Curves.elasticOut,
                      duration: 800.ms,
                    ),
                const SizedBox(height: spacingXxl),
                Text(
                  l10n.ecoDexEntryTitle(entry.name(locale)),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                const SizedBox(height: spacingMd),
                Text(
                  entry.fact(locale),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: opacityHeavy),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                const SizedBox(height: spacingHuge),
                CelebrationButton(
                  label: l10n.ecoDexDiscoveryAcknowledge,
                  onPressed: onDismiss,
                  delay: 800.ms,
                ),
                if (remainingInQueue > 0) ...[
                  const SizedBox(height: spacingMd),
                  Text(
                    l10n.ecoDexDiscoveryMoreQueued(remainingInQueue),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: opacityMedium),
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Shows each entry in [entries] sequentially. Each celebration is
/// acknowledged via its button before the next is shown. Returns
/// once the queue is empty.
Future<void> showEcoDexCelebrations(
  BuildContext context, {
  required List<EcoDexEntry> entries,
}) async {
  if (entries.isEmpty) return;

  for (var i = 0; i < entries.length; i++) {
    if (!context.mounted) return;
    final remaining = entries.length - i - 1;
    await showCelebrationOverlay(
      context,
      (onDismiss) => EcoDexCelebrationScreen(
        entry: entries[i],
        remainingInQueue: remaining,
        onDismiss: onDismiss,
      ),
    );
  }
}
