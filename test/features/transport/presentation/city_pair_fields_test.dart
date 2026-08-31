import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/transport/transport.dart';

// Real dataset rows: the point of these tests is that the shipped
// names are reachable from an ASCII keyboard and readable in JA/ES.
const _saoPaulo = City(
  name: 'São Paulo',
  cc: 'BR',
  lat: -23.5475,
  lon: -46.6361,
  mass: 'SouthAmerica',
  nameJa: 'サンパウロ',
);
const _herat = City(
  name: 'Herāt',
  cc: 'AF',
  lat: 34.3482,
  lon: 62.1997,
  mass: 'Eurasia',
  nameJa: 'ヘラート',
);
const _tokyo = City(
  name: 'Tokyo',
  cc: 'JP',
  lat: 35.6895,
  lon: 139.6917,
  mass: 'ISL_JP',
  nameJa: '東京都',
  nameEs: 'Tokio',
);
const _cities = [_saoPaulo, _herat, _tokyo];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildFields({City? from, Locale locale = const Locale('en')}) {
    return ProviderScope(
      overrides: [transportCitiesProvider.overrideWith((_) async => _cities)],
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CityPairFields(from: from, to: null, onChanged: (_, _) {}),
        ),
      ),
    );
  }

  Future<void> search(WidgetTester tester, String query) async {
    await tester.pumpWidget(buildFields());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, query);
    await tester.pumpAndSettle();
  }

  testWidgets('an unaccented query finds an accented city', (tester) async {
    // Nobody types the tilde on a phone keyboard.
    await search(tester, 'sao paulo');
    expect(find.text('São Paulo, BR'), findsOneWidget);
  });

  testWidgets('folding covers marks beyond Latin-1', (tester) async {
    await search(tester, 'herat');
    expect(find.text('Herāt, AF'), findsOneWidget);
  });

  testWidgets('a Japanese query matches in an English UI', (tester) async {
    await search(tester, 'ヘラート');
    expect(find.text('Herāt, AF'), findsOneWidget);
  });

  testWidgets('under two characters offers nothing', (tester) async {
    await search(tester, 's');
    expect(find.text('São Paulo, BR'), findsNothing);
  });

  testWidgets('two dropped characters do not match every city', (tester) async {
    // The length guard ran on the raw text while the fold ran after,
    // and the fold drops curly quotes: two of them passed the guard,
    // folded to '', and every city contains ''.
    await search(tester, '’’');
    expect(find.text('São Paulo, BR'), findsNothing);
    expect(find.text('Tokyo, JP'), findsNothing);
  });

  testWidgets('labels follow the UI locale', (tester) async {
    await tester.pumpWidget(
      buildFields(from: _tokyo, locale: const Locale('ja')),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '東京都, JP',
    );
  });

  testWidgets('a locale the city has no name for falls back', (tester) async {
    await tester.pumpWidget(
      buildFields(from: _saoPaulo, locale: const Locale('es')),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      'São Paulo, BR',
    );
  });

  testWidgets('an in-app language change relabels the field', (tester) async {
    // Autocomplete seeds its controller once, at mount. Without a
    // reseed the field still read "Tokyo, JP" after the switch while
    // the selection's label had become "東京都, JP", so the next
    // keystroke failed the equality check and dropped a valid pair.
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    var cleared = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [transportCitiesProvider.overrideWith((_) async => _cities)],
        child: ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (context, value, _) => MaterialApp(
            locale: value,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: CityPairFields(
                from: _tokyo,
                to: null,
                onChanged: (from, _) => cleared |= from == null,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    locale.value = const Locale('ja');
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '東京都, JP',
    );
    expect(cleared, isFalse);
  });
}
