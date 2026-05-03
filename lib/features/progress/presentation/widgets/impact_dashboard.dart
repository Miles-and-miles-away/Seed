import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/progress/domain/entities/time_period.dart';
import 'package:seed_app/features/progress/presentation/providers/co2_stats_provider.dart';
import 'package:seed_app/features/progress/presentation/widgets/co2_total_card.dart';
import 'package:seed_app/features/progress/presentation/widgets/time_period_selector.dart';
import 'package:seed_app/shared/widgets/widgets.dart';

/// The Impact segment body on the Progress screen. Owns the selected
/// [TimePeriod] state, renders the period selector + headline total
/// card, and reserves vertical space for the §6.3 (equivalencies) and
/// §6.4 (charts) sections that ship later.
class ImpactDashboard extends ConsumerStatefulWidget {
  const ImpactDashboard({super.key});

  @override
  ConsumerState<ImpactDashboard> createState() => _ImpactDashboardState();
}

class _ImpactDashboardState extends ConsumerState<ImpactDashboard> {
  TimePeriod _period = TimePeriod.today;

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(co2StatsProvider(_period));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.lg,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimePeriodSelector(
            selected: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
          const SizedBox(height: Spacing.lg),
          statsAsync.when(
            data: (stats) => Co2TotalCard(stats: stats),
            loading: () => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(
              height: 160,
              child: Center(child: ErrorDisplay()),
            ),
          ),
          // 6.3 Equivalencies and 6.4 Charts will mount below here.
          const SizedBox(height: Spacing.xxl),
        ],
      ),
    );
  }
}
