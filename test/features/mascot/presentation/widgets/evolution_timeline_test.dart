import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/presentation/widgets/evolution_timeline.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

import '../../../../helpers/test_helpers.dart';

/// Coral's real stage names: the JA and ES ones wrap at narrow widths.
const _names = [
  ('Polyp', 'ポリプ', 'Pólipo'),
  ('Colony', 'コロニー', 'Colonia'),
  ('Reef', 'サンゴしょう', 'Arrecife'),
  ('Ecosystem', 'せいたいけい', 'Ecosistema'),
];
const _levels = [1, 10, 25, 50];

final _stages = [
  for (var i = 0; i < _names.length; i++)
    EvolutionStageModel(
      level: _levels[i],
      assetPath: 'assets/images/mascot/seed_stage${i + 1}.svg',
      nameEn: _names[i].$1,
      nameJa: _names[i].$2,
      nameEs: _names[i].$3,
    ),
];

void main() {
  setUpAll(loadTestFonts);

  for (final locale in ['en', 'ja', 'es']) {
    for (final width in [320.0, 360.0, 411.0]) {
      testWidgets('every stage card has the same height in $locale at '
          '${width.toInt()}pt', (tester) async {
        sizeViewport(tester, size: Size(width, 800));
        await tester.pumpWidget(
          createTestWidget(
            scaffold: true,
            locale: Locale(locale),
            // Roboto has no kana, so pin JA to the default test font.
            theme: locale == 'ja' ? ThemeData(fontFamily: 'FlutterTest') : null,
            child: Padding(
              padding: const EdgeInsets.all(spacingXxl),
              child: EvolutionTimeline(stages: _stages, currentStage: 2),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 1));

        expect(tester.takeException(), isNull);
        final cards = find
            .byType(MascotImage)
            .evaluate()
            .map(
              (art) => find
                  .ancestor(
                    of: find.byWidget(art.widget),
                    matching: find.byType(Container),
                  )
                  .first,
            );
        final heights = cards.map((c) => tester.getSize(c).height).toSet();
        expect(heights, hasLength(1));
        expect(heights.single, greaterThan(0));

        // Disposes the current stage's endless pulse.
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
