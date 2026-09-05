import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/widgets/eco_dex_entry_image.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('EcoDexEntryImage', () {
    Widget buildWidget({
      required String iconName,
      required Set<String> availableIcons,
    }) => createTestWidget(
      overrides: [
        ecoDexAvailableIconsProvider.overrideWith((_) async => availableIcons),
      ],
      scaffold: true,
      child: EcoDexEntryImage(iconName: iconName, size: 48),
    );

    testWidgets('falls back to blank white container when asset missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(iconName: 'missing_99', availableIcons: {'climate_01'}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsNothing);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(EcoDexEntryImage),
          matching: find.byType(Container),
        ),
      );
      expect(container.color, Colors.white);
    });

    testWidgets('renders blank fallback while manifest loads', (tester) async {
      await tester.pumpWidget(
        buildWidget(iconName: 'climate_01', availableIcons: {'climate_01'}),
      );
      // No pumpAndSettle: provider is still in loading state.

      expect(find.byType(SvgPicture), findsNothing);
      expect(
        find.descendant(
          of: find.byType(EcoDexEntryImage),
          matching: find.byType(Container),
        ),
        findsOneWidget,
      );
    });
  });
}
