import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;

    return SizedBox(
      height: 140,
      child: Row(
        children: List.generate(stages.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stageIndex = index ~/ 2;
            final isUnlocked = currentStage > stageIndex + 1;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: spacingXs),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          final stageIndex = index ~/ 2;
          final stage = stages[stageIndex];
          final isCurrentStage = currentStage == stageIndex + 1;
          final isUnlocked = currentStage >= stageIndex + 1;
          final stageName = switch (locale) {
            'ja' => stage.nameJa,
            'es' when stage.nameEs.isNotEmpty => stage.nameEs,
            _ => stage.nameEn,
          };

          return Expanded(
            flex: 2,
            child: _buildStageCard(
              context,
              stage,
              stageName,
              isCurrentStage,
              isUnlocked,
              colorScheme,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStageCard(
    BuildContext context,
    EvolutionStageModel stage,
    String stageName,
    bool isCurrentStage,
    bool isUnlocked,
    ColorScheme colorScheme,
  ) {
    Widget card = Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: isUnlocked
                ? MascotImage(
                    assetPath: stage.assetPath,
                    artboardName: stage.artboardName,
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
                    ),
                  ),
          ),
          const SizedBox(height: spacingXs),
          Text(
            stageName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isUnlocked
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withValues(alpha: opacityHalf),
              fontWeight: isCurrentStage ? FontWeight.bold : null,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            AppLocalizations.of(context).mascotLevelShort(stage.level),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isUnlocked
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: opacityMedium),
              fontSize: 10,
            ),
          ),
        ],
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
