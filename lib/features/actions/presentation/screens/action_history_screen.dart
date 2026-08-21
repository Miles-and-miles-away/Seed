import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import '../providers/actions_providers.dart';
import '../widgets/action_log_item.dart';

/// Screen showing the history of logged actions.
class ActionHistoryScreen extends ConsumerWidget {
  const ActionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final actionLogsAsync = ref.watch(userActionLogsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.actionHistoryTitle)),
      body: actionLogsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: spacingLg),
                  Text(
                    l10n.homeNoActions,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group logs by date
          final groupedLogs = _groupByDate(logs);

          // A full page means more history may exist; a sentinel row
          // at the end of the lazy list extends the query when the
          // user actually scrolls there.
          final hasMore =
              logs.length >=
              ref.watch(actionHistoryPagesProvider) * actionHistoryPageSize;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: spacingSm),
            itemCount: groupedLogs.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == groupedLogs.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  ref.read(actionHistoryPagesProvider.notifier).loadMore();
                });
                return const Padding(
                  padding: EdgeInsets.all(spacingLg),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final group = groupedLogs[index];
              return _DateGroup(date: group.date, logs: group.logs);
            },
          );
        },
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
                onPressed: () => ref.invalidate(userActionLogsProvider),
                icon: const Icon(Icons.refresh),
                label: Text(l10n.buttonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_DateLogGroup> _groupByDate(List<ActionLogModel> logs) {
    final grouped = <DateTime, List<ActionLogModel>>{};

    for (final log in logs) {
      final dateKey = DateTime(
        log.loggedAt.year,
        log.loggedAt.month,
        log.loggedAt.day,
      );
      grouped.putIfAbsent(dateKey, () => []).add(log);
    }

    return grouped.entries
        .map((e) => _DateLogGroup(date: e.key, logs: e.value))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}

class _DateLogGroup {
  const _DateLogGroup({required this.date, required this.logs});

  final DateTime date;
  final List<ActionLogModel> logs;
}

class _DateGroup extends StatelessWidget {
  const _DateGroup({required this.date, required this.logs});

  final DateTime date;
  final List<ActionLogModel> logs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final dateLabel = formatDateLabel(date, l10n, locale);
    final totalPoints = logs.fold<int>(0, (sum, log) => sum + log.points);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            spacingLg,
            spacingLg,
            spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacingMd,
                  vertical: spacingXs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: borderRadiusMd,
                ),
                child: Text(
                  l10n.pointsAbbreviated(totalPoints),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Log items
        ...logs.map((log) => ActionLogItem(actionLog: log)),
      ],
    );
  }
}
