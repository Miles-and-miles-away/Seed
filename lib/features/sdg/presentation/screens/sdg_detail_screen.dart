import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/services/analytics_service.dart';
import '../../data/sdg_data.dart';

/// Detail screen showing information about a specific SDG
class SdgDetailScreen extends StatefulWidget {
  const SdgDetailScreen({
    required this.goalNumber,
    super.key,
  });

  final int goalNumber;

  @override
  State<SdgDetailScreen> createState() => _SdgDetailScreenState();
}

class _SdgDetailScreenState extends State<SdgDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Track SDG view event
    AnalyticsService.instance.logSdgViewed(sdgNumber: widget.goalNumber);
  }

  @override
  Widget build(BuildContext context) {
    // Find the goal by number
    final goal = sdgGoals.firstWhere(
      (g) => g.number == widget.goalNumber,
      orElse: () => sdgGoals.first,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Colored app bar with goal icon
          _buildAppBar(context, goal),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Goal number badge
                _buildGoalBadge(context, goal),
                const SizedBox(height: 16),

                // Goal title
                Text(
                  goal.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Description section
                _buildDescriptionSection(context, goal),
                const SizedBox(height: 32),

                // Learn more button
                _buildLearnMoreButton(context, goal),
                const SizedBox(height: 24),

                // Related actions hint
                _buildRelatedActionsHint(context, goal),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
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
                  placeholder: (context, url) => Container(
                    width: 120,
                    height: 120,
                    color: Colors.white.withValues(alpha: 0.2),
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
                    color: Colors.white.withValues(alpha: 0.2),
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

  Widget _buildGoalBadge(BuildContext context, SdgGoal goal) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
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

  Widget _buildDescriptionSection(BuildContext context, SdgGoal goal) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
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
                style: theme.textTheme.titleMedium?.copyWith(
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
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnMoreButton(BuildContext context, SdgGoal goal) {
    return FilledButton.icon(
      onPressed: () => _launchUnSdgPage(goal.number),
      style: FilledButton.styleFrom(
        backgroundColor: goal.color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      icon: const Icon(Icons.open_in_new),
      label: const Text('Learn More at UN.org'),
    );
  }

  Widget _buildRelatedActionsHint(BuildContext context, SdgGoal goal) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            goal.color.withValues(alpha: 0.1),
            goal.color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: goal.color.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: goal.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.eco,
              color: goal.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take Action!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log eco-friendly actions that support this goal and watch your mascot grow!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUnSdgPage(int goalNumber) async {
    final url = Uri.parse('https://sdgs.un.org/goals');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
