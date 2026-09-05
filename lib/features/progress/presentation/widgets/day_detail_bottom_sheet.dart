import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/core/utils/helpers.dart';
import 'package:seed_app/features/actions/data/models/action_log_model.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_log_confirmation_dialog.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_log_item.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/eco_fact_card.dart';

const double _kSheetMaxChildSize = 0.9;
const double _kSheetInitialChildSize = 0.7;
const double _kSheetMinChildSize = 0.4;

/// Bottom sheet showing the summary for a single calendar day:
/// actions logged (with points + CO₂), and the eco-fact if unlocked.
class DayDetailBottomSheet extends ConsumerStatefulWidget {
  const DayDetailBottomSheet({required this.date, super.key});

  final DateTime date;

  static void show(BuildContext context, {required DateTime date}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: sheetShape,
      builder: (_) => DayDetailBottomSheet(date: date),
    );
  }

  @override
  ConsumerState<DayDetailBottomSheet> createState() =>
      _DayDetailBottomSheetState();
}

class _DayDetailBottomSheetState extends ConsumerState<DayDetailBottomSheet> {
  bool _factMarked = false;

  String get _dateKey => formatDateKey(widget.date);

  bool get _isToday => isSameCalendarDay(widget.date, DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    // Day-range query instead of streaming the whole action history.
    final logsAsync = ref.watch(actionsForDayProvider(widget.date));
    final factsAsync = ref.watch(ecoFactsProvider);
    final user = ref.watch(currentUserProvider).value;
    final isLockedToday = ref.watch(isEcoFactLockedProvider);

    final dayLogs = [...logsAsync.asData?.value ?? const <ActionLogModel>[]]
      ..sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    final totalPoints = dayLogs.fold<int>(0, (sum, l) => sum + l.points);
    final totalCo2 = dayLogs.fold<int>(0, (sum, l) => sum + l.co2Grams);

    final fact = factsAsync.asData?.value != null
        ? _factForDate(factsAsync.asData!.value, widget.date)
        : null;
    final unlockedKeys = user?.unlockedFactDates.toSet() ?? const <String>{};
    final viewedKeys = user?.viewedFactDates.toSet() ?? const <String>{};
    final factUnlocked = _isToday
        ? !isLockedToday
        : unlockedKeys.contains(_dateKey) || viewedKeys.contains(_dateKey);
    final factLocked = _isToday && isLockedToday;
    final factShown = fact != null && (factUnlocked || factLocked);

    if (factShown && factUnlocked) {
      _maybeMarkFactViewed();
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: _kSheetInitialChildSize,
      minChildSize: _kSheetMinChildSize,
      maxChildSize: _kSheetMaxChildSize,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            spacingLg,
            spacingSm,
            spacingLg,
            spacingXxl,
          ),
          children: [
            Text(
              formatDateLabel(widget.date, l10n, locale),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: spacingLg),
            _StatsRow(
              actionCount: dayLogs.length,
              points: totalPoints,
              co2Grams: totalCo2,
            ),
            const SizedBox(height: spacingXl),
            Text(
              l10n.dayDetailActions,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: spacingSm),
            if (logsAsync.isLoading && dayLogs.isEmpty)
              const Padding(
                padding: EdgeInsets.all(spacingLg),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (dayLogs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: spacingLg),
                child: Text(
                  l10n.dayDetailNoActions,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...dayLogs.map(
                (log) => ActionLogItem(
                  actionLog: log,
                  onTap: () => _openActionInfo(log),
                ),
              ),
            const SizedBox(height: spacingXl),
            Text(
              l10n.ecoFactTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: spacingSm),
            if (factShown)
              EcoFactCard(fact: fact, isLocked: factLocked)
            else
              _FactUnavailable(message: l10n.dayDetailFactLocked),
          ],
        );
      },
    );
  }

  void _maybeMarkFactViewed() {
    if (_factMarked) return;
    _factMarked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(factViewedProvider.notifier).markDateViewed(_dateKey);
    });
  }

  Future<void> _openActionInfo(ActionLogModel log) async {
    final actions = await ref.read(actionLibraryProvider.future);
    final action = actions.cast<ActionModel?>().firstWhere(
      (a) => a!.id == log.actionId,
      orElse: () => null,
    );
    if (!mounted) return;
    if (action != null) {
      await ActionLogConfirmationDialog.show(
        context,
        action: action,
        languageCode: Localizations.localeOf(context).languageCode,
        readOnly: true,
      );
      return;
    }
    // Not in the library: a banked custom action (e.g. a transport
    // choice). Offer to log it again (reproduce).
    await _confirmReproduce(log);
  }

  Future<void> _confirmReproduce(ActionLogModel log) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(log.actionName),
        content: Text(
          l10n.transportLogChoiceBody(formatCO2Compact(log.co2Grams)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.actionReproduce),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    // Rebuild an ActionModel from the log; the still-present custom
    // template makes the relaxed actionLog rule accept the re-log.
    final result = await ref
        .read(actionLogProvider.notifier)
        .logAction(
          ActionModel(
            id: log.actionId,
            nameEn: log.actionName,
            nameJa: log.actionName,
            nameEs: log.actionName,
            category: log.category,
            points: log.points,
            co2Grams: log.co2Grams,
            relatedSdgs: log.relatedSdgs,
          ),
          languageCode: Localizations.localeOf(context).languageCode,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result != null ? l10n.actionReproducedMessage : l10n.errorGeneric,
        ),
      ),
    );
  }
}

EcoFact? _factForDate(List<EcoFact> facts, DateTime date) {
  final doy = dayOfYear(date);
  return facts.firstWhereOrNull((f) => f.dayOfYear == doy);
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.actionCount,
    required this.points,
    required this.co2Grams,
  });

  final int actionCount;
  final int points;
  final int co2Grams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            icon: Icons.check_circle_outline,
            label: l10n.dayDetailActions,
            value: '$actionCount',
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: spacingSm),
        Expanded(
          child: _StatTile(
            icon: Icons.star_outline,
            label: l10n.homePoints,
            value: formatPoints(points),
            color: theme.colorScheme.tertiary,
          ),
        ),
        const SizedBox(width: spacingSm),
        Expanded(
          child: _StatTile(
            icon: Icons.eco_outlined,
            label: 'CO\u2082',
            value: formatCO2Compact(co2Grams),
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacingMd,
        vertical: spacingMd,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacityFaint),
        borderRadius: borderRadiusMd,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: spacingXs),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FactUnavailable extends StatelessWidget {
  const _FactUnavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spacingXl),
        child: Row(
          children: [
            Icon(Icons.lock_outline, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: spacingMd),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
