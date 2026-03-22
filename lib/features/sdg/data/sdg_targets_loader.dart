import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/sdg/data/sdg_targets.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/sdg_targets.json';

/// Loads all 169 SDG targets from the bundled JSON asset,
/// keyed by goal number for O(1) lookup.
Future<Map<int, List<SdgTarget>>> loadSdgTargets() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  final result = <int, List<SdgTarget>>{};
  for (final entry in json.entries) {
    final goalNumber = int.parse(entry.key);
    final targets = (entry.value as List<dynamic>)
        .map(
          (e) => SdgTarget.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
    result[goalNumber] = targets;
  }
  return result;
}
