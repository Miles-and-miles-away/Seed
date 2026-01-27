import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../mascot/presentation/providers/mascot_providers.dart';
import '../providers/settings_providers.dart';

/// Dialog shown when the user reaches a weekly streak milestone.
///
/// Features:
/// - Celebration animation with confetti
/// - Mascot display
/// - Week count and days display
/// - Encouraging message
class StreakMilestoneDialog extends ConsumerStatefulWidget {
  const StreakMilestoneDialog({
    required this.weekNumber,
    required this.totalDays,
    required this.onDismiss,
    super.key,
  });

  /// The milestone week number achieved (1, 2, 3, etc.).
  final int weekNumber;

  /// The total streak days.
  final int totalDays;

  /// Callback when the dialog is dismissed.
  final VoidCallback onDismiss;

  @override
  ConsumerState<StreakMilestoneDialog> createState() =>
      _StreakMilestoneDialogState();
}

class _StreakMilestoneDialogState extends ConsumerState<StreakMilestoneDialog>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<_Particle> _particles;
  bool _showContent = false;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Generate confetti particles
    _particles = List.generate(40, (_) => _Particle.random());

    // Start animations in sequence
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Start particles immediately
    unawaited(_particleController.repeat());

    // Show content after brief delay
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() => _showContent = true);
    }

    // Show button after content animation
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _showButton = true);
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    // Mark milestone as seen
    await ref
        .read(settingsProvider.notifier)
        .markMilestoneSeen(widget.weekNumber);
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final assetPath = ref.watch(mascotAssetPathProvider);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop
          RepaintBoundary(
            child: Container(
              color: Colors.black.withValues(alpha: 0.85),
            ).animate().fadeIn(duration: 300.ms),
          ),

          // Confetti particles
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _particleController.value,
                    colors: [
                      const Color(0xFFFFD700), // Gold
                      colorScheme.primary,
                      colorScheme.secondary,
                      const Color(0xFF4CAF50), // Green
                      const Color(0xFFFF69B4), // Pink
                    ],
                  ),
                );
              },
            ),
          ),

          // Main content
          if (_showContent)
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        l10n.streakMilestoneTitle,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 100.ms, duration: 400.ms)
                          .slideY(begin: -0.2, end: 0),

                      const SizedBox(height: 32),

                      // Mascot with glow
                      if (assetPath != null)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow effect
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFD700)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 300.ms, duration: 500.ms)
                                .scale(
                                  begin: const Offset(0.5, 0.5),
                                  end: const Offset(1, 1),
                                ),

                            // Mascot (bouncing)
                            SvgPicture.asset(
                              assetPath,
                              width: 140,
                              height: 140,
                            )
                                .animate()
                                .fadeIn(delay: 400.ms, duration: 400.ms)
                                .scale(
                                  begin: const Offset(0.3, 0.3),
                                  end: const Offset(1, 1),
                                  curve: Curves.elasticOut,
                                  duration: 800.ms,
                                )
                                .then() // Chain animation
                                .animate(
                                  onPlay: (controller) => controller.repeat(
                                    reverse: true,
                                  ),
                                )
                                .moveY(
                                  begin: 0,
                                  end: -8,
                                  duration: 600.ms,
                                  curve: Curves.easeInOut,
                                ),
                          ],
                        ),

                      const SizedBox(height: 32),

                      // Week streak badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFFA500),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFFFFD700).withValues(alpha: 0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.streakMilestoneWeeks(widget.weekNumber),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 400.ms)
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 16),

                      // Days count
                      Text(
                        l10n.streakMilestoneDays(widget.totalDays),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 900.ms, duration: 400.ms),

                      const SizedBox(height: 8),

                      // Encouraging message
                      Text(
                        l10n.streakMilestoneKeepGoing,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),

                      const SizedBox(height: 32),

                      // Continue button
                      if (_showButton)
                        FilledButton(
                          onPressed: _handleDismiss,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(l10n.streakMilestoneContinue),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A single confetti particle.
class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.colorIndex,
    required this.rotation,
    required this.rotationSpeed,
    required this.shape,
  });

  factory _Particle.random() {
    final random = Random();
    return _Particle(
      x: random.nextDouble(),
      y: -random.nextDouble() * 0.5,
      size: random.nextDouble() * 10 + 5,
      speed: random.nextDouble() * 0.5 + 0.3,
      colorIndex: random.nextInt(5),
      rotation: random.nextDouble() * pi * 2,
      rotationSpeed: (random.nextDouble() - 0.5) * 0.2,
      shape: random.nextInt(3),
    );
  }

  final double x;
  double y;
  final double size;
  final double speed;
  final int colorIndex;
  double rotation;
  final double rotationSpeed;
  final int shape;
}

/// Paints the confetti particles.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.colors,
  });

  final List<_Particle> particles;
  final double progress;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      particle
        ..y += particle.speed * 0.02
        ..rotation += particle.rotationSpeed;

      if (particle.y > 1.2) {
        particle.y = -0.1;
      }

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      final paint = Paint()
        ..color = colors[particle.colorIndex].withValues(alpha: 0.8);

      canvas
        ..save()
        ..translate(x, y)
        ..rotate(particle.rotation);

      switch (particle.shape) {
        case 0:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        case 1:
          canvas.drawCircle(Offset.zero, particle.size * 0.5, paint);
        case 2:
          _drawStar(canvas, particle.size * 0.5, paint);
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const innerRadius = 0.4;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * innerRadius;
      final angle = (i * pi / points) - (pi / 2);
      final x = r * cos(angle);
      final y = r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

/// Shows the streak milestone celebration dialog.
///
/// Call this method when a weekly milestone is crossed.
Future<void> showStreakMilestoneCelebration(
  BuildContext context, {
  required int weekNumber,
  required int totalDays,
}) async {
  await showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return StreakMilestoneDialog(
        weekNumber: weekNumber,
        totalDays: totalDays,
        onDismiss: () => Navigator.of(context).pop(),
      );
    },
    transitionDuration: Duration.zero,
  );
}
