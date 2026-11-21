import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_science_bottom_sheet.dart';

import '../../../../helpers/test_helpers.dart';

const _action = ActionModel(
  id: 'energy-lights',
  nameEn: 'Switch off the lights',
  nameJa: '',
  category: 'energy',
  points: 5,
  descriptionLongEn: 'The science.',
);

void main() {
  testWidgets('the title is drawn in the readable large-text category ink', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        theme: appTheme(Brightness.light),
        scaffold: true,
        child: const ActionScienceBottomSheet(
          action: _action,
          languageCode: 'en',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.text('Switch off the lights')).style?.color,
      readableTextColor(
        ActionCategory.energy.color,
        Brightness.light,
        large: true,
      ),
    );
  });

  testWidgets('the sheet opens at its own height, not the full screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(
        scaffold: true,
        child: Builder(
          builder: (context) => TextButton(
            onPressed: () => ActionScienceBottomSheet.show(
              context,
              action: _action,
              languageCode: 'en',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final screen =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(
      tester.getSize(find.byType(BottomSheet)).height,
      lessThan(screen * 0.9),
    );
  });

  testWidgets('the pinned close button sits on the sheet surface', (
    tester,
  ) async {
    final theme = appTheme(Brightness.light);
    await tester.pumpWidget(
      createTestWidget(
        theme: theme,
        scaffold: true,
        child: const ActionScienceBottomSheet(
          action: _action,
          languageCode: 'en',
        ),
      ),
    );
    await tester.pumpAndSettle();

    final close = tester.widget<IconButton>(find.byType(IconButton));
    expect(
      close.style?.backgroundColor?.resolve({}),
      theme.colorScheme.surfaceContainerLow,
    );
  });
}
