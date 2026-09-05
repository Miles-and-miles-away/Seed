import 'dart:async';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
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
        const _ConfettiLayer(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CelebrationTitle(l10n.ecoDexDiscoveryTitle),
                const SizedBox(height: spacingXxxl),
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
                  entry.name(locale),
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
                const SizedBox(height: spacingXl),
                BalancedText(
                  l10n.ecoDexAchievement(entry.hint(locale)),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: opacityMedium),
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
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
    // Latch so a rapid double-tap can't pop this dialog and then the route
    // beneath it (the second pop would resolve to an ancestor navigator).
    var dismissed = false;
    await showCelebrationOverlay(
      context,
      (onDismiss) => EcoDexCelebrationScreen(
        entry: entries[i],
        remainingInQueue: remaining,
        onDismiss: () {
          if (dismissed) return;
          dismissed = true;
          onDismiss();
        },
      ),
    );
  }
}

// Confetti runs for the visual peak, then fades out and stops. The screen
// waits indefinitely for the acknowledge button, so the painter must not
// keep rebuilding every frame once the moment has passed.
const _confettiRunDuration = Duration(seconds: 4);
const _confettiFadeDuration = Duration(milliseconds: 600);
const _particleCount = 40;

class _ConfettiLayer extends StatefulWidget {
  const _ConfettiLayer();

  @override
  State<_ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<_ConfettiLayer> {
  late final List<ConfettiParticle> _particles;
  Timer? _fadeTimer;
  bool _visible = true;
  bool _animating = true;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(
      _particleCount,
      (_) => ConfettiParticle.random(colorCount: _colors.length),
    );
    _fadeTimer = Timer(_confettiRunDuration, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: _confettiFadeDuration,
      // Stop repainting only once fully faded so particles never freeze
      // visibly midair.
      onEnd: () {
        if (!_visible) setState(() => _animating = false);
      },
      child: ConfettiLayer(
        animating: _animating,
        painter: (progress) => ConfettiPainter(
          particles: _particles,
          colors: _colors,
          progress: progress,
        ),
      ),
    );
  }
}

const _colors = [
  AppColors.gold,
  AppColors.success,
  AppColors.glowBlue,
  AppColors.celebrationPink,
];
