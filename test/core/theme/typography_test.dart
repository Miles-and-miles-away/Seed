import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/theme/app_theme.dart';

final _allowedSizes = {
  fontSizeSmall,
  fontSizeBody,
  fontSizeTitle,
  fontSizeLarge,
  fontSizeHero,
};

// Computed sizes that are not prose: a glyph wall and a theme fallback.
const _fontSizeAllowlist = {
  'lib/core/theme/app_theme.dart',
  'lib/features/energy/presentation/widgets/energy_explore_sheet.dart',
  'lib/shared/widgets/scaled_segmented_button.dart',
};

List<TextStyle?> _roles(TextTheme t) => [
  t.displayLarge,
  t.displayMedium,
  t.displaySmall,
  t.headlineLarge,
  t.headlineMedium,
  t.headlineSmall,
  t.titleLarge,
  t.titleMedium,
  t.titleSmall,
  t.bodyLarge,
  t.bodyMedium,
  t.bodySmall,
  t.labelLarge,
  t.labelMedium,
  t.labelSmall,
];

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('every role resolves to one of five sizes ($brightness)', (
      tester,
    ) async {
      late ThemeData resolved;
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme(brightness),
          home: Builder(
            builder: (context) {
              resolved = Theme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      final roles = _roles(resolved.textTheme);
      expect(roles.map((s) => s?.fontSize).toSet(), _allowedSizes);
      // Merged over the defaults, not replacing them.
      expect(resolved.textTheme.labelSmall?.fontWeight, FontWeight.w500);
      expect(resolved.textTheme.bodyMedium?.height, isNotNull);
    });
  }

  test('no fontSize literal outside the theme', () {
    final offenders = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.contains('/generated/'))
        .where((f) => !_fontSizeAllowlist.contains(f.path))
        .where((f) => f.readAsStringSync().contains('fontSize:'))
        .map((f) => f.path)
        .toList();
    expect(offenders, isEmpty);
  });
}
