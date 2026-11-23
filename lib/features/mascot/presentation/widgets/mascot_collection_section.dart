import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_progress_widget.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

/// "My Mascots" horizontal collection: one thumbnail per owned mascot,
/// with the in-progress egg at the end. Tapping an inactive mascot asks
/// for confirmation before switching.
class MascotCollectionSection extends ConsumerWidget {
  const MascotCollectionSection({
    required this.mascots,
    required this.activeMascotId,
    required this.hasEgg,
    super.key,
  });

  final List<MascotModel> mascots;
  final String activeMascotId;
  final bool hasEgg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hint = _hint(ref, l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.mascotCollectionTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: spacingMd),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: mascots.length + (hasEgg ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: spacingMd),
            itemBuilder: (context, index) {
              if (index < mascots.length) {
                final m = mascots[index];
                final isActive = m.id == activeMascotId;
                return _buildThumbnail(context, ref, m, isActive);
              }
              // Egg at the end
              return const EggProgressWidget();
            },
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: spacingMd),
          Text(
            hint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  /// Days left for the egg, else how to earn one while a species is unowned.
  String? _hint(WidgetRef ref, AppLocalizations l10n) {
    final egg = ref.watch(currentEggProvider);
    if (egg != null) {
      final days = ref.watch(eggStreakDaysProvider);
      if (days == 0 && egg.hatchingStreakDays > 1) {
        return l10n.eggStreakResetMessage;
      }
      return l10n.eggDaysLeftHint(
        AppConstants.eggHatchingStreakRequired - days,
      );
    }
    final species = ref.watch(mascotSpeciesDataProvider).value ?? [];
    final owned = mascots.map((m) => m.speciesId).toSet();
    final stages = ref.watch(activeSpeciesProvider)?.evolutionStages ?? [];
    if (stages.length < AppConstants.speciesUnlockStage ||
        selectableSpecies(species).every((s) => owned.contains(s.id))) {
      return null;
    }
    return l10n.speciesUnlockHint(
      stages[AppConstants.speciesUnlockStage - 1].level,
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    WidgetRef ref,
    MascotModel mascot,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final species = _getSpeciesForMascot(ref, mascot.speciesId);
    if (species == null) return const SizedBox.shrink();

    final stage = species.getStageForLevel(mascot.mascotLevel);

    return GestureDetector(
      onTap: isActive
          ? null
          : () => _showSwitchConfirmation(context, ref, mascot),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: borderRadiusMd,
          border: isActive
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MascotImage(assetPath: stage.assetPath, width: 44, height: 44),
            const SizedBox(height: spacingXs),
            Text(
              mascot.name.isEmpty ? species.name(locale) : mascot.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: isActive ? FontWeight.bold : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              AppLocalizations.of(context).mascotLevelShort(mascot.mascotLevel),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  MascotSpeciesModel? _getSpeciesForMascot(WidgetRef ref, String id) {
    final speciesList = ref.read(mascotSpeciesDataProvider).value;
    if (speciesList == null) return null;
    return getSpeciesById(id, speciesList);
  }

  void _showSwitchConfirmation(
    BuildContext context,
    WidgetRef ref,
    MascotModel target,
  ) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final name = target.name.isNotEmpty
        ? target.name
        : _getSpeciesForMascot(ref, target.speciesId)?.name(locale) ??
              target.speciesId;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mascotSwitchConfirm),
        content: PhraseText(
          l10n.mascotSwitchConfirmBody(name),
          minLineWidth: phraseDialogMinLineWidth,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(mascotProvider.notifier).switchActiveMascot(target.id);
            },
            child: Text(l10n.switchMascotButton),
          ),
        ],
      ),
    );
  }
}
