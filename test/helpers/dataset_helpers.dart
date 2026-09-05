import 'dart:convert';
import 'dart:io';

/// The decoded root object of a bundled JSON dataset, read straight
/// from disk so the checks cover the shipped file itself.
Map<String, dynamic> rawDatasetRoot(String path) =>
    json.decode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// The entry list under [key] of an already decoded dataset [root].
List<Map<String, dynamic>> datasetEntries(
  Map<String, dynamic> root,
  String key,
) => (root[key] as List<dynamic>).cast<Map<String, dynamic>>();

/// The entry list under [key] of the dataset at [path].
List<Map<String, dynamic>> rawDatasetList(String path, String key) =>
    datasetEntries(rawDatasetRoot(path), key);

/// The entries under [key] of the dataset at [path], indexed by [idKey].
Map<String, Map<String, dynamic>> rawDatasetById(
  String path,
  String key, {
  String idKey = 'id',
}) => {
  for (final entry in rawDatasetList(path, key)) entry[idKey] as String: entry,
};
