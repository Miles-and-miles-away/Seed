import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/models/evolution_stage_model.dart';
import '../providers/mascot_providers.dart';
import '../widgets/mascot_display.dart';

/// The main mascot screen accessible from the bottom navigation.
///
/// Shows the mascot with evolution timeline, stats, and rename functionality.
class MascotScreen extends ConsumerStatefulWidget {
  const MascotScreen({super.key});

  @override
  ConsumerState<MascotScreen> createState() => _MascotScreenState();
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
    final locale = Localizations.localeOf(context).languageCode;

    final mascot = ref.watch(currentMascotProvider).value;
    final species = ref.watch(currentSpeciesProvider);
    final currentStage = ref.watch(currentMascotStageProvider);
    final user = ref.watch(currentUserProvider).value;
    final stageName = ref.watch(stageLocalizedNameProvider(locale));
    final nextStageData = ref.watch(nextStageDataProvider);

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
            // App bar
            SliverAppBar(
              floating: true,
              title: Text(l10n.navMascot),
              centerTitle: true,
            ),

            // Main content
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Mascot display with glow
                  Center(
                    child: Column(
                      children: [
                        const MascotDisplay(
                          size: 220,
                        ),
                        const SizedBox(height: 16),

                        // Mascot name with edit button
                        _buildNameSection(mascot.name, colorScheme),

                        const SizedBox(height: 8),

                        // Evolution stage badge
                        _buildStageBadge(
                          stageName ?? 'Stage $currentStage',
                          user?.level ?? 1,
                          colorScheme,
                          l10n,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Evolution Timeline
                  Text(
                    'Evolution Timeline',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEvolutionTimeline(
                    species.evolutionStages,
                    currentStage,
                    user?.level ?? 1,
                    locale,
                  ),

                  const SizedBox(height: 32),

                  // Next Evolution Progress
                  if (nextStageData != null) ...[
                    Text(
                      'Next Evolution',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildNextEvolutionCard(
                      nextStageData,
                      user?.level ?? 1,
                      locale,
                      colorScheme,
                    ),
                  ] else ...[
                    // Max evolution reached
                    _buildMaxEvolutionCard(colorScheme),
                  ],

                  const SizedBox(height: 100), // Bottom padding for nav bar
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameSection(String name, ColorScheme colorScheme) {
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
            icon: Icon(Icons.check, color: colorScheme.primary),
          ),
          IconButton(
            onPressed: _cancelRename,
            icon: Icon(Icons.close, color: colorScheme.error),
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
    final mascot = ref.read(currentMascotProvider).value;
    _renameController.text = mascot?.name ?? '';
    setState(() => _isRenaming = true);
  }

  void _cancelRename() {
    setState(() => _isRenaming = false);
  }

  Future<void> _submitRename() async {
    final newName = _renameController.text.trim();
    if (newName.isEmpty || newName.length < 2 || newName.length > 20) {
      return;
    }

    await ref.read(mascotProvider.notifier).renameMascot(newName);
    if (mounted) {
      setState(() => _isRenaming = false);
    }
  }

  Widget _buildStageBadge(
    String stageName,
    int level,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            '$stageName • ${l10n.levelLabel(level)}',
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
    int userLevel,
    String locale,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 140,
      child: Row(
        children: List.generate(stages.length * 2 - 1, (index) {
          // Odd indices are connectors
          if (index.isOdd) {
            final stageIndex = index ~/ 2;
            final isUnlocked = currentStage > stageIndex + 1;
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }

          // Even indices are stage cards
          final stageIndex = index ~/ 2;
          final stage = stages[stageIndex];
          final isCurrentStage = currentStage == stageIndex + 1;
          final isUnlocked = currentStage >= stageIndex + 1;
          final stageName = locale == 'ja' ? stage.nameJa : stage.nameEn;

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
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: isCurrentStage
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: isUnlocked
                ? SvgPicture.asset(stage.assetPath)
                : ColorFiltered(
                    colorFilter: const ColorFilter.matrix(<double>[
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 0.4, 0,
                    ]),
                    child: SvgPicture.asset(stage.assetPath),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            stageName,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isUnlocked
                      ? colorScheme.onSurface
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: isCurrentStage ? FontWeight.bold : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Lv ${stage.level}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isUnlocked
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.4),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );

    if (isCurrentStage) {
      card = card
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
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
    int currentLevel,
    String locale,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final stageName = locale == 'ja' ? nextStage.nameJa : nextStage.nameEn;
    final levelsNeeded = nextStage.level - currentLevel;
    final progress = currentLevel / nextStage.level;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.5),
            colorScheme.secondaryContainer.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          // Next stage preview
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(<double>[
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

          // Progress info
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
                const SizedBox(height: 4),
                Text(
                  '$levelsNeeded levels to go',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Level $currentLevel / ${nextStage.level}',
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
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
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
                  'Maximum Evolution!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your companion has reached their full potential!',
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
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}
