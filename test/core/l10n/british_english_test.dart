import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/shared/providers/app_language_provider.dart';

void main() {
  testWidgets('English resolves to en-GB formats', (tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: britishEnglish,
        supportedLocales: appSupportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );

    final locale = Localizations.localeOf(context);
    final material = MaterialLocalizations.of(context);
    final date = DateTime(2026, 11, 21);

    expect(locale, britishEnglish);
    expect(AppLocalizations.of(context).localeName, 'en');
    expect(DateFormat.yMd(locale.toString()).format(date), '21/11/2026');
    expect(DateFormat.yMMMd(locale.toString()).format(date), '21 Nov 2026');
    expect(material.firstDayOfWeekIndex, 1);
    expect(material.timeOfDayFormat(), TimeOfDayFormat.HH_colon_mm);
  });
}
