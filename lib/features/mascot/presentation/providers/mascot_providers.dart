import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/mascot_species_loader.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/repositories/mascot_repository.dart';
import 'package:seed_app/features/mascot/data/services/mascot_migration_service.dart';

part 'mascot_providers.g.dart';

// =============================================================
// Data & Repository Providers
// =============================================================

/// Loads and caches mascot species data from JSON.
@riverpod
Future<List<MascotSpeciesModel>> mascotSpeciesData(
  Ref ref,
) =>
    loadMascotSpecies();

@riverpod
MascotRepository mascotRepository(Ref ref) {
  return MascotRepository(
    firestore: ref.watch(firestoreProvider),
  );
}

@riverpod
MascotMigrationService mascotMigrationService(Ref ref) {
  return MascotMigrationService(
    firestore: ref.watch(firestoreProvider),
  );
}

// =============================================================
// Multi-Mascot Providers
// =============================================================

/// All mascots for the current user.
///
/// Derived from the user document already streamed by
/// [currentUserProvider]; opening a second Firestore listener on the
/// same document would only duplicate decode work.
@riverpod
Stream<List<MascotModel>> allMascots(Ref ref) async* {
  final user = ref.watch(currentUserProvider).value;
  yield user?.mascots ?? <MascotModel>[];
}

/// The active mascot for the current user (derived, see [allMascots]).
@riverpod
Stream<MascotModel?> activeMascot(Ref ref) async* {
  final user = ref.watch(currentUserProvider).value;
  final activeId = user?.activeMascotId;
  if (user == null || activeId == null) {
    yield null;
    return;
  }
  MascotModel? active;
  for (final mascot in user.mascots) {
    if (mascot.id == activeId) {
      active = mascot;
      break;
    }
  }
  yield active;
}

/// Whether the current user has at least one mascot.
@riverpod
bool hasMascot(Ref ref) {
  final mascots = ref.watch(allMascotsProvider).value;
  return mascots != null && mascots.isNotEmpty;
}

/// Species data for the active mascot.
@riverpod
MascotSpeciesModel? activeSpecies(Ref ref) {
  final mascot = ref.watch(activeMascotProvider).value;
  if (mascot == null) return null;
  final speciesList = ref.watch(mascotSpeciesDataProvider).value;
  if (speciesList == null) return null;
  return getSpeciesById(mascot.speciesId, speciesList);
}

/// Evolution stage index (1-4) for the active mascot.
/// Computes species inline to avoid double-watching
/// activeMascotProvider through activeSpeciesProvider.
@riverpod
int activeMascotStage(Ref ref) {
  final mascot = ref.watch(activeMascotProvider).value;
  if (mascot == null) return 1;
  final speciesList = ref.watch(mascotSpeciesDataProvider).value;
  if (speciesList == null) return 1;
  final species = getSpeciesById(
    mascot.speciesId,
    speciesList,
  );
  if (species == null) return 1;
  return species.getStageIndexForLevel(
    mascot.mascotLevel,
  );
}

/// Evolution stage data for the active mascot.
@riverpod
EvolutionStageModel? activeStageData(Ref ref) {
  final species = ref.watch(activeSpeciesProvider);
  final mascot = ref.watch(activeMascotProvider).value;
  if (species == null || mascot == null) return null;
  return species.getStageForLevel(mascot.mascotLevel);
}

/// Asset path for the active mascot's current stage.
@riverpod
String? activeMascotAssetPath(Ref ref) {
  final stageData = ref.watch(activeStageDataProvider);
  return stageData?.assetPath;
}

/// Next evolution stage for the active mascot, or null.
@riverpod
EvolutionStageModel? activeNextStageData(Ref ref) {
  final species = ref.watch(activeSpeciesProvider);
  final mascot = ref.watch(activeMascotProvider).value;
  if (species == null || mascot == null) return null;
  return species.getNextStage(mascot.mascotLevel);
}

/// Whether the active mascot has a new unseen evolution.
@riverpod
bool hasNewEvolution(Ref ref) {
  final mascot = ref.watch(activeMascotProvider).value;
  final currentStage = ref.watch(activeMascotStageProvider);
  if (mascot == null) return false;
  return currentStage > mascot.lastSeenStage;
}

// =============================================================
// Egg Providers
// =============================================================

/// The user's current egg (derived from user data).
@riverpod
EggModel? currentEgg(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  return user?.egg;
}

