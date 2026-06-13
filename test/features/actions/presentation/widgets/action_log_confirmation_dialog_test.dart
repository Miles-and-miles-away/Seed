import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/constants/app_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/presentation/widgets/action_log_confirmation_dialog.dart';

const _action = ActionModel(
  id: 'transport-bike',
  nameEn: 'Bike to work',
  nameJa: '自転車通勤',
  category: 'transport',
  points: 10,
);

Widget _wrap() => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: SizedBox()),
    );

void main() {
  testWidgets(
    'note field truncates emoji-heavy input to the UTF-16 unit cap',
    (tester) async {
      await tester.pumpWidget(_wrap());

      final future = ActionLogConfirmationDialog.show(
        tester.element(find.byType(Scaffold)),
        action: _action,
        languageCode: 'en',
      );
      await tester.pumpAndSettle();

      // 150 emoji are 150 graphemes (within maxLength) but 300 UTF-16
      // units -- over the Firestore rule's 200-unit cap, so the UI must
      // truncate or the whole action-log write is rejected server-side.
      const emoji = '\u{1F600}';
      await tester.enterText(find.byType(TextField), emoji * 150);

      final field = tester.widget<TextField>(find.byType(TextField));
      final text = field.controller!.text;
      expect(text.length, lessThanOrEqualTo(AppConstants.maxNoteLength));
      expect(text, emoji * 100);

      // Confirm so the returned note reflects the truncated value.
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      final result = await future;
      expect(result?.confirmed, isTrue);
      expect(result?.note?.length, AppConstants.maxNoteLength);
    },
  );
}
