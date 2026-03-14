import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/sdg/domain/models/sdg_stats.dart';

part 'sdg_stats_provider.g.dart';

/// Aggregated stats for a specific SDG from the
/// denormalized sdgStats map on the user document.
@riverpod
SdgStats sdgStats(Ref ref, int sdgNumber) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return SdgStats(sdgNumber: sdgNumber);

  final sdgStr = sdgNumber.toString();
  final stats = user.sdgStats[sdgStr];

  return SdgStats(
    sdgNumber: sdgNumber,
    actionsLogged: stats?['count'] ?? 0,
    co2SavedGrams: stats?['co2'] ?? 0,
  );
}

/// Filters the action library to only actions related
/// to a specific SDG.
@riverpod
List<ActionModel> sdgRelatedActions(
  Ref ref,
  int sdgNumber,
) {
  final actionsAsync = ref.watch(actionLibraryProvider);
  final sdgStr = sdgNumber.toString();

  return actionsAsync.when(
    data: (actions) => actions
        .where(
          (a) => a.relatedSdgs.contains(sdgStr),
        )
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}
