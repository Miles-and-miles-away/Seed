import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/mascot_species_data.dart';
import '../../data/models/evolution_stage_model.dart';
import '../../data/models/mascot_model.dart';
import '../../data/models/mascot_species_model.dart';
import '../providers/mascot_providers.dart';
import '../widgets/egg_progress_widget.dart';
import '../widgets/mascot_display.dart';

/// The main mascot screen with evolution timeline and
/// multi-mascot collection.
class MascotScreen extends ConsumerStatefulWidget {
  const MascotScreen({super.key});

  @override
  ConsumerState<MascotScreen> createState() =>
      _MascotScreenState();
}

class _MascotScreenState extends ConsumerState<MascotScreen> {
  bool _isRenaming = false;
  final _renameController = TextEditingController();

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
    final locale =
        Localizations.localeOf(context).languageCode;

    final mascot =
        ref.watch(activeMascotProvider).value;
    final species = ref.watch(activeSpeciesProvider);
    final currentStage =
        ref.watch(activeMascotStageProvider);
    final stageName =
        ref.watch(stageLocalizedNameProvider(locale));
    final nextStageData =
        ref.watch(activeNextStageDataProvider);
    final allMascots =
        ref.watch(allMascotsProvider).value ?? [];
    final hasEgg = ref.watch(hasEggProvider);

    if (mascot == null || species == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
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
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot display
                  Center(
                    child: Column(
                      children: [
                        const MascotDisplay(size: 220),
                        const SizedBox(height: 16),
                        _buildNameSection(
                          mascot.name,
                          colorScheme,
                        ),
                        const SizedBox(height: 8),
                        _buildStageBadge(
                          stageName ??
                              'Stage $currentStage',
                          mascot.mascotLevel,
                          colorScheme,
                          l10n,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

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
                    'Evolution Timeline',
                    style:
                        theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEvolutionTimeline(
                    species.evolutionStages,
                    currentStage,
                    mascot.mascotLevel,
                    locale,
                  ),

                  const SizedBox(height: 32),

                  // Next Evolution / Max Evolution
                  if (nextStageData != null) ...[
                    Text(
                      'Next Evolution',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
      const SizedBox(height: 12),
      SizedBox(
        height: 110,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: mascots.length + (hasEgg ? 1 : 0),
          separatorBuilder: (_, __) =>
              const SizedBox(width: 12),
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
      const SizedBox(height: 32),
    ];
  }

  Widget _buildMascotThumbnail(
    MascotModel mascot,
    bool isActive,
    String locale,
    ColorScheme colorScheme,
  ) {
    final species =
        _getSpeciesForMascot(mascot.speciesId);
    if (species == null) return const SizedBox.shrink();

    final stage =
        species.getStageForLevel(mascot.mascotLevel);

    return GestureDetector(
      onTap: isActive
          ? null
          : () => _showSwitchConfirmation(mascot),
      child: Container(
        width: 80,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
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
            SvgPicture.asset(
              stage.assetPath,
              width: 44,
              height: 44,
            ),
            const SizedBox(height: 4),
            Text(
              mascot.name.isEmpty
                  ? species.getName(locale)
                  : mascot.name,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    fontWeight:
                        isActive ? FontWeight.bold : null,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(
              'Lv ${mascot.mascotLevel}',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
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
    return getSpeciesById(id);
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
              ref
                  .read(mascotProvider.notifier)
                  .switchActiveMascot(target.id);
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
            child: TextField(
              controller: _renameController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
        const SizedBox(width: 8),
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
    final mascot =
        ref.read(activeMascotProvider).value;
    _renameController.text = mascot?.name ?? '';
    setState(() => _isRenaming = true);
  }

  void _cancelRename() {
    setState(() => _isRenaming = false);
  }

  Future<void> _submitRename() async {
    final newName = _renameController.text.trim();
    if (newName.isEmpty ||
        newName.length < 2 ||
        newName.length > 20) {
      return;
    }

    await ref
        .read(mascotProvider.notifier)
        .renameMascot(newName);
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
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
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
            style:
                Theme.of(context).textTheme.labelLarge?.copyWith(
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
        children:
            List.generate(stages.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stageIndex = index ~/ 2;
            final isUnlocked =
                currentStage > stageIndex + 1;
            return Expanded(
              child: Container(
                height: 4,
                margin:
                    const EdgeInsets.symmetric(horizontal: 4),
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
          final isCurrentStage =
              currentStage == stageIndex + 1;
          final isUnlocked = currentStage >= stageIndex + 1;
          final stageName =
              locale == 'ja' ? stage.nameJa : stage.nameEn;

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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentStage
            ? colorScheme.primaryContainer
            : isUnlocked
                ? colorScheme.surfaceContainerLow
                : colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
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
                ? SvgPicture.asset(stage.assetPath)
                : ColorFiltered(
                    colorFilter:
                        const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 0.4, 0,
                    ]),
                    child:
                        SvgPicture.asset(stage.assetPath),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            stageName,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: isUnlocked
                      ? colorScheme.onSurface
                      : colorScheme.onSurface
                          .withValues(alpha: 0.5),
                  fontWeight:
                      isCurrentStage ? FontWeight.bold : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Lv ${stage.level}',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.onSurface
                          .withValues(alpha: 0.4),
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
    final stageName =
        locale == 'ja' ? nextStage.nameJa : nextStage.nameEn;
    final levelsNeeded = nextStage.level - mascotLevel;
    final progress = mascotLevel / nextStage.level;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer
                .withValues(alpha: 0.5),
            colorScheme.secondaryContainer
                .withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ColorFiltered(
              colorFilter:
                  const ColorFilter.matrix(<double>[
                1, 0, 0, 0, 0,
                0, 1, 0, 0, 0,
                0, 0, 1, 0, 0,
                0, 0, 0, 0.6, 0,
              ]),
              child: SvgPicture.asset(
                nextStage.assetPath,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stageName,
                  style:
                      theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$levelsNeeded levels to go',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor:
                        colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level $mascotLevel / ${nextStage.level}',
                  style:
                      theme.textTheme.labelSmall?.copyWith(
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD700),
            Color(0xFFFFA500),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.maxEvolutionTitle,
                  style:
                      theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasEgg
                      ? l10n.maxEvolutionEggHint
                      : l10n.maxEvolutionSubtitle,
                  style:
                      theme.textTheme.bodyMedium?.copyWith(
                    color:
                        Colors.white.withValues(alpha: 0.9),
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
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}
