import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';

import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

// ignore_for_file: constant_identifier_names
const ECO_FACT_COUNT = 366;
const _ASSET_PATH = 'data/app/eco_facts.json';
const _LEAP_DAY = 60;

/// Loads all eco-facts from the bundled JSON asset.
Future<List<EcoFact>> loadEcoFacts() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  // 440+ KB of JSON: decode off the UI thread.
  return Isolate.run(
    () => (json.decode(jsonString) as List<dynamic>)
        .map((e) => EcoFact.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// Returns the 1-based fact day for the given date: the day of a non-leap
/// year, with leap-year 29 Feb mapped to the leap-day fact, 366.
int dayOfYear(DateTime date) {
  // UTC projection: a local-time difference is off by one for the
  // whole DST half of the year (local days are not always 24h).
  final jan1 = DateTime.utc(date.year);
  final day = dateOnlyUtc(date).difference(jan1).inDays + 1;
  final isLeapYear = DateTime.utc(date.year, 2, 29).month == 2;
  if (!isLeapYear || day < _LEAP_DAY) return day;
  return day == _LEAP_DAY ? ECO_FACT_COUNT : day - 1;
}
