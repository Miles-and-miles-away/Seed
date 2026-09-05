import 'package:seed_app/core/utils/json_asset_loader.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';

/// Loads all challenge templates from the bundled JSON asset.
Future<ChallengeTemplateData> loadChallengeTemplates() async {
  final json = await loadJsonRoot('data/app/challenge_templates.json');
  return ChallengeTemplateData(
    daily: (json['daily'] as List<dynamic>)
        .map((e) => DailyChallengeTemplate.fromJson(e as Map<String, dynamic>))
        .toList(),
    multiDay: (json['multiDay'] as List<dynamic>)
        .map(
          (e) => MultiDayChallengeTemplate.fromJson(e as Map<String, dynamic>),
        )
        .toList(),
  );
}
