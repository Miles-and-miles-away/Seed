import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../providers/progress_providers.dart';
import '../widgets/daily_target_picker.dart';
import '../widgets/progress_calendar.dart';
import '../widgets/rainbow_sun_widget.dart';

/// Main progress screen showing the Rainbow Sun and calendar view.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final needsSetup = ref.watch(needsDailyTargetSetupProvider);

    // Show daily target picker for first-time users
    if (needsSetup) {
      return Scaffold(
        body: SafeArea(
          child: DailyTargetPicker(
            onComplete: () {
              // The provider will automatically update when Firestore changes
            },
          ),
        ),
      );
    }

    return const _ProgressContent();
  }
}

class _ProgressContent extends ConsumerWidget {
  const _ProgressContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final todaySummaryAsync = ref.watch(todaySummaryProvider);
    final goalTarget = ref.watch(dailyGoalTargetProvider) ?? 3;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Rainbow Sun section
            SizedBox(
              height: 280,
              child: todaySummaryAsync.when(
                data: (summary) {
                  final goalCount = summary?.goalCount ?? 0;
                  final completedSdgs = summary?.completedSdgs ?? [];

                  if (goalCount == 0) {
                    return const EmptyRainbowSun();
                  }

                  return RainbowSunWidget(
                    goalCount: goalCount,
                    goalTarget: goalTarget,
                    completedSdgs: completedSdgs,
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),

            // Today's stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: todaySummaryAsync.when(
                data: (summary) {
                  final goalCount = summary?.goalCount ?? 0;
                  return _buildTodayStats(
                    context,
                    theme,
                    l10n,
                    goalCount,
                    goalTarget,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            const SizedBox(height: 24),

            // Calendar section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const ProgressCalendar(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    int goalCount,
    int goalTarget,
  ) {
    final colorScheme = theme.colorScheme;
    final isGoalMet = goalCount >= goalTarget;

    return Column(
      children: [
        // Goal progress text
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: theme.textTheme.headlineSmall,
            children: [
              TextSpan(
                text: '$goalCount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      isGoalMet ? colorScheme.primary : colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: ' / $goalTarget ',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: l10n.progressGoalsToday,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Achievement message
        if (isGoalMet)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.celebration,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.progressGoalReached,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
