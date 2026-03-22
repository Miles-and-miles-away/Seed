import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import '../providers/progress_providers.dart';

/// First-time setup screen for selecting daily goal target.
///
/// Uses a ListWheelScrollView for picking a target between 1-10 goals.
class DailyTargetPicker extends ConsumerStatefulWidget {
  const DailyTargetPicker({
    required this.onComplete,
    super.key,
  });

  /// Called when the user has selected and confirmed their target.
  final VoidCallback onComplete;

  @override
  ConsumerState<DailyTargetPicker> createState() => _DailyTargetPickerState();
}

class _DailyTargetPickerState extends ConsumerState<DailyTargetPicker> {
  int _selectedTarget = 3; // Default recommendation
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Start with default selected (index 2 for value 3)
    _scrollController = FixedExtentScrollController(initialItem: 2);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getDescriptionForTarget(int target, AppLocalizations l10n) {
    return switch (target) {
      1 || 2 => l10n.progressTargetDescriptionEasy,
      3 || 4 => l10n.progressTargetDescriptionModerate,
      5 || 6 => l10n.progressTargetDescriptionChallenge,
      _ => l10n.progressTargetDescriptionExpert,
    };
  }

  Future<void> _saveTarget() async {
    await ref.read(dailyTargetProvider.notifier).saveTarget(_selectedTarget);

    final state = ref.read(dailyTargetProvider);
    if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).errorGeneric),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else if (!state.hasError) {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final notifierState = ref.watch(dailyTargetProvider);

    return Padding(
      padding: const EdgeInsets.all(Spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          // Title
          Text(
            l10n.progressSetDailyGoal,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            l10n.progressSetDailyGoalSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.huge),

          // Number picker
          SizedBox(
            height: 180,
            child: ListWheelScrollView.useDelegate(
              controller: _scrollController,
              itemExtent: 60,
              physics: const FixedExtentScrollPhysics(),
              diameterRatio: 1.5,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedTarget = index + 1;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 10,
                builder: (context, index) {
                  final value = index + 1;
                  final isSelected = value == _selectedTarget;

                  return Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Durations.fast,
                      style: theme.textTheme.headlineLarge!.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(
                                alpha: Opacities.medium,
                              ),
                      ),
                      child: Text('$value'),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // Dynamic description
          AnimatedSwitcher(
            duration: Durations.fast,
            child: Text(
              _getDescriptionForTarget(_selectedTarget, l10n),
              key: ValueKey(_selectedTarget),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),

          // Confirm button
          FilledButton(
            onPressed: notifierState.isLoading ? null : _saveTarget,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: Spacing.lg,
              ),
            ),
            child: notifierState.isLoading
                ? const SizedBox(
                    width: Spacing.xxl,
                    height: Spacing.xxl,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.progressStartJourney),
          ),
          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }
}
