import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/shared/services/analytics_service.dart';
import '../widgets/sdg_actions_grid.dart';
import '../widgets/sdg_impact_card.dart';
import '../widgets/sdg_infographic_viewer.dart';
import '../widgets/sdg_resources_list.dart';
import '../widgets/sdg_targets_section.dart';

/// Detail screen showing information about a specific SDG.
class SdgDetailScreen extends ConsumerStatefulWidget {
  const SdgDetailScreen({
    required this.goalNumber,
    super.key,
  });

  final int goalNumber;

  @override
  ConsumerState<SdgDetailScreen> createState() => _SdgDetailScreenState();
}

class _SdgDetailScreenState extends ConsumerState<SdgDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logSdgViewed(
      sdgNumber: widget.goalNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sdgData = ref.watch(sdgGoalsDataProvider).value;
    if (sdgData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final goal = sdgData.goalMap[widget.goalNumber] ?? sdgData.goals.first;
    final languageCode = ref.watch(
      currentUserProvider.select(
        (u) => u.value?.language ?? 'en',
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, goal),
          SliverPadding(
            padding: const EdgeInsets.all(Spacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildGoalBadge(context, goal),
                const SizedBox(height: Spacing.lg),
                Text(
                  goal.title(languageCode),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: Spacing.xxl),
                SdgTargetsSection(
                  goal: goal,
                  locale: languageCode,
                ),
                const SizedBox(height: Spacing.xxl),
                if (goal.isLearnOnly)
                  ..._buildLearnOnlyContent(
                    context,
                    goal,
                    languageCode,
                  )
                else
                  ..._buildDirectContent(
                    context,
                    goal,
                    languageCode,
                  ),
                const SizedBox(height: Spacing.xxl),
                SdgInfographicViewer(goal: goal),
                const SizedBox(height: Spacing.xxxl),
                _buildGoalNavigation(context, goal),
                const SizedBox(height: Spacing.huge),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  /// Content for SDGs with direct trackable actions.
  List<Widget> _buildDirectContent(
    BuildContext context,
    SdgGoal goal,
    String languageCode,
  ) {
    return [
      SdgImpactCard(
        goalNumber: goal.number,
        goalColor: goal.color,
      ),
      const SizedBox(height: Spacing.xxl),
      SdgActionsGrid(
        goalNumber: goal.number,
        goalColor: goal.color,
        languageCode: languageCode,
      ),
      const SizedBox(height: Spacing.xxl),
      SdgResourcesList(
        goalNumber: goal.number,
        goalColor: goal.color,
        languageCode: languageCode,
      ),
    ];
  }

  /// Content for learn-only SDGs.
  List<Widget> _buildLearnOnlyContent(
    BuildContext context,
    SdgGoal goal,
    String languageCode,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return [
      Container(
        padding: const EdgeInsets.all(Spacing.xl),
        decoration: BoxDecoration(
          color: goal.color.withValues(
            alpha: Opacities.veryFaint,
          ),
          borderRadius: Radii.borderLg,
          border: Border.all(
            color: goal.color.withValues(
              alpha: Opacities.light,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              color: goal.color,
              size: 24,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                l10n.sdgLearnOnlyExplanation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: Spacing.xxl),
      SdgResourcesList(
        goalNumber: goal.number,
        goalColor: goal.color,
        languageCode: languageCode,
        headerText: l10n.sdgWaysToContribute,
      ),
    ];
  }

  Widget _buildAppBar(BuildContext context, SdgGoal goal) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: goal.color,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                goal.color,
                goal.color.withValues(
                  alpha: Opacities.heavy,
                ),
              ],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'sdg_icon_${goal.number}',
              child: ClipRRect(
                borderRadius: Radii.borderLg,
                child: CachedNetworkImage(
                  imageUrl: goal.iconUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.white.withValues(
                      alpha: Opacities.light,
                    ),
                    child: Center(
                      child: Text(
                        '${goal.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.white.withValues(
                      alpha: Opacities.light,
                    ),
                    child: Center(
                      child: Text(
                        '${goal.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalBadge(
    BuildContext context,
    SdgGoal goal,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: goal.color,
            borderRadius: Radii.borderXl,
          ),
          child: Text(
            AppLocalizations.of(context).sdgGoalNumber(goal.number),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: Radii.borderXl,
          ),
          child: Text(
            AppLocalizations.of(context).sdgBadge,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalNavigation(
    BuildContext context,
    SdgGoal goal,
  ) {
    final prevNumber = goal.number == AppConstants.sdgMinGoal
        ? AppConstants.sdgMaxGoal
        : goal.number - 1;
    final nextNumber = goal.number == AppConstants.sdgMaxGoal
        ? AppConstants.sdgMinGoal
        : goal.number + 1;
    final sdgData = ref.watch(sdgGoalsDataProvider).value!;
    final prevGoal = sdgData.goalMap[prevNumber] ?? sdgData.goals.first;
    final nextGoal = sdgData.goalMap[nextNumber] ?? sdgData.goals.first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _GoalNavButton(
          goal: prevGoal,
          isPrevious: true,
          onTap: () => context.pushReplacement(
            '/home/sdg/${prevGoal.number}',
          ),
        ),
        _GoalNavButton(
          goal: nextGoal,
          isPrevious: false,
          onTap: () => context.pushReplacement(
            '/home/sdg/${nextGoal.number}',
          ),
        ),
      ],
    );
  }
}

class _GoalNavButton extends StatelessWidget {
  const _GoalNavButton({
    required this.goal,
    required this.isPrevious,
    required this.onTap,
  });

  final SdgGoal goal;
  final bool isPrevious;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: goal.color.withValues(
        alpha: Opacities.faint,
      ),
      borderRadius: Radii.borderMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: Radii.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: Spacing.md,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPrevious)
                Icon(
                  Icons.arrow_circle_left_rounded,
                  color: goal.color,
                  size: 22,
                ),
              if (isPrevious) const SizedBox(width: 6),
              Text(
                '${goal.number}',
                style: TextStyle(
                  color: goal.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (!isPrevious) const SizedBox(width: 6),
              if (!isPrevious)
                Icon(
                  Icons.arrow_circle_right_rounded,
                  color: goal.color,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
