import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_condition_model.dart';
import 'package:seed_app/features/eco_dex/data/models/eco_dex_entry_model.dart';
import 'package:seed_app/features/eco_dex/presentation/providers/eco_dex_providers.dart';
import 'package:seed_app/features/eco_dex/presentation/screens/eco_dex_celebration_screen.dart';

EcoDexEntry _entry(
  String id, {
  String nameEn = 'Entry Name',
  String factEn = 'Entry fact text',
}) {
  return EcoDexEntry(
    id: id,
    category: 'climate',
    nameEn: nameEn,
    nameJa: '',
    nameEs: '',
    factEn: factEn,
    factJa: '',
    factEs: '',
    sourceUrl: '',
    iconName: id,
    condition: const EcoDexCondition.totalActions(count: 1),
    hintEn: '',
    hintJa: '',
    hintEs: '',
  );
}

class _CelebrationLauncher extends StatelessWidget {
  const _CelebrationLauncher({required this.entries});

  final List<EcoDexEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showEcoDexCelebrations(context, entries: entries),
          child: const Text('launch'),
        ),
      ),
    );
  }
}

Widget _wrap(Widget home) {
  return ProviderScope(
    overrides: [
      ecoDexAvailableIconsProvider.overrideWith((_) async => <String>{}),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: home,
    ),
  );
}

void main() {
  group('EcoDexCelebrationScreen (widget render)', () {
    testWidgets('renders title, name, fact, and button', (tester) async {
      var dismissed = false;
      await tester.pumpWidget(
        _wrap(
          EcoDexCelebrationScreen(
            entry: _entry(
              'e1',
              nameEn: 'Habit Loop',
              factEn: 'After 7 days a behavior starts wiring itself in.',
            ),
            onDismiss: () => dismissed = true,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('New Discovery!'), findsOneWidget);
      expect(find.text('Habit Loop'), findsOneWidget);
      expect(
        find.text('After 7 days a behavior starts wiring itself in.'),
        findsOneWidget,
      );
      expect(find.text('Awesome!'), findsOneWidget);
      // Queue indicator hidden when nothing else is queued.
      expect(find.textContaining('more queued'), findsNothing);
      expect(dismissed, isFalse);
    });

    testWidgets('shows "+N more queued" when more follow', (tester) async {
      await tester.pumpWidget(
        _wrap(
          EcoDexCelebrationScreen(
            entry: _entry('e1'),
            onDismiss: () {},
            remainingInQueue: 2,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('+2 more queued'), findsOneWidget);
    });

    testWidgets('acknowledge button fires onDismiss', (tester) async {
      var dismissed = 0;
      await tester.pumpWidget(
        _wrap(
          EcoDexCelebrationScreen(
            entry: _entry('e1'),
            onDismiss: () => dismissed++,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      await tester.tap(find.text('Awesome!'));
      expect(dismissed, 1);
    });

    testWidgets('tapping outside the button does not dismiss', (tester) async {
      var dismissed = 0;
      await tester.pumpWidget(
        _wrap(
          EcoDexCelebrationScreen(
            entry: _entry('e1'),
            onDismiss: () => dismissed++,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      await tester.tapAt(const Offset(20, 20));
      expect(dismissed, 0);
    });

    testWidgets('confetti stops repainting after fade-out completes', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(EcoDexCelebrationScreen(entry: _entry('e1'), onDismiss: () {})),
      );

      // Run past the confetti window (4s) plus the fade (600ms); the
      // screen should then be fully idle (no looping animations).
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      expect(find.text('New Discovery!'), findsOneWidget);
    });
  });

  group('showEcoDexCelebrations (queue)', () {
    testWidgets('walks through every entry in order', (tester) async {
      final entries = [
        _entry('first', nameEn: 'First Up'),
        _entry('second', nameEn: 'Second Up'),
        _entry('third', nameEn: 'Third Up'),
      ];

      await tester.pumpWidget(_wrap(_CelebrationLauncher(entries: entries)));
      await tester.tap(find.text('launch'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('First Up'), findsOneWidget);
      expect(find.text('+2 more queued'), findsOneWidget);

      await tester.tap(find.text('Awesome!'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Second Up'), findsOneWidget);
      expect(find.text('+1 more queued'), findsOneWidget);

      await tester.tap(find.text('Awesome!'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Third Up'), findsOneWidget);
      expect(find.textContaining('more queued'), findsNothing);

      await tester.tap(find.text('Awesome!'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Third Up'), findsNothing);
      expect(find.text('New Discovery!'), findsNothing);
    });

    testWidgets('empty list is a no-op (no dialog opens)', (tester) async {
      await tester.pumpWidget(_wrap(const _CelebrationLauncher(entries: [])));
      await tester.tap(find.text('launch'));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('New Discovery!'), findsNothing);
    });
  });
}
