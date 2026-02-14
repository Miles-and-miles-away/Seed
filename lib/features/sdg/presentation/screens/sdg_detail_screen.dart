import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../shared/services/analytics_service.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/sdg_data.dart';
import '../widgets/sdg_actions_grid.dart';
import '../widgets/sdg_impact_card.dart';
import '../widgets/sdg_resources_list.dart';

/// Detail screen showing information about a specific SDG.
class SdgDetailScreen extends ConsumerStatefulWidget {
  const SdgDetailScreen({
    required this.goalNumber,
    super.key,
  });

  final int goalNumber;

  @override
  ConsumerState<SdgDetailScreen> createState() =>
      _SdgDetailScreenState();
}

class _SdgDetailScreenState
    extends ConsumerState<SdgDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logSdgViewed(
      sdgNumber: widget.goalNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final goal = sdgGoals.firstWhere(
      (g) => g.number == widget.goalNumber,
      orElse: () => sdgGoals.first,
    );
    final currentUser =
        ref.watch(currentUserProvider).asData?.value;
    final languageCode = currentUser?.language ?? 'en';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, goal),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildGoalBadge(context, goal),
                const SizedBox(height: 16),
                Text(
                  goal.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildDescriptionSection(context, goal),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
                _buildLearnMoreButton(context, goal),
                const SizedBox(height: 48),
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
      const SizedBox(height: 24),
      SdgActionsGrid(
        goalNumber: goal.number,
        goalColor: goal.color,
        languageCode: languageCode,
      ),
      const SizedBox(height: 24),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: goal.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: goal.color.withValues(alpha: 0.2),
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
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.sdgLearnOnlyExplanation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color:
                      theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
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
                goal.color.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Center(
            child: Hero(
              tag: 'sdg_icon_${goal.number}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: goal.iconUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(
                    width: 120,
                    height: 120,
                    color: Colors.white
                        .withValues(alpha: 0.2),
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
                  errorWidget: (context, url, error) =>
                      Container(
                    width: 120,
                    height: 120,
                    color: Colors.white
                        .withValues(alpha: 0.2),
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
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: goal.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Goal ${goal.number}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'UN SDG',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(
    BuildContext context,
    SdgGoal goal,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: goal.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'About this Goal',
                style:
                    theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            goal.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMoreButton(
    BuildContext context,
    SdgGoal goal,
  ) {
    return FilledButton.icon(
      onPressed: () => _launchUnSdgPage(goal.number),
      style: FilledButton.styleFrom(
        backgroundColor: goal.color,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
      icon: const Icon(Icons.open_in_new),
      label: const Text('Learn More at UN.org'),
    );
  }

  Future<void> _launchUnSdgPage(int goalNumber) async {
    final url = Uri.parse('https://sdgs.un.org/goals');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
