import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/eco_dex/data/eco_dex_entries_data.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';

part 'eco_dex_providers.g.dart';

/// Combined state of an entry with its discovery status.
class EcoDexEntryState {
  const EcoDexEntryState({
    required this.entry,
    required this.isDiscovered,
  });

  final EcoDexEntry entry;
  final bool isDiscovered;
}

/// Loads and caches all Eco-Dex data from the JSON asset.
@riverpod
Future<EcoDexData> ecoDexData(Ref ref) => loadEcoDexData();

/// User's set of discovered Eco-Dex entry IDs.
@riverpod
List<String> ecoDexDiscovered(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.ecodexDiscovered ?? [];
}

/// Total discovered count for progress display.
@riverpod
int ecoDexDiscoveredCount(Ref ref) {
  return ref.watch(ecoDexDiscoveredProvider).length;
}

/// All entries with their discovered state.
@riverpod
Future<List<EcoDexEntryState>> ecoDexEntries(Ref ref) async {
  final data = await ref.watch(ecoDexDataProvider.future);
  final discovered = ref.watch(ecoDexDiscoveredProvider).toSet();
  return data.entries.map((entry) {
    return EcoDexEntryState(
      entry: entry,
      isDiscovered: discovered.contains(entry.id),
    );
  }).toList();
}

/// Entries filtered by category.
@riverpod
Future<List<EcoDexEntryState>> ecoDexEntriesByCategory(
  Ref ref,
  String category,
) async {
  final entries = await ref.watch(ecoDexEntriesProvider.future);
  return entries.where((e) => e.entry.category == category).toList();
}

/// Per-category progress (discovered / total).
@riverpod
Future<Map<String, (int, int)>> ecoDexCategoryProgress(
  Ref ref,
) async {
  final data = await ref.watch(ecoDexDataProvider.future);
  final entries = await ref.watch(ecoDexEntriesProvider.future);
  final result = <String, (int, int)>{};
  for (final cat in data.categories) {
    final catEntries = entries.where(
      (e) => e.entry.category == cat.id,
    );
    final discovered = catEntries.where((e) => e.isDiscovered).length;
    result[cat.id] = (discovered, catEntries.length);
  }
  return result;
}

/// Evaluates which entries a user can unlock but hasn't yet.
/// Returns IDs of newly unlockable entries.
@riverpod
Future<List<String>> ecoDexNewUnlocks(Ref ref) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return [];

  final data = await ref.watch(ecoDexDataProvider.future);
  final discovered = user.ecodexDiscovered.toSet();
  final newUnlocks = <String>[];

  for (final entry in data.entries) {
    if (discovered.contains(entry.id)) continue;
    if (_isConditionMet(entry.condition, user)) {
      newUnlocks.add(entry.id);
    }
  }

  return newUnlocks;
}

/// Checks if a condition is met given the user's current stats.
bool _isConditionMet(EcoDexCondition condition, AppUserModel user) {
  return switch (condition) {
    TotalActionsCondition(:final count) => user.totalActionsCount >= count,
    CategoryActionsCondition(:final category, :final count) =>
      _categoryActionCount(user, category) >= count,
    Co2SavedCondition(:final grams) => user.totalCo2Grams >= grams,
    StreakDaysCondition(:final days) => user.longestStreak >= days,
    LevelReachedCondition(:final level) => user.level >= level,
    SdgBreadthCondition(:final count) => _sdgBreadthCount(user) >= count,
    ChallengeStreakCondition(:final days) => user.challengeStreak >= days,
    MultiDayChallengeCondition(:final templateId) =>
      user.completedMultiDayChallenges.contains(templateId),
    EcoFactsViewedCondition(:final count) =>
      user.viewedFactDates.length >= count,
  };
}

/// Counts actions in a specific category.
int _categoryActionCount(AppUserModel user, String category) {
  final counts = user.categoryActionCounts;
  return counts[category] ?? 0;
}

/// Counts how many distinct SDGs the user has logged actions for.
int _sdgBreadthCount(AppUserModel user) {
  return user.sdgStats.keys.length;
}

/// Notifier for discovering new Eco-Dex entries.
@riverpod
class EcoDexDiscoveryNotifier extends _$EcoDexDiscoveryNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Discovers entries whose conditions are met.
  /// Returns the list of newly discovered entry IDs.
  Future<List<String>> discoverNewEntries() async {
    final newUnlocks = await ref.read(ecoDexNewUnlocksProvider.future);
    if (newUnlocks.isEmpty) return [];

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception('Not logged in');

      final userRef = FirebaseFirestore.instance
          .collection(AppConstants.collectionUsers)
          .doc(user.uid);

      await userRef.update({
        'ecodexDiscovered': FieldValue.arrayUnion(newUnlocks),
      });
    });

    if (ref.mounted) {
      state = result;
    }

    return result.hasError ? [] : newUnlocks;
  }
}
