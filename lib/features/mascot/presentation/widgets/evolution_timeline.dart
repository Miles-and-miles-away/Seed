import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

/// Horizontal evolution timeline: one card per stage with connectors,
/// greyed-out art for stages not yet reached and a pulse on the current one.
class EvolutionTimeline extends StatelessWidget {
  const EvolutionTimeline({
    required this.stages,
    required this.currentStage,
    super.key,
  });

  final List<EvolutionStageModel> stages;
  final int currentStage;

  static const _stageFlex = 4;
  static const _timelineHeight = 140.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return SizedBox(
      height: _timelineHeight,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: _stagesAndGaps(
                (i) => _buildStageCard(i, colorScheme),
                (i) => Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: spacingXs),
                  decoration: BoxDecoration(
                    color: currentStage > i + 1
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: spacingXs),
          // Names share one row, so a wrapped name shortens no card.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _stagesAndGaps(
              (i) => _buildStageLabel(context, i, locale, colorScheme),
              (_) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  /// One flexed child per stage with a narrower one between each pair, so
  /// the card row and the name row share the same columns.
  List<Widget> _stagesAndGaps(
    Widget Function(int stageIndex) stage,
    Widget Function(int stageIndex) gap,
  ) {
    return List.generate(stages.length * 2 - 1, (index) {
      final stageIndex = index ~/ 2;
      return index.isOdd
          ? Expanded(child: gap(stageIndex))
          : Expanded(flex: _stageFlex, child: stage(stageIndex));
    });
  }

  Widget _buildStageLabel(
    BuildContext context,
    int stageIndex,
    String locale,
    ColorScheme colorScheme,
  ) {
    final stage = stages[stageIndex];
    final isCurrentStage = currentStage == stageIndex + 1;
    final isUnlocked = currentStage >= stageIndex + 1;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          stage.name(locale),
          style: textTheme.labelSmall?.copyWith(
            color: isUnlocked
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: opacityHalf),
            fontWeight: isCurrentStage ? FontWeight.bold : null,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          AppLocalizations.of(context).mascotLevelShort(stage.level),
          style: textTheme.labelSmall?.copyWith(
            color: isUnlocked
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: opacityMedium),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStageCard(int stageIndex, ColorScheme colorScheme) {
    final stage = stages[stageIndex];
    final isCurrentStage = currentStage == stageIndex + 1;
    final isUnlocked = currentStage >= stageIndex + 1;
    Widget card = Container(
      height: double.infinity,
      padding: const EdgeInsets.all(spacingSm),
      decoration: BoxDecoration(
        color: isCurrentStage
            ? colorScheme.primaryContainer
            : isUnlocked
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainerHighest.withValues(
                alpha: opacityHalf,
              ),
        borderRadius: borderRadiusMd,
        border: isCurrentStage
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: isUnlocked
          ? MascotImage(
              assetPath: stage.assetPath,
              artboardName: stage.artboardName,
              onRiveInit: pauseRive,
            )
          : ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                0.4,
                0,
              ]),
              child: MascotImage(
                assetPath: stage.assetPath,
                artboardName: stage.artboardName,
                onRiveInit: pauseRive,
              ),
            ),
    );

    if (isCurrentStage) {
      card = card
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.02, 1.02),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }

    return card;
  }
}
