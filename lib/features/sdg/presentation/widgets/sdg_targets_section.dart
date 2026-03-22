import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';

/// Expandable section showing an SDG's description
/// and its UN targets.
class SdgTargetsSection extends ConsumerStatefulWidget {
  const SdgTargetsSection({
    required this.goal,
    required this.locale,
    super.key,
  });

  final SdgGoal goal;
  final String locale;

  @override
  ConsumerState<SdgTargetsSection> createState() => _SdgTargetsSectionState();
}

class _SdgTargetsSectionState extends ConsumerState<SdgTargetsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final goal = widget.goal;

    return Container(
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: Radii.borderLg,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: Opacities.half,
          ),
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
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Text(
                    l10n.sdgAboutGoal,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: Durations.normal,
                  child: Icon(
                    Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),
          Text(
            goal.description(widget.locale),
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurfaceVariant,
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
            duration: Durations.normal,
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
    final allTargets = ref.watch(sdgTargetsDataProvider).value ?? {};
    final targets = allTargets[goal.number] ?? [];
    if (targets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.xl),
        const Divider(height: 1),
        const SizedBox(height: Spacing.lg),
        Text(
          l10n.sdgTargetsTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: Spacing.md),
        ...targets.map(
          (t) => _TargetRow(
            target: t,
            goalColor: goal.color,
            locale: widget.locale,
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
    required this.locale,
  });

  final SdgTarget target;
  final Color goalColor;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: goalColor.withValues(
                alpha: Opacities.subtle,
              ),
              borderRadius: BorderRadius.circular(6),
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
              target.description(locale),
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
