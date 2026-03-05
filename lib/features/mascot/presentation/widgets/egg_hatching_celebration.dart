import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/mascot_species_data.dart';
import '../../data/models/mascot_model.dart';
import '../../data/models/mascot_species_model.dart';
import '../providers/mascot_providers.dart';

/// Full-screen celebration shown when an egg hatches into
/// a new mascot. Includes a name input field.
class EggHatchingCelebration extends ConsumerStatefulWidget {
  const EggHatchingCelebration({
    required this.hatchedMascot,
    required this.onDismiss,
    super.key,
  });

  final MascotModel hatchedMascot;
  final VoidCallback onDismiss;

  @override
  ConsumerState<EggHatchingCelebration> createState() =>
      _EggHatchingCelebrationState();
}

class _EggHatchingCelebrationState extends ConsumerState<EggHatchingCelebration>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late List<_Particle> _particles;
  bool _showMascot = false;
  bool _showNameInput = false;
  final _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _particles = List.generate(40, (_) => _Particle.random());
    _startSequence();
  }

  Future<void> _startSequence() async {
    unawaited(_particleController.repeat());

    // Show mascot reveal after egg crack delay
    await Future<void>.delayed(
      const Duration(milliseconds: 800),
    );
    if (mounted) setState(() => _showMascot = true);

    await Future<void>.delayed(
      const Duration(milliseconds: 1200),
    );
    if (mounted) setState(() => _showNameInput = true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final name = _nameController.text.trim();
    if (name.length < 2 || name.length > 20) return;

    setState(() => _isSubmitting = true);

    await ref.read(mascotProvider.notifier).nameHatchedMascot(
          widget.hatchedMascot.id,
          name,
        );

    if (mounted) widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final species = getSpeciesById(widget.hatchedMascot.speciesId);
    final assetPath = species?.evolutionStages.first.assetPath;
    final speciesName = species?.getName(locale) ?? '';

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

          // Particles
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _particleController.value,
                  ),
                );
              },
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Title
                Text(
                  l10n.eggHatchingTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.2, end: 0),

                const Spacer(),

                // Egg cracking -> mascot reveal
                if (!_showMascot)
                  const Icon(
                    Icons.egg,
                    size: 120,
                    color: Color(0xFFF5F5DC),
                  )
                      .animate()
                      .shake(
                        duration: 600.ms,
                        hz: 6,
                      )
                      .then()
                      .scale(
                        end: const Offset(1.3, 1.3),
                        duration: 200.ms,
                      )
                else if (assetPath != null)
                  Column(
                    children: [
                      SvgPicture.asset(
                        assetPath,
                        width: 160,
                        height: 160,
                      ).animate().fadeIn(duration: 500.ms).scale(
                            begin: const Offset(0.3, 0.3),
                            end: const Offset(1, 1),
                            curve: Curves.elasticOut,
                            duration: 800.ms,
                          ),
                      const SizedBox(height: 16),
                      Text(
                        speciesName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fadeIn(
                            delay: 300.ms,
                            duration: 400.ms,
                          ),
                    ],
                  ),

                const Spacer(),

                // Name input
                if (_showNameInput)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.eggHatchingNamePrompt,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.words,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.mascotNameHint,
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFFD700),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _isSubmitting ? null : _handleConfirm,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.eggHatchingConfirm,
                                ),
                        ),
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
                  ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.colorIndex,
    required this.rotation,
    required this.rotationSpeed,
  });

  factory _Particle.random() {
    final rng = Random();
    return _Particle(
      x: rng.nextDouble(),
      y: -rng.nextDouble() * 0.5,
      size: rng.nextDouble() * 8 + 4,
      speed: rng.nextDouble() * 0.5 + 0.3,
      colorIndex: rng.nextInt(4),
      rotation: rng.nextDouble() * pi * 2,
      rotationSpeed: (rng.nextDouble() - 0.5) * 0.2,
    );
  }

  final double x;
  double y;
  final double size;
  final double speed;
  final int colorIndex;
  double rotation;
  final double rotationSpeed;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<_Particle> particles;
  final double progress;

  static const _colors = [
    Color(0xFFFFD700),
    Color(0xFF4CAF50),
    Color(0xFF90CAF9),
    Color(0xFFFF69B4),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p
        ..y += p.speed * 0.02
        ..rotation += p.rotationSpeed;
      if (p.y > 1.2) p.y = -0.1;

      final paint = Paint()
        ..color = _colors[p.colorIndex].withValues(alpha: 0.7);

      canvas
        ..save()
        ..translate(p.x * size.width, p.y * size.height)
        ..rotate(p.rotation)
        ..drawCircle(Offset.zero, p.size * 0.5, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}

/// Shows the egg hatching celebration overlay.
Future<void> showEggHatchingCelebration(
  BuildContext context,
  MascotModel hatchedMascot,
) async {
  await showGeneralDialog<void>(
    context: context,
    barrierColor: Colors.transparent,
    pageBuilder: (context, animation, secondaryAnimation) {
      return EggHatchingCelebration(
        hatchedMascot: hatchedMascot,
        onDismiss: () => Navigator.of(context).pop(),
      );
    },
    transitionDuration: Duration.zero,
  );
}
