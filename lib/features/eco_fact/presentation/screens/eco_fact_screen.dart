import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_fact/presentation/providers/eco_fact_providers.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/eco_fact_card.dart';
import 'package:seed_app/features/eco_fact/presentation/widgets/fact_calendar.dart';

/// Screen showing today's eco-fact and a calendar of
/// viewed/missed days.
class EcoFactScreen extends ConsumerStatefulWidget {
  const EcoFactScreen({super.key});

  @override
  ConsumerState<EcoFactScreen> createState() => _EcoFactScreenState();
}

class _EcoFactScreenState extends ConsumerState<EcoFactScreen> {
  bool _markedViewed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_markedViewed) {
        final locked = ref.read(isEcoFactLockedProvider);
        if (!locked) {
          _markedViewed = true;
          ref.read(factViewedProvider.notifier).markViewed();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final factAsync = ref.watch(todayEcoFactProvider);
    final isLocked = ref.watch(isEcoFactLockedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ecoFactTitle),
      ),
      body: factAsync.when(
        data: (fact) {
          if (fact == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                EcoFactCard(
                  fact: fact,
                  isLocked: isLocked,
                ),
                const SizedBox(height: Spacing.xxl),
                const FactCalendar(),
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
