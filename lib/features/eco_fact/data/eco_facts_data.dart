import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/eco_fact/data/models/eco_fact_model.dart';

// ignore_for_file: constant_identifier_names
const ECO_FACT_COUNT = 365;
const _ASSET_PATH = 'data/app/eco_facts.json';

/// Loads all eco-facts from the bundled JSON asset.
Future<List<EcoFact>> loadEcoFacts() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final jsonList = json.decode(jsonString) as List<dynamic>;
  return jsonList
      .map(
        (e) => EcoFact.fromJson(e as Map<String, dynamic>),
      )
      .toList();
}

/// Returns the 1-based day of year for the given date.
/// Leap-year day 366 wraps to day 1.
int dayOfYear(DateTime date) {
  final jan1 = DateTime(date.year);
  final diff = date.difference(jan1).inDays + 1;
  return diff > ECO_FACT_COUNT ? 1 : diff;
}

/// Formats a date as yyyy-MM-dd for storage.
String formatDateKey(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
