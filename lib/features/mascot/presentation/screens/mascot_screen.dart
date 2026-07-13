import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import '../providers/mascot_providers.dart';
import '../widgets/egg_progress_widget.dart';
import '../widgets/mascot_display.dart';
import '../widgets/mascot_image.dart';

/// The main mascot screen with evolution timeline and
/// multi-mascot collection.
class MascotScreen extends ConsumerStatefulWidget {
  const MascotScreen({super.key});

  @override
  ConsumerState<MascotScreen> createState() => _MascotScreenState();
}

class _MascotScreenState extends ConsumerState<MascotScreen> {
  static const _statPlaceholder = '--';

  bool _isRenaming = false;
  final _renameController = TextEditingController();
  final _renameFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final mascot = ref.watch(activeMascotProvider).value;
    final species = ref.watch(activeSpeciesProvider);
    final currentStage = ref.watch(activeMascotStageProvider);
    final stageName = ref.watch(stageLocalizedNameProvider(locale));
    final nextStageData = ref.watch(activeNextStageDataProvider);
    final allMascots = ref.watch(allMascotsProvider).value ?? [];
    final hasEgg = ref.watch(hasEggProvider);

    if (mascot == null || species == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: spacingLg),
              Text(l10n.navMascot),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(l10n.navMascot),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(spacingXxl),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot display
                  Center(
                    child: Column(
                      children: [
                        const MascotDisplay(size: 220),
                        const SizedBox(height: spacingLg),
                        _buildNameSection(
                          mascot.name,
                          colorScheme,
                        ),
                        const SizedBox(height: spacingSm),
                        _buildStageBadge(
                          stageName ?? l10n.stageFallback(currentStage),
                          mascot.mascotLevel,
                          colorScheme,
                          l10n,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: spacingXxxl),

                  // Our Journey -- per-mascot stats
                  _buildStatsSummary(mascot, theme, colorScheme, locale, l10n),

                  const SizedBox(height: spacingXxxl),

                  // My Mascots collection
                  if (allMascots.length > 1 || hasEgg)
                    ..._buildMascotCollection(
                      allMascots,
                      mascot.id,
                      hasEgg,
                      locale,
                      theme,
                      colorScheme,
                    ),

                  // Evolution Timeline
                  Text(
                    l10n.mascotEvolutionTimeline,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: spacingLg),
                  _buildEvolutionTimeline(
                    species.evolutionStages,
                    currentStage,
                    mascot.mascotLevel,
                    locale,
                  ),

                  const SizedBox(height: spacingXxxl),

                  // Next Evolution / Max Evolution
                  if (nextStageData != null) ...[
                    Text(
                      l10n.mascotNextEvolution,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacingLg),
                    _buildNextEvolutionCard(
                      nextStageData,
                      mascot.mascotLevel,
                      locale,
                      colorScheme,
                    ),
                  ] else ...[
                    _buildMaxEvolutionCard(colorScheme),
                  ],

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // Our Journey -- per-mascot stats summary
  // =========================================================

  /// Per-mascot stats card. Each stat is derived from the mascot itself
  /// (`createdAt`, `co2SavedGrams`), so it stays correct when the user
  /// switches between mascots they are raising one at a time.
  Widget _buildStatsSummary(
    MascotModel mascot,
    ThemeData theme,
    ColorScheme colorScheme,
    String locale,
    AppLocalizations l10n,
  ) {
    final createdAt = mascot.createdAt;
    final birthdayText = createdAt != null
        ? DateFormat.yMMMd(locale).format(createdAt)
        : _statPlaceholder;
    final daysTogether = createdAt != null ? _daysTogether(createdAt) : 0;

    return Container(
      padding: const EdgeInsets.all(spacingLg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: borderRadiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.mascotStatsTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.cake_outlined,
            l10n.mascotStatBirthday,
            birthdayText,
            theme,
            colorScheme,
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.favorite_outline,
            l10n.mascotStatDaysTogether,
            '$daysTogether',
            theme,
            colorScheme,
          ),
          const SizedBox(height: spacingMd),
          _buildStatRow(
            Icons.eco_outlined,
            l10n.mascotStatCo2Together,
            formatCO2Compact(mascot.co2SavedGrams),
            theme,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
    IconData icon,
    String label,
    String value,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: spacingMd),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Days the user and mascot have been together, counting the birthday
  /// as day 1. Uses date-only values so partial days do not skew the count.
  int _daysTogether(DateTime birthday) {
    final now = DateTime.now();
    final start = DateTime(birthday.year, birthday.month, birthday.day);
    final today = DateTime(now.year, now.month, now.day);
    return today.difference(start).inDays + 1;
  }

  // =========================================================
  // My Mascots collection section
  // =========================================================

  List<Widget> _buildMascotCollection(
    List<MascotModel> mascots,
    String activeMascotId,
    bool hasEgg,
    String locale,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context);
    return [
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
          separatorBuilder: (_, __) => const SizedBox(width: spacingMd),
          itemBuilder: (context, index) {
            if (index < mascots.length) {
              final m = mascots[index];
              final isActive = m.id == activeMascotId;
              return _buildMascotThumbnail(
                m,
                isActive,
                locale,
                colorScheme,
              );
            }
            // Egg at the end
            return const EggProgressWidget();
          },
        ),
      ),
      const SizedBox(height: spacingXxxl),
    ];
  }

  Widget _buildMascotThumbnail(
    MascotModel mascot,
    bool isActive,
    String locale,
    ColorScheme colorScheme,
  ) {
    final species = _getSpeciesForMascot(mascot.speciesId);
    if (species == null) return const SizedBox.shrink();

    final stage = species.getStageForLevel(mascot.mascotLevel);

    return GestureDetector(
      onTap: isActive ? null : () => _showSwitchConfirmation(mascot),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: borderRadiusMd,
          border: isActive
              ? Border.all(
                  color: colorScheme.primary,
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MascotImage(
              assetPath: stage.assetPath,
              width: 44,
              height: 44,
            ),
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
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  MascotSpeciesModel? _getSpeciesForMascot(String id) {
    final speciesList = ref
        .read(
          mascotSpeciesDataProvider,
        )
        .value;
    if (speciesList == null) return null;
    return getSpeciesById(id, speciesList);
  }

  void _showSwitchConfirmation(MascotModel target) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.mascotSwitchConfirm),
        content: Text(
          '${l10n.switchToMascot} ${target.name.isEmpty ? target.speciesId : target.name}?',
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

  // =========================================================
  // Existing UI sections (adapted for mascotLevel)
  // =========================================================

  Widget _buildNameSection(
    String name,
    ColorScheme colorScheme,
  ) {
    if (_isRenaming) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Form(
              key: _renameFormKey,
              child: TextFormField(
                controller: _renameController,
                autofocus: true,
                textAlign: TextAlign.center,
                maxLength: AppConstants.maxMascotNameLength,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: spacingMd,
                    vertical: spacingSm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: borderRadiusSm,
                  ),
                ),
                validator: (value) {
                  final l10n = AppLocalizations.of(context);
                  if (value == null || value.trim().isEmpty) {
                    return l10n.mascotNameRequired;
                  }
                  if (value.trim().length > AppConstants.maxMascotNameLength) {
                    return l10n.mascotNameTooLong;
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(width: spacingSm),
          IconButton(
            onPressed: _submitRename,
            icon: Icon(
              Icons.check,
              color: colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: _cancelRename,
            icon: Icon(
              Icons.close,
              color: colorScheme.error,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: spacingSm),
        IconButton(
          onPressed: _startRename,
          icon: Icon(
            Icons.edit,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          tooltip: AppLocalizations.of(context).mascotRename,
        ),
      ],
    );
  }

  void _startRename() {
    final mascot = ref.read(activeMascotProvider).value;
    _renameController.text = mascot?.name ?? '';
    setState(() => _isRenaming = true);
  }

  void _cancelRename() {
    setState(() => _isRenaming = false);
  }

  Future<void> _submitRename() async {
    // Surfaces mascotNameRequired/mascotNameTooLong inline instead of
    // silently ignoring the tap.
    if (!(_renameFormKey.currentState?.validate() ?? false)) {
      return;
    }
    final newName = _renameController.text.trim();

    await ref.read(mascotProvider.notifier).renameMascot(newName);
    if (mounted) setState(() => _isRenaming = false);
  }

  Widget _buildStageBadge(
    String stageName,
    int mascotLevel,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingLg,
        vertical: spacingSm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: borderRadiusXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            '$stageName'
            ' - ${l10n.levelLabel(mascotLevel)}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionTimeline(
    List<EvolutionStageModel> stages,
    int currentStage,
    int mascotLevel,
    String locale,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

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
                margin: const EdgeInsets.symmetric(
                  horizontal: spacingXs,
                ),
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
                : colorScheme.surfaceContainerHighest
                    .withValues(alpha: opacityHalf),
        borderRadius: borderRadiusMd,
        border: isCurrentStage
            ? Border.all(
                color: colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: isUnlocked
                ? MascotImage(assetPath: stage.assetPath)
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
                    child: MascotImage(assetPath: stage.assetPath),
                  ),
          ),
          const SizedBox(height: spacingXs),
          Text(
            stageName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isUnlocked
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(
                          alpha: opacityHalf,
                        ),
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
                      : colorScheme.onSurface.withValues(
                          alpha: opacityMedium,
                        ),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );

    if (isCurrentStage) {
      card = card
          .animate(
            onPlay: (c) => c.repeat(reverse: true),
          )
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.02, 1.02),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }

    return card;
  }

  Widget _buildNextEvolutionCard(
    EvolutionStageModel nextStage,
    int mascotLevel,
    String locale,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final stageName = switch (locale) {
      'ja' => nextStage.nameJa,
      'es' when nextStage.nameEs.isNotEmpty => nextStage.nameEs,
      _ => nextStage.nameEn,
    };
    final levelsNeeded = nextStage.level - mascotLevel;
    final progress = mascotLevel / nextStage.level;

    return Container(
      padding: const EdgeInsets.all(spacingXl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(
              alpha: opacityHalf,
            ),
            colorScheme.secondaryContainer.withValues(
              alpha: opacityHalf,
            ),
          ],
        ),
        borderRadius: borderRadiusLg,
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(spacingSm),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: borderRadiusMd,
            ),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
                0,
                0,
                0,
                0,
                0.6,
                0,
              ]),
              child: MascotImage(
                assetPath: nextStage.assetPath,
              ),
            ),
          ),
          const SizedBox(width: spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stageName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: spacingXs),
                Text(
                  l10n.mascotLevelsToGo(levelsNeeded),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: spacingSm),
                ClipRRect(
                  borderRadius: borderRadiusXs,
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: spacingXs),
                Text(
                  l10n.mascotLevelProgress(
                    mascotLevel,
                    nextStage.level,
                  ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaxEvolutionCard(ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final hasEgg = ref.watch(hasEggProvider);

    return Container(
      padding: const EdgeInsets.all(spacingXxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold,
            AppColors.celebrationOrange,
          ],
        ),
        borderRadius: borderRadiusLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(
              alpha: opacityMuted,
            ),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(spacingMd),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: opacityLight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.maxEvolutionTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: spacingXs),
                Text(
                  hasEgg ? l10n.maxEvolutionEggHint : l10n.maxEvolutionSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(
          onPlay: (c) => c.repeat(reverse: true),
        )
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(
            alpha: opacityMuted,
          ),
        );
  }
}
