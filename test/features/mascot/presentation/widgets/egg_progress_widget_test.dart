import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/mascot/data/models/egg_model.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_progress_widget.dart';

Widget _wrap(AppUserModel? user) => ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((_) => Stream.value(user)),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              height: 140,
              child: EggProgressWidget(size: 100),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('renders nothing when there is no egg', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AppUserModel(uid: 'u', email: 'e'),
      ),
    );
    await tester.pump();

    // SizedBox.shrink has a fixed layout; no circular progress should render.
    expect(find.byIcon(Icons.egg_outlined), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('renders egg icon and progress ring when egg present', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        AppUserModel(
          uid: 'u',
          email: 'e',
          egg: EggModel(
            receivedAt: DateTime.utc(2026),
            hatchingStreakDays: 10,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.egg_outlined), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('progress ring value reflects the streak days', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppUserModel(
          uid: 'u',
          email: 'e',
          egg: EggModel(
            receivedAt: DateTime.utc(2026),
            hatchingStreakDays: 15,
          ),
        ),
      ),
    );
    await tester.pump();

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(progress.value, closeTo(0.5, 0.02));
  });
}
