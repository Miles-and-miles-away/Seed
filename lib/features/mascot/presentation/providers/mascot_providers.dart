import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/mascot_species_data.dart';
import '../../data/models/evolution_stage_model.dart';
import '../../data/models/mascot_model.dart';
import '../../data/models/mascot_species_model.dart';
import '../../data/repositories/mascot_repository.dart';

part 'mascot_providers.g.dart';

/// Provides the MascotRepository instance.
@riverpod
MascotRepository mascotRepository(Ref ref) {
  return MascotRepository(firestore: ref.watch(firestoreProvider));
}

/// Streams the current user's mascot data.
///
/// Returns `null` if the user hasn't selected a mascot yet.
@riverpod
Stream<MascotModel?> currentMascot(Ref ref) async* {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    yield null;
    return;
  }

  final repository = ref.watch(mascotRepositoryProvider);
  yield* repository.watchUserMascot(user.uid);
}

/// Whether the current user has selected a mascot.
@riverpod
bool hasMascot(Ref ref) {
  final mascot = ref.watch(currentMascotProvider).value;
  return mascot != null;
}

/// Gets all available mascot species.
@riverpod
Future<List<MascotSpeciesModel>> allSpecies(Ref ref) async {
  final repository = ref.watch(mascotRepositoryProvider);
  return repository.getAllSpecies();
}

/// Gets the species data for the current mascot.
@riverpod
MascotSpeciesModel? currentSpecies(Ref ref) {
  final mascot = ref.watch(currentMascotProvider).value;
  if (mascot == null) return null;
  return getSpeciesById(mascot.speciesId);
}

/// Gets the current evolution stage for the user's mascot (1-4).
///
/// This is computed from the user's level, not stored on the mascot.
@riverpod
int currentMascotStage(Ref ref) {
  final species = ref.watch(currentSpeciesProvider);
  final user = ref.watch(currentUserProvider).value;
  if (species == null || user == null) return 1;
  return species.getStageIndexForLevel(user.level);
}

/// Gets the current evolution stage data.
@riverpod
EvolutionStageModel? currentStageData(Ref ref) {
  final species = ref.watch(currentSpeciesProvider);
  final user = ref.watch(currentUserProvider).value;
  if (species == null || user == null) return null;
  return species.getStageForLevel(user.level);
}

/// Gets the asset path for the current mascot's current evolution stage.
@riverpod
String? mascotAssetPath(Ref ref) {
  final stageData = ref.watch(currentStageDataProvider);
  return stageData?.assetPath;
}

/// Gets the next evolution stage data, or null if at max.
@riverpod
EvolutionStageModel? nextStageData(Ref ref) {
  final species = ref.watch(currentSpeciesProvider);
  final user = ref.watch(currentUserProvider).value;
  if (species == null || user == null) return null;
  return species.getNextStage(user.level);
}

/// Detects if the user has evolved to a new stage.
///
/// Compares the current stage to the last seen stage stored on the mascot.
/// Returns true if the current stage is greater than the last seen stage.
@riverpod
bool hasNewEvolution(Ref ref) {
  final mascot = ref.watch(currentMascotProvider).value;
  final currentStage = ref.watch(currentMascotStageProvider);
  if (mascot == null) return false;
  return currentStage > mascot.lastSeenStage;
}

/// Notifier for mascot mutations (select, rename, update).
@riverpod
class MascotNotifier extends _$MascotNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Selects a mascot for the current user.
  Future<void> selectMascot({
    required String speciesId,
    required String name,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(mascotRepositoryProvider);
      await repository.selectMascot(
        userId: user.uid,
        speciesId: speciesId,
        name: name,
      );
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Renames the current user's mascot.
  Future<void> renameMascot(String name) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(mascotRepositoryProvider);
      await repository.updateMascotName(user.uid, name);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Marks the current evolution stage as seen.
  ///
  /// Call this after showing the evolution celebration.
  Future<void> markEvolutionSeen() async {
    final user = ref.read(currentUserProvider).value;
    final currentStage = ref.read(currentMascotStageProvider);
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(mascotRepositoryProvider);
      await repository.updateLastSeenStage(user.uid, currentStage);
    });
    if (!ref.mounted) return;
    state = result;
  }
}

/// Gets the localized name for the current mascot's species.
@riverpod
String? speciesLocalizedName(Ref ref, String locale) {
  final species = ref.watch(currentSpeciesProvider);
  return species?.getName(locale);
}

/// Gets the localized name for the current evolution stage.
@riverpod
String? stageLocalizedName(Ref ref, String locale) {
  final stageData = ref.watch(currentStageDataProvider);
  if (stageData == null) return null;
  return locale == 'ja' ? stageData.nameJa : stageData.nameEn;
}

// =============================================================================
// Animation Providers
// =============================================================================

/// State class that tracks if a mascot bounce animation should be triggered.
///
/// The MascotDisplay widget watches this and triggers a bounce animation
/// when [shouldBounce] becomes true. The state auto-resets after animation.
@riverpod
class MascotAnimationTrigger extends _$MascotAnimationTrigger {
  @override
  bool build() => false;

  /// Triggers the happy bounce animation on the mascot.
  ///
  /// Call this after a successful action log to reward the user visually.
  void triggerBounce() {
    state = true;
    // Auto-reset after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (state) state = false;
    });
  }
}
