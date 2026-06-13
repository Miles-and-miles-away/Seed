import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

// ignore_for_file: constant_identifier_names
const ECO_FACT_COUNT = 366;
const _ASSET_PATH = 'data/app/eco_facts.json';

/// Loads all eco-facts from the bundled JSON asset.
Future<List<EcoFact>> loadEcoFacts() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  // 440+ KB of JSON: decode off the UI thread.
  return Isolate.run(
    () => (json.decode(jsonString) as List<dynamic>)
        .map(
          (e) => EcoFact.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
  );
}

/// Returns the 1-based day of year for the given date.
/// Returns 366 on leap-year Dec 31; 1-365 otherwise.
int dayOfYear(DateTime date) {
  // UTC projection: a local-time difference is off by one for the
  // whole DST half of the year (local days are not always 24h).
  final jan1 = DateTime.utc(date.year);
  final diff = dateOnlyUtc(date).difference(jan1).inDays + 1;
  return diff.clamp(1, 366);
}

/// Formats a date as yyyy-MM-dd for storage.
String formatDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
