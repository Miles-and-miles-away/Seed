import 'dart:async';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
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
  late List<ConfettiParticle> _particles;
  bool _showMascot = false;
  bool _showNameInput = false;
  final _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: durationParticleLoop,
    );
    _particles =
        List.generate(40, (_) => ConfettiParticle.random(colorCount: 4));
    _startSequence();
  }

  Future<void> _startSequence() async {
    unawaited(_particleController.repeat());

    // Show mascot reveal after egg crack delay
    await Future<void>.delayed(durationReveal);
    if (mounted) setState(() => _showMascot = true);

    await Future<void>.delayed(durationCelebration);
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

    final speciesList = ref
        .watch(
          mascotSpeciesDataProvider,
        )
        .value;
    final species = speciesList != null
        ? getSpeciesById(
            widget.hatchedMascot.speciesId,
            speciesList,
          )
        : null;
    final assetPath = species?.evolutionStages.first.assetPath;
    final speciesName = species?.name(locale) ?? '';

    return CelebrationOverlay(
      children: [
        // Particles
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: ConfettiPainter(
                  particles: _particles,
                  colors: const [
                    AppColors.gold,
                    AppColors.success,
                    AppColors.glowBlue,
                    AppColors.celebrationPink,
                  ],
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
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

              const Spacer(),

              // Egg cracking -> mascot reveal
              if (!_showMascot)
                const Icon(
                  Icons.egg,
                  size: 120,
                  color: AppColors.eggBeige,
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
                    const SizedBox(height: spacingLg),
                    Text(
                      speciesName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.gold,
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
                    horizontal: spacingHuge,
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
                      const SizedBox(height: spacingMd),
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
                            color: Colors.white.withValues(
                              alpha: opacityMedium,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withValues(
                                alpha: opacityHalf,
                              ),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.gold,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: spacingXxl),
                      FilledButton(
                        onPressed: _isSubmitting ? null : _handleConfirm,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: spacingHuge,
                            vertical: spacingLg,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadiusLg,
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: spacingXxl,
                                height: spacingXxl,
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

              const SizedBox(height: spacingHuge),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shows the egg hatching celebration overlay.
Future<void> showEggHatchingCelebration(
  BuildContext context,
  MascotModel hatchedMascot,
) {
  return showCelebrationOverlay(
    context,
    (onDismiss) => EggHatchingCelebration(
      hatchedMascot: hatchedMascot,
      onDismiss: onDismiss,
    ),
  );
}
