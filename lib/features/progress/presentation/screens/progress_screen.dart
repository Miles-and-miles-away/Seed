import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/presentation/screens/eco_dex_screen.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
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

/// Segments for the progress screen tab bar.
enum _ProgressSegment { calendar, ecoDex }

class _ProgressContent extends ConsumerStatefulWidget {
  const _ProgressContent();

  @override
  ConsumerState<_ProgressContent> createState() => _ProgressContentState();
}

class _ProgressContentState extends ConsumerState<_ProgressContent> {
  _ProgressSegment _segment = _ProgressSegment.calendar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.progressTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Segmented control
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.sm,
            ),
            child: SegmentedButton<_ProgressSegment>(
              segments: [
                ButtonSegment(
                  value: _ProgressSegment.calendar,
                  label: Text(l10n.progressCalendarTab),
                  icon: const Icon(Icons.calendar_month, size: 18),
                ),
                ButtonSegment(
                  value: _ProgressSegment.ecoDex,
                  label: Text(l10n.ecoDexTab),
                  icon: const Icon(Icons.auto_stories, size: 18),
                ),
              ],
              selected: {_segment},
              onSelectionChanged: (selected) {
                setState(() => _segment = selected.first);
              },
              style: SegmentedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),

          // Content
          Expanded(
            child: _segment == _ProgressSegment.calendar
                ? _CalendarView(theme: theme, l10n: l10n)
                : const EcoDexScreen(),
          ),
        ],
      ),
    );
  }
}

class _CalendarView extends ConsumerWidget {
  const _CalendarView({
    required this.theme,
    required this.l10n,
  });

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaySummaryAsync = ref.watch(todaySummaryProvider);
    final goalTarget = ref.watch(dailyGoalTargetProvider) ?? 3;
    final sdgColors = ref
        .watch(sdgGoalsDataProvider)
        .value
        ?.goals
        .map((g) => g.color)
        .toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Rainbow Sun section
          SizedBox(
            height: 280,
            child: todaySummaryAsync.when(
              data: (summary) {
                final goalCount = summary?.goalCount ?? 0;
                final completedSdgs = summary?.completedSdgs ?? [];

                if (goalCount == 0 || sdgColors == null) {
                  return const EmptyRainbowSun();
                }

                return RainbowSunWidget(
                  goalCount: goalCount,
                  goalTarget: goalTarget,
                  completedSdgs: completedSdgs,
                  sdgColors: sdgColors,
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
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.xxl,
            ),
            child: todaySummaryAsync.when(
              data: (summary) {
                final goalCount = summary?.goalCount ?? 0;
                return _buildTodayStats(
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

          const SizedBox(height: Spacing.xxl),

          // Calendar section
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
            ),
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: Radii.borderLg,
            ),
            child: const ProgressCalendar(),
          ),

          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }

  Widget _buildTodayStats(
    ThemeData theme,
    AppLocalizations l10n,
    int goalCount,
    int goalTarget,
  ) {
    final colorScheme = theme.colorScheme;
    final isGoalMet = goalCount >= goalTarget;

    return Column(
      children: [
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
        const SizedBox(height: Spacing.sm),
        if (isGoalMet)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.lg,
              vertical: Spacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: Radii.borderXl,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.celebration,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: Spacing.sm),
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
