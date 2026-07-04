import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads a bundled JSON asset containing a list of objects and maps
/// each element through [fromJson].
///
/// For large assets (100 KB+), prefer a bespoke loader that decodes in
/// an isolate (see eco_facts_data.dart) -- this helper decodes on the
/// calling thread.
Future<List<T>> loadJsonList<T>(
  String asset,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final jsonString = await rootBundle.loadString(asset);
  final list = jsonDecode(jsonString) as List<dynamic>;
  return list
      .map((e) => fromJson(e as Map<String, dynamic>))
      .toList(growable: false);
}

/// Loads a bundled JSON asset shaped `{"<goalNumber>": [objects]}` into
/// a map keyed by goal number for O(1) lookup (SDG targets/resources).
Future<Map<int, List<T>>> loadGoalKeyedJsonList<T>(
  String asset,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final jsonString = await rootBundle.loadString(asset);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  return {
    for (final entry in json.entries)
      int.parse(entry.key): (entry.value as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
  };
}
