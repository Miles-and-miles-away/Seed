import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../actions/data/models/action_model.dart';
import '../../../actions/presentation/providers/actions_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/models/sdg_stats.dart';

part 'sdg_stats_provider.g.dart';

/// Streams aggregated stats for a specific SDG from
/// the user's action log.
@riverpod
Stream<SdgStats> sdgStats(Ref ref, int sdgNumber) async* {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    yield SdgStats(sdgNumber: sdgNumber);
    return;
  }

  final firestore = ref.watch(firestoreProvider);
  final sdgStr = sdgNumber.toString();

  yield* firestore
      .collection(AppConstants.collectionUsers)
      .doc(user.uid)
      .collection(AppConstants.collectionActionLog)
      .where('relatedSdgs', arrayContains: sdgStr)
      .snapshots()
      .map((snapshot) {
    var totalCo2 = 0;
    for (final doc in snapshot.docs) {
      final co2 = doc.data()['co2Grams'] as int? ?? 0;
      totalCo2 += co2;
    }
    return SdgStats(
      sdgNumber: sdgNumber,
      actionsLogged: snapshot.docs.length,
      co2SavedGrams: totalCo2,
    );
  });
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
