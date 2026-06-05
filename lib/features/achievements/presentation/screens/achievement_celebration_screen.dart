import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/achievements/data/models/achievement_definition_model.dart';
import 'package:seed_app/features/achievements/presentation/widgets/achievement_icons.dart';

/// Full-screen celebration shown when the user unlocks an
/// achievement. Dismissed only via the acknowledge button -- no
/// auto-dismiss timer so a user who looks away will not silently
/// lose the moment.
///
/// Use [showAchievementCelebrations] (below) rather than instantiating
/// this widget directly; that helper handles the sequential queue
/// and "+N more" hint.
class AchievementCelebrationScreen extends StatelessWidget {
  const AchievementCelebrationScreen({
    required this.definition,
    required this.onDismiss,
    super.key,
    this.remainingInQueue = 0,
  });

  final AchievementDefinition definition;
  final VoidCallback onDismiss;

  /// How many more celebrations are queued behind this one. Drives
  /// the "+N more achievements" hint so the user knows what they are
  /// about to see.
  final int remainingInQueue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop
          RepaintBoundary(
            child: Container(
              color: Colors.black.withValues(alpha: opacityNearOpaque),
            ).animate().fadeIn(duration: 300.ms),
          ),

          // Confetti
          const RepaintBoundary(child: _ConfettiLayer()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacingXxl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.achievementUnlockedTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.2, end: 0),
                  const SizedBox(height: spacingXxxl),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      achievementIconFor(definition.iconName),
                      size: 72,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(
                        begin: const Offset(0.3, 0.3),
                        end: const Offset(1, 1),
                        curve: Curves.elasticOut,
                        duration: 800.ms,
                      ),
                  const SizedBox(height: spacingXxl),
                  Text(
                    definition.name(locale),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: spacingMd),
                  Text(
                    definition.description(locale),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: opacityHeavy),
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
                  const SizedBox(height: spacingXxl),
                  Text(
                    l10n.achievementBonusPoints(definition.bonusPoints),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms).scale(
                        delay: 500.ms,
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                      ),
                  const SizedBox(height: spacingHuge),
                  FilledButton(
                    onPressed: onDismiss,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingHuge,
                        vertical: spacingLg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: borderRadiusLg,
                      ),
                    ),
                    child: Text(l10n.achievementAcknowledge),
                  )
                      .animate(delay: 800.ms)
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.3, end: 0),
                  if (remainingInQueue > 0) ...[
                    const SizedBox(height: spacingMd),
                    Text(
                      l10n.achievementMoreQueued(remainingInQueue),
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
      ),
    );
  }
}

/// Shows each definition in [definitions] sequentially. Each
/// celebration is acknowledged via its button before the next is
/// shown. Returns once the queue is empty.
Future<void> showAchievementCelebrations(
  BuildContext context, {
  required List<AchievementDefinition> definitions,
}) async {
  if (definitions.isEmpty) return;

  for (var i = 0; i < definitions.length; i++) {
    if (!context.mounted) return;
    final remaining = definitions.length - i - 1;
    await showGeneralDialog<void>(
      context: context,
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, _, __) {
        return AchievementCelebrationScreen(
          definition: definitions[i],
          remainingInQueue: remaining,
          onDismiss: () => Navigator.of(dialogContext).pop(),
        );
      },
      transitionDuration: Duration.zero,
    );
  }
}

// ---------------------------------------------------------------------------
// Confetti layer -- separate from EggHatchingCelebration's painter so a
// future tweak to one widget cannot regress the other. Same visual
// vocabulary (gold / success / glowBlue / celebrationPink); revisit
// extracting a shared widget if a third caller appears.
// ---------------------------------------------------------------------------

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

class _ConfettiLayerState extends State<_ConfettiLayer>
    with SingleTickerProviderStateMixin {
  static final _rng = Random();

  late final AnimationController _controller;
  late final List<_Particle> _particles;
  Timer? _fadeTimer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: durationParticleLoop,
    )..repeat();
    _particles = List.generate(_particleCount, (_) => _Particle.random(_rng));
    _fadeTimer = Timer(_confettiRunDuration, () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _fadeTimer?.cancel();
    _controller.dispose();
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
        if (!_visible) _controller.stop();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        ),
      ),
    );
  }
}

@immutable
class _Particle {
  const _Particle({
    required this.x,
    required this.phase,
    required this.cyclesPerLoop,
    required this.size,
    required this.colorIndex,
    required this.initialRotation,
    required this.rotationsPerLoop,
  });

  factory _Particle.random(Random rng) {
    return _Particle(
      x: rng.nextDouble(),
      phase: rng.nextDouble(),
      // Vary fall rate so particles don't move in lockstep.
      cyclesPerLoop: rng.nextDouble() * 0.6 + 0.5,
      size: rng.nextDouble() * 8 + 4,
      colorIndex: rng.nextInt(4),
      initialRotation: rng.nextDouble() * pi * 2,
      rotationsPerLoop: (rng.nextDouble() - 0.5) * 2,
    );
  }

  final double x;
  final double phase;
  final double cyclesPerLoop;
  final double size;
  final int colorIndex;
  final double initialRotation;
  final double rotationsPerLoop;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_Particle> particles;
  final double progress;

  static const _yStart = -0.1;
  static const _yEnd = 1.2;
  static const _yRange = _yEnd - _yStart;

  static const _colors = [
    AppColors.gold,
    AppColors.success,
    AppColors.glowBlue,
    AppColors.celebrationPink,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.cyclesPerLoop + p.phase) % 1.0;
      final y = _yStart + t * _yRange;
      final rotation =
          p.initialRotation + progress * p.rotationsPerLoop * 2 * pi;

      final paint = Paint()
        ..color = _colors[p.colorIndex].withValues(alpha: opacityStrong);

      canvas
        ..save()
        ..translate(p.x * size.width, y * size.height)
        ..rotate(rotation)
        ..drawCircle(Offset.zero, p.size * 0.5, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
