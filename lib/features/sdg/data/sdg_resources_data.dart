import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/sdg/data/sdg_resources.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/sdg_resources.json';

/// Loads all SDG resources from the bundled JSON asset.
Future<Map<int, List<SdgResource>>> loadSdgResources() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  final result = <int, List<SdgResource>>{};
  for (final entry in json.entries) {
    final goalNumber = int.parse(entry.key);
    final resources = (entry.value as List<dynamic>)
        .map(
          (e) => SdgResource.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
    result[goalNumber] = resources;
  }
  return result;
}
