import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:seed_app/features/sdg/data/sdg_goals_loader.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';
import 'package:seed_app/features/sdg/data/sdg_resources_data.dart';
import 'package:seed_app/features/sdg/data/sdg_targets.dart';
import 'package:seed_app/features/sdg/data/sdg_targets_loader.dart';

part 'sdg_providers.g.dart';

/// Loads and caches SDG goal data from JSON.
@riverpod
Future<SdgGoalsData> sdgGoalsData(Ref ref) => loadSdgGoals();

/// Loads and caches SDG resource data from JSON.
@riverpod
Future<Map<int, List<SdgResource>>> sdgResourcesData(
  Ref ref,
) =>
    loadSdgResources();

/// Loads and caches SDG target data from JSON.
@riverpod
Future<Map<int, List<SdgTarget>>> sdgTargetsData(
  Ref ref,
) =>
    loadSdgTargets();
