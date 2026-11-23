import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_sheet.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  testWidgets('the source link is a full-size, announced link', (tester) async {
    final semantics = tester.ensureSemantics();
    const entry = EcoDexEntry(
      id: 'e1',
      category: 'forests',
      nameEn: 'Entry',
      nameJa: '',
      nameEs: '',
      factEn: 'A fact.',
      iconName: 'e1',
      hintEn: '',
      condition: EcoDexCondition.totalActions(count: 1),
      sourceUrl: 'https://example.org',
    );
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: EcoDexEntrySheet(entry: entry, locale: 'en'),
      ),
    );
    await tester.pump();

    final button = find.byType(TextButton);
    expect(
      tester.getSize(button).height,
      greaterThanOrEqualTo(kMinInteractiveDimension),
    );
    final flags = tester.getSemantics(button).flagsCollection;
    expect(flags.isButton, isTrue);
    expect(flags.isLink, isTrue);
    semantics.dispose();
  });
}
