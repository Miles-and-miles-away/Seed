import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/sdg/data/sdg_resources.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_providers.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_resources_list.dart';

import '../../../../helpers/test_helpers.dart';

Widget _wrap(Widget child, {required Map<int, List<SdgResource>> resources}) =>
    createTestWidget(
      scaffold: true,
      overrides: [
        sdgResourcesDataProvider.overrideWith((_) async => resources),
      ],
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );

void main() {
  testWidgets('renders nothing when there are no resources for the goal', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const SdgResourcesList(
          goalNumber: 7,
          goalColor: Colors.amber,
          languageCode: 'en',
        ),
        resources: const {},
      ),
    );
    await tester.pump();

    expect(find.byType(ListTile), findsNothing);
    expect(find.byIcon(Icons.link), findsNothing);
  });

  testWidgets('lists resources with their localized titles', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SdgResourcesList(
          goalNumber: 11,
          goalColor: Colors.orange,
          languageCode: 'en',
        ),
        resources: const {
          11: [
            SdgResource(
              titleEn: 'Sustainable Cities Home',
              titleJa: '',
              titleEs: '',
              url: 'https://example.com/cities',
              type: SdgResourceType.official,
            ),
            SdgResource(
              titleEn: 'Volunteer Locally',
              titleJa: '',
              titleEs: '',
              url: 'https://example.com/volunteer',
              type: SdgResourceType.action,
            ),
          ],
        },
      ),
    );
    await tester.pump();

    expect(find.textContaining('Sustainable Cities Home'), findsOneWidget);
    expect(find.textContaining('Volunteer Locally'), findsOneWidget);
    // Two resources -> two InkWells.
    expect(find.byType(InkWell), findsNWidgets(2));
  });

  testWidgets('respects a custom header text', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SdgResourcesList(
          goalNumber: 11,
          goalColor: Colors.orange,
          languageCode: 'en',
          headerText: 'Learn more',
        ),
        resources: const {
          11: [
            SdgResource(
              titleEn: 'Any',
              titleJa: '',
              titleEs: '',
              url: 'https://x',
              type: SdgResourceType.education,
            ),
          ],
        },
      ),
    );
    await tester.pump();

    expect(find.text('Learn more'), findsOneWidget);
  });
}
