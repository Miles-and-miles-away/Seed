import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';

import '../../../../helpers/test_helpers.dart';

Widget _wrap(Widget child, {String? assetPath}) => createTestWidget(
  overrides: [activeMascotAssetPathProvider.overrideWith((_) => assetPath)],
  scaffold: true,
  child: Center(child: child),
);

void main() {
  group('MascotDisplay', () {
    testWidgets('shows a loading spinner while asset path is null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const MascotDisplay(size: 100)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
