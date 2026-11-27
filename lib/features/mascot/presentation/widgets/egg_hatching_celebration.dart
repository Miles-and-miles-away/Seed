import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/log_error_message.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/drawn/reveal_effects.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';
import 'package:seed_app/shared/widgets/confetti_painter.dart';
import '../providers/mascot_providers.dart';
import 'mascot_image.dart';

/// When the name prompt appears: after the mascot hops out and wakes.
const eggHatchingPromptDelay = Duration(milliseconds: 2600);

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

class _EggHatchingCelebrationState
    extends ConsumerState<EggHatchingCelebration> {
  static const double _mascotSize = 160;
  static final Duration _nameDelay = Duration(
    milliseconds: (eggSplitSeconds * 1000).round() + 300,
  );

  bool _showNameInput = false;
  final _nameController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future<void>.delayed(eggHatchingPromptDelay);
    if (mounted) setState(() => _showNameInput = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final name = _nameController.text.trim();
    if (name.length < 2 || name.length > 20) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    final mascots = ref.read(mascotProvider.notifier);
    await mascots.nameHatchedMascot(widget.hatchedMascot.id, name);
    if (!mounted) return;
    final error = ref.read(mascotProvider).error;
    if (error == null) {
      widget.onDismiss();
      return;
    }
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isSubmitting = false;
      _error = isOfflineError(error) ? l10n.errorNetwork : l10n.errorGeneric;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final speciesList = ref.watch(mascotSpeciesDataProvider).value;
    final species = speciesList != null
        ? getSpeciesById(widget.hatchedMascot.speciesId, speciesList)
        : null;
    final assetPath = species?.evolutionStages.first.assetPath;
    final speciesName = species?.name(locale) ?? '';

    return CelebrationOverlay(
      children: [
        const TimedConfettiLayer(),

        // Content
        SafeArea(
          child: CelebrationScrollBody(
            children: [
              const SizedBox.shrink(),

              CelebrationTitle(l10n.eggHatchingTitle),

              if (assetPath != null)
                Column(
                  children: [
                    HatchingEgg(
                      size: _mascotSize,
                      child: MascotImage(
                        assetPath: assetPath,
                        width: _mascotSize,
                        height: _mascotSize,
                        routine: hatch,
                      ),
                    ),
                    const SizedBox(height: spacingLg),
                    Text(
                      speciesName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: _nameDelay, duration: 400.ms),
                  ],
                )
              else
                const SizedBox.square(dimension: _mascotSize),

              Column(
                children: [
                  // Name input
                  if (_showNameInput)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacingHuge,
                      ),
                      child:
                          Column(
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
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                    onPressed: _isSubmitting
                                        ? null
                                        : _handleConfirm,
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
                                        : Text(l10n.eggHatchingConfirm),
                                  ),
                                  if (_error case final error?) ...[
                                    const SizedBox(height: spacingMd),
                                    Text(
                                      error,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .errorContainer,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // The shell asks again on the next start.
                                    TextButton(
                                      onPressed: widget.onDismiss,
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text(l10n.challengeDialogLater),
                                    ),
                                  ],
                                ],
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                    ),

                  const SizedBox(height: spacingHuge),
                ],
              ),
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
