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
import '../widgets/sdg_filter_chips.dart';

/// Screen for browsing and logging eco-friendly actions.
class ActionLogScreen extends ConsumerStatefulWidget {
  const ActionLogScreen({super.key, this.initialCategory});

  /// Category name to pre-select on open (e.g. from the daily challenge
  /// card). Null or unrecognized values show all categories.
  final String? initialCategory;

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
    final initialCategory = ActionCategory.fromString(
      widget.initialCategory,
    );
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
    _debounceTimer = Timer(
      durationNormal,
      () {
        ref
            .read(actionSearchQueryProvider.notifier)
            .setQuery(_searchController.text);
      },
    );
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              spacingLg,
              0,
              spacingLg,
              spacingSm,
            ),
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
                                .read(
                                  actionSearchQueryProvider.notifier,
                                )
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
          // Sort dropdown row
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacingLg,
              vertical: spacingSm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const ActionSortDropdown(),
              ],
            ),
          ),
          // SDG filter chips
          const SdgFilterChips(),
          const SizedBox(height: spacingSm),
          // Actions grid
          Expanded(
            child: filteredActionsAsync.when(
              data: (actions) => _buildActionsGrid(
                actions,
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
                    const SizedBox(height: spacingLg),
                    Text(
                      l10n.errorGeneric,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: spacingSm),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(
                        actionLibraryProvider,
                      ),
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

    return GridView.builder(
      padding: const EdgeInsets.all(spacingLg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: spacingMd,
        mainAxisSpacing: spacingMd,
        childAspectRatio: 0.9,
      ),
      itemCount: filteredActions.length,
      itemBuilder: (context, index) {
        final action = filteredActions[index];
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
}
