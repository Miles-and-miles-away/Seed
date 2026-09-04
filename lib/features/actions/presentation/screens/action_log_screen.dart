import 'dart:async';

import 'package:flutter/material.dart' hide Durations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/app/app_bottom_nav.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import '../providers/actions_providers.dart';
import '../utils/handle_action_tap.dart';
import '../widgets/action_card.dart';
import '../widgets/action_category_tabs.dart';
import '../widgets/action_sort_dropdown.dart';
import '../widgets/calculator_chooser_sheet.dart';
import '../widgets/sdg_filter_chips.dart';

/// Screen for browsing and logging eco-friendly actions.
class ActionLogScreen extends ConsumerStatefulWidget {
  const ActionLogScreen({super.key, this.initialCategory});

  /// Category name to pre-select on open (e.g. from the daily challenge
  /// card). Null or unrecognized values show all categories.
  final String? initialCategory;

  /// Accent bar, padding, icon and gaps: the part of a tile that does
  /// not move with the text scale.
  ///
  /// Split measured off the rendered grid: the tallest tile draws about
  /// 180pt at scale 1.0 and 261pt at scale 2.0, and the constants carry
  /// a few points of slack over both. A test pins that nothing
  /// overflows at either.
  static const _tileChromeHeight = 104.0;

  /// Title, badge and SDG row at the default text scale.
  static const _tileTextHeight = 82.0;

  /// Height of one action tile at [scaler]. Public so a test can put a
  /// tile in exactly the box the grid gives it.
  static double tileHeightFor(TextScaler scaler) =>
      _tileChromeHeight + scaler.scale(_tileTextHeight);

  @override
  ConsumerState<ActionLogScreen> createState() => _ActionLogScreenState();
}

class _ActionLogScreenState extends ConsumerState<ActionLogScreen> {
  final _searchController = TextEditingController();
  final _showClear = ValueNotifier(false);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    final initialCategory = ActionCategory.fromString(widget.initialCategory);
    if (initialCategory != null) {
      // Provider mutations are disallowed during initState, so apply the
      // incoming filter on the first frame (during the route transition).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(selectedCategoryProvider.notifier).select(initialCategory);
        }
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    _showClear.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _showClear.value = _searchController.text.isNotEmpty;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(durationNormal, () {
      ref
          .read(actionSearchQueryProvider.notifier)
          .setQuery(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final filteredActionsAsync = ref.watch(filteredActionsProvider);
    final languageCode = ref.watch(userLanguageCodeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.actionLogTitle),
        // Action log is a primary destination reached via the bottom-nav
        // Action button; navigation is via the tabs, so suppress the
        // implicit back arrow to avoid a redundant second exit.
        automaticallyImplyLeading: false,
        actions: [
          // Carbon calculators hub (Phase 8): opens the transport / food
          // / home-energy chooser without spending a bottom-nav slot.
          IconButton(
            icon: const Icon(Icons.calculate_outlined),
            tooltip: l10n.calculatorsButtonTooltip,
            onPressed: () => CalculatorChooserSheet.show(context),
          ),
          // The two energy teaching surfaces (decision E8). They sit
          // here rather than in the chooser sheet, whose three-tile row
          // would overflow, and rather than as category tiles, because
          // neither is an action to log.
          IconButton(
            // The app's own energy glyph rather than a generic chart:
            // both of these icons are energy-only surfaces.
            icon: const Icon(Icons.bolt),
            tooltip: l10n.energyRankedTitle,
            onPressed: () => context.push(appRoutes.energyExplore),
          ),
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            // Domain-neutral: the game rotates between energy, food and
            // transport rounds.
            tooltip: l10n.quizTitle,
            onPressed: () => context.push(appRoutes.quiz),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              0,
              spacingLg,
              spacingSm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _showClear,
                    builder: (context, show, _) => TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.actionSearchHint,
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: show
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _debounceTimer?.cancel();
                                  ref
                                      .read(actionSearchQueryProvider.notifier)
                                      .clear();
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
                          horizontal: spacingLg,
                          vertical: spacingMd,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: spacingSm),
                const ActionSortDropdown(),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category tabs
          const SizedBox(height: spacingSm),
          ActionCategoryTabs(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              ref.read(selectedCategoryProvider.notifier).select(category);
            },
          ),
          const SizedBox(height: spacingSm),
          // SDG filter chips
          const SdgFilterChips(),
          const SizedBox(height: spacingSm),
          // Actions grid
          Expanded(
            child: filteredActionsAsync.when(
              data: (actions) => _buildActionsGrid(actions, languageCode),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: spacingLg),
                    Text(l10n.errorGeneric, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: spacingSm),
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
      bottomNavigationBar: AppBottomNav(
        // No shell tab is active while the Action log is open; the centre
        // Action button highlights to mark the current screen instead.
        currentIndex: null,
        isActionSelected: true,
        onTabSelected: _goToTab,
        onActionPressed: () {},
      ),
    );
  }

  /// Switches to a main shell tab, replacing the pushed Action log so the
  /// chosen area opens with its own bottom navigation intact.
  void _goToTab(int index) {
    final route = switch (index) {
      0 => appRoutes.home,
      1 => appRoutes.progress,
      2 => appRoutes.mascot,
      _ => appRoutes.profile,
    };
    context.go(route);
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
            const SizedBox(height: spacingLg),
            Text(
              l10n.noActionsFound,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    final entry = _buildCalculatorEntry(l10n);
    return GridView.builder(
      padding: const EdgeInsets.all(spacingLg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingMd,
        mainAxisSpacing: spacingMd,
        // Height from the content, not from a fraction of the cell
        // width: at 0.9 the cell ran ~20pt taller than the tallest tile
        // draws, which read as dead space above and below. Only the
        // text block grows with the user's text scale, so only that
        // part is scaled.
        mainAxisExtent: ActionLogScreen.tileHeightFor(
          MediaQuery.textScalerOf(context),
        ),
      ),
      itemCount: filteredActions.length + (entry == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (entry != null && index == 0) return entry;
        final action = filteredActions[entry == null ? index : index - 1];
        return ActionCard(
          action: action,
          languageCode: languageCode,
          onTap: () => handleActionTap(
            context,
            ref,
            action: action,
            languageCode: languageCode,
          ),
        );
      },
    );
  }

  /// Custom-action entry for the transport (Phase 8.6) and food (Phase
  /// 8.12) calculators, shown as the first tile of their own category so
  /// it reads as just another action rather than a banner. Both bank the
  /// choice they produce, hence the custom-action badge.
  ///
  /// Energy has no tile here: its calculator banks nothing (decision
  /// 8.18), and a tile in a grid of loggable actions promises a log it
  /// cannot deliver. It stays in the AppBar calculator chooser, beside
  /// the two energy teaching surfaces (decision E8).
  Widget? _buildCalculatorEntry(AppLocalizations l10n) {
    final category = ref.watch(selectedCategoryProvider);
    final (String title, String route) = switch (category) {
      ActionCategory.transport => (
        l10n.transportActionsEntryTitle,
        appRoutes.transportCalculator,
      ),
      ActionCategory.food => (
        l10n.foodActionsEntryTitle,
        appRoutes.foodCalculator,
      ),
      _ => ('', ''),
    };
    if (title.isEmpty) return null;

    return ActionTile(
      accentColor: category!.color,
      contentColor: category.color,
      icon: Icons.compare_arrows,
      title: title,
      badgeLabel: l10n.customActionBadge,
      onTap: () => context.push(route),
    );
  }
}
