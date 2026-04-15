import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/data/eco_facts_data.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/eco_fact_card.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// Shows a single eco-fact and marks it read on open. Today's fact is
/// shown in its locked state when the daily challenge is incomplete.
class EcoFactDetailScreen extends ConsumerStatefulWidget {
  const EcoFactDetailScreen({required this.dateKey, super.key});

  final String dateKey;

  @override
  ConsumerState<EcoFactDetailScreen> createState() =>
      _EcoFactDetailScreenState();
}

class _EcoFactDetailScreenState extends ConsumerState<EcoFactDetailScreen> {
  bool _marked = false;

  bool get _isToday => widget.dateKey == formatDateKey(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final factsAsync = ref.watch(ecoFactsProvider);
    final isLockedToday = ref.watch(isEcoFactLockedProvider);

    return factsAsync.when(
      data: (facts) {
        final fact = _factForDateKey(facts, widget.dateKey);
        if (fact == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.ecoFactTitle)),
            body: const Center(child: ErrorDisplay()),
          );
        }

        final isLocked = _isToday && isLockedToday;
        _maybeMarkViewed(isLocked: isLocked);

        final name = fact.name(locale);
        final title = name.isNotEmpty ? name : l10n.ecoFactTitle;
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: EcoFactCard(fact: fact, isLocked: isLocked),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(l10n.ecoFactTitle)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: Text(l10n.ecoFactTitle)),
        body: const Center(child: ErrorDisplay()),
      ),
    );
  }

  void _maybeMarkViewed({required bool isLocked}) {
    if (_marked || isLocked) return;
    _marked = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(factViewedProvider.notifier).markDateViewed(widget.dateKey);
    });
  }
}

EcoFact? _factForDateKey(List<EcoFact> facts, String dateKey) {
  final parts = dateKey.split('-');
  if (parts.length != 3) return null;
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) return null;
  final doy = dayOfYear(DateTime(y, m, d));
  for (final f in facts) {
    if (f.dayOfYear == doy) return f;
  }
  return null;
}
