import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/sdg_data.dart';
import '../../data/sdg_targets.dart';

/// Expandable section showing an SDG's description
/// and its UN targets.
class SdgTargetsSection extends StatefulWidget {
  const SdgTargetsSection({
    required this.goal,
    super.key,
  });

  final SdgGoal goal;

  @override
  State<SdgTargetsSection> createState() =>
      _SdgTargetsSectionState();
}

class _SdgTargetsSectionState
    extends State<SdgTargetsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final goal = widget.goal;

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
          GestureDetector(
            onTap: () => setState(
              () => _expanded = !_expanded,
            ),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: goal.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.sdgAboutGoal,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(
                    milliseconds: 200,
                  ),
                  child: Icon(
                    Icons.expand_more,
                    color: theme
                        .colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
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
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildTargets(
              theme,
              l10n,
              goal,
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(
              milliseconds: 300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargets(
    ThemeData theme,
    AppLocalizations l10n,
    SdgGoal goal,
  ) {
    final targets = sdgTargets[goal.number] ?? [];
    if (targets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Text(
          l10n.sdgTargetsTitle,
          style:
              theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...targets.map(
          (t) => _TargetRow(
            target: t,
            goalColor: goal.color,
          ),
        ),
      ],
    );
  }
}

class _TargetRow extends StatelessWidget {
  const _TargetRow({
    required this.target,
    required this.goalColor,
  });

  final SdgTarget target;
  final Color goalColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color:
                  goalColor.withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(6),
            ),
            child: Text(
              target.code,
              style: TextStyle(
                color: goalColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              target.description,
              style: theme.textTheme.bodySmall
                  ?.copyWith(
                height: 1.5,
                color: theme
                    .colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
