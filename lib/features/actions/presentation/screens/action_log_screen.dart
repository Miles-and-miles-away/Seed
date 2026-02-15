import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../data/models/action_model.dart';
import '../providers/actions_providers.dart';
import '../utils/handle_action_tap.dart';
import '../widgets/action_card.dart';
import '../widgets/action_category_tabs.dart';
import '../widgets/action_sort_dropdown.dart';
import '../widgets/sdg_filter_chips.dart';

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
    final filteredActionsAsync = ref.watch(filteredActionsProvider);
    final languageCode = ref.watch(userLanguageCodeProvider);

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
          // Sort dropdown row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const ActionSortDropdown(),
              ],
            ),
          ),
          // SDG filter chips
          const SdgFilterChips(),
          const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
                    Text(
                      l10n.errorGeneric,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
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