/// Whether the user has an egg.
@riverpod
bool hasEgg(Ref ref) {
  return ref.watch(currentEggProvider) != null;
}

/// Egg hatching progress (0.0 to 1.0).
@riverpod
double eggHatchingProgress(Ref ref) {
  final egg = ref.watch(currentEggProvider);
  if (egg == null) return 0;
  return (egg.hatchingStreakDays / AppConstants.eggHatchingStreakRequired)
      .clamp(0.0, 1.0);
}

/// Days remaining until egg hatches.
@riverpod
int eggDaysRemaining(Ref ref) {
  final egg = ref.watch(currentEggProvider);
  if (egg == null) {
    return AppConstants.eggHatchingStreakRequired;
  }
  return (AppConstants.eggHatchingStreakRequired - egg.hatchingStreakDays)
      .clamp(0, AppConstants.eggHatchingStreakRequired);
}

/// Whether to show the egg discovery celebration.
/// True if eggPendingDiscovery flag is set.
@riverpod
bool shouldShowEggDiscovery(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return false;
  return user.eggPendingDiscovery;
}

// =============================================================
// Localized Name Providers
// =============================================================

/// Localized name for the active mascot's stage.
@riverpod
String? stageLocalizedName(Ref ref, String locale) {
  final stageData = ref.watch(activeStageDataProvider);
  if (stageData == null) return null;
  return switch (locale) {
    'ja' => stageData.nameJa,
    'es' when stageData.nameEs.isNotEmpty => stageData.nameEs,
    _ => stageData.nameEn,
  };
}

// =============================================================
// MascotNotifier -- mutations
// =============================================================

@riverpod
class MascotNotifier extends _$MascotNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Selects a mascot for a new user.
  Future<void> selectMascot({
    required String speciesId,
    required String name,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      await repo.selectMascot(
        userId: user.uid,
        speciesId: speciesId,
        name: name,
      );
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Renames the active mascot.
  Future<void> renameMascot(String name) async {
    final user = ref.read(currentUserProvider).value;
    final mascot = ref.read(activeMascotProvider).value;
    if (user == null || mascot == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      await repo.updateMascotName(
        user.uid,
        mascot.id,
        name,
      );
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Marks the current evolution stage as seen.
  Future<void> markEvolutionSeen() async {
    final user = ref.read(currentUserProvider).value;
    final mascot = ref.read(activeMascotProvider).value;
    final stage = ref.read(activeMascotStageProvider);
    if (user == null || mascot == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      await repo.updateLastSeenStage(
        user.uid,
        mascot.id,
        stage,
      );
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Switches the active mascot.
  Future<void> switchActiveMascot(
    String mascotId,
  ) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      await repo.setActiveMascot(user.uid, mascotId);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Acknowledges egg discovery -- creates the egg.
  Future<void> acknowledgeEggDiscovery() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      final egg = EggModel(receivedAt: DateTime.now());
      await repo.createEgg(user.uid, egg);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Names a newly hatched mascot and makes it active.
  Future<void> nameHatchedMascot(
    String mascotId,
    String name,
  ) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() async {
      final repo = ref.read(mascotRepositoryProvider);
      await repo.updateMascotName(
        user.uid,
        mascotId,
        name,
      );
      await repo.setActiveMascot(user.uid, mascotId);
    });
    if (!ref.mounted) return;
    state = result;
  }

  /// Runs migration if needed on first load.
  Future<void> runMigrationIfNeeded() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    // The migration transaction always costs a server read; skip it
    // when the already-streamed doc shows there is nothing to migrate
    // (mascots exist, or a fresh account that cannot hold legacy data).
    if (user.mascots.isNotEmpty || user.totalActionsCount == 0) return;

    final migrationService = ref.read(mascotMigrationServiceProvider);
    await migrationService.migrateIfNeeded(user.uid);
  }
}

// =============================================================
// Animation Providers
// =============================================================

@riverpod
class MascotAnimationTrigger extends _$MascotAnimationTrigger {
  @override
  bool build() => false;

  void triggerBounce() {
    state = true;
    Future.delayed(
      durationInstant,
      () {
        // The autoDispose notifier may be gone before the delay
        // elapses; touching state then throws.
        if (ref.mounted && state) state = false;
      },
    );
  }
}

// All widgets now watch the active* providers directly.
