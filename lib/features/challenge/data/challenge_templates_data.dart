import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';

// ignore_for_file: constant_identifier_names
const _ASSET_PATH = 'data/app/challenge_templates.json';

/// Loads all challenge templates from the bundled JSON asset.
Future<ChallengeTemplateData> loadChallengeTemplates() async {
  final jsonString = await rootBundle.loadString(_ASSET_PATH);
  final json = jsonDecode(jsonString) as Map<String, dynamic>;

  final daily = (json['daily'] as List<dynamic>)
      .map((e) => DailyChallengeTemplate.fromJson(e as Map<String, dynamic>))
      .toList();

  final multiDay = (json['multiDay'] as List<dynamic>)
      .map((e) => MultiDayChallengeTemplate.fromJson(e as Map<String, dynamic>))
      .toList();

  return ChallengeTemplateData(daily: daily, multiDay: multiDay);
}
