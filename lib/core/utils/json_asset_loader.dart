import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

/// Loads a bundled JSON asset containing a list of objects and maps
/// each element through [fromJson].
///
/// Decodes on the calling thread whatever the size; every caller's
/// asset is small. [loadJsonRoot] is the object-rooted equivalent and
/// does move a large parse off the UI thread.
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

/// Above this, moving the parse to an isolate is worth the handshake.
const _kIsolateMinChars = 100 * 1024;

/// Loads a bundled JSON asset whose root is an object, e.g.
/// `{"metadata": {...}, "items": [...]}`.
///
/// Deliberately uncached: rootBundle already caches the source string
/// and releases it on memory pressure, which a decoded-root cache here
/// would not.
Future<Map<String, dynamic>> loadJsonRoot(String asset) async {
  final jsonString = await rootBundle.loadString(asset);
  Map<String, dynamic> decode() =>
      jsonDecode(jsonString) as Map<String, dynamic>;
  return jsonString.length < _kIsolateMinChars ? decode() : Isolate.run(decode);
}

/// Maps the list at [key] of an object-rooted asset through [fromJson].
Future<List<T>> loadJsonListUnder<T>(
  String asset,
  String key,
  T Function(Map<String, dynamic>) fromJson,
) async {
  final root = await loadJsonRoot(asset);
  return (root[key] as List<dynamic>)
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
