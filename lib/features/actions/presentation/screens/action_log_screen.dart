import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../mascot/mascot.dart';
import '../../../settings/data/models/user_settings_model.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../settings/presentation/widgets/streak_milestone_dialog.dart';
import '../../data/models/action_model.dart';
import '../../domain/enums/action_category.dart';
import '../providers/actions_providers.dart';
import '../widgets/action_card.dart';
import '../widgets/action_category_tabs.dart';
import '../widgets/action_log_confirmation_dialog.dart';
import '../widgets/points_animation_overlay.dart';

/// Screen for browsing and logging eco-friendly actions.
class ActionLogScreen extends ConsumerStatefulWidget {
  const ActionLogScreen({super.key});

  @override
  ConsumerState<ActionLogScreen> createState() => _ActionLogScreenState();
}

class _ActionLogScreenState extends ConsumerState<ActionLogScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Listen to controller for clear button visibility
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Trigger rebuild for clear button visibility
    setState(() {});

    // Debounce the actual search query update
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(actionSearchQueryProvider.notifier).setQuery(
            _searchController.text,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredActions = ref.watch(filteredActionsProvider);
    final actionsAsync = ref.watch(actionLibraryProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.asData?.value;
    final languageCode = currentUser?.language ?? 'en';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.actionLogTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.actionSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // Immediately update query without debounce
                          _debounceTimer?.cancel();
                          ref.read(actionSearchQueryProvider.notifier).clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category tabs
          const SizedBox(height: 8),
          ActionCategoryTabs(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              ref.read(selectedCategoryProvider.notifier).select(category);
            },
          ),
          const SizedBox(height: 8),
          // Actions grid
          Expanded(
            child: actionsAsync.when(
              data: (_) => _buildActionsGrid(
                filteredActions,
                languageCode,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.errorGeneric,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(actionLibraryProvider),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.buttonRetry),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsGrid(
    List<ActionModel> filteredActions,
    String languageCode,
  ) {
    final l10n = AppLocalizations.of(context);

    if (filteredActions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noActionsFound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: filteredActions.length,
      itemBuilder: (context, index) {
        final action = filteredActions[index];
        return ActionCard(
          action: action,
          languageCode: languageCode,
          onTap: () => _handleActionTap(action, languageCode),
        );
      },
    );
  }

  Future<void> _handleActionTap(
    ActionModel action,
    String languageCode,
  ) async {
    // Show confirmation dialog
    final result = await ActionLogConfirmationDialog.show(
      context,
      action: action,
      languageCode: languageCode,
    );

    if (result == null || !result.confirmed) return;
    if (!mounted) return;

    // Log the action
    final logResult = await ref
        .read(actionLogProvider.notifier)
        .logAction(
          action,
          note: result.note,
          languageCode: languageCode,
        );

    if (!mounted) return;

    if (logResult != null) {
      // Get category color for animation
      final category = ActionCategory.fromString(action.category);
      final color = category?.color;

      // Show points animation
      PointsAnimationOverlay.show(
        context,
        points: action.points,
        color: color,
      );

      // Trigger mascot happy bounce animation
      ref.read(mascotAnimationTriggerProvider.notifier).triggerBounce();

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).actionLogged(action.points),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // Check if a streak milestone was crossed
      if (logResult.shouldShowMilestone && mounted) {
        // Check if this milestone has been seen before
        final settings = await ref.read(userSettingsProvider.future);
        final milestoneWeek = logResult.crossedMilestoneWeek!;
        final alreadySeen = settings.hasSeenMilestone(milestoneWeek);

        if (!alreadySeen && mounted) {
          // Show milestone celebration dialog
          await showStreakMilestoneCelebration(
            context,
            weekNumber: milestoneWeek,
            totalDays: logResult.newStreakDays,
          );
        }
      }
    } else {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).errorGeneric),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
