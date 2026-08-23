import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/features/auth/data/repositories/auth_repository.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/auth/presentation/utils/listen_auth_result.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

/// Minimal host standing in for the three auth screens, which differ only
/// in the callbacks they pass.
class _Host extends ConsumerWidget {
  const _Host({this.onError, this.onCompleted});

  final VoidCallback? onError;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenAuthResult(context, ref, onError: onError, onCompleted: onCompleted);
    return const Scaffold(body: SizedBox.shrink());
  }
}

void main() {
  late _MockAuthRepository repo;

  setUp(() {
    repo = _MockAuthRepository();
  });

  Future<ProviderContainer> pumpHost(
    WidgetTester tester, {
    VoidCallback? onError,
    VoidCallback? onCompleted,
    bool showHost = true,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: showHost
              ? _Host(onError: onError, onCompleted: onCompleted)
              : const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pump();
    return ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
      listen: false,
    );
  }

  testWidgets('a failure surfaces a localized error SnackBar', (tester) async {
    when(
      () => repo.sendPasswordResetEmail(any()),
    ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
    final container = await pumpHost(tester);

    await container
        .read(authProvider.notifier)
        .sendPasswordResetEmail('a@b.com');
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.backgroundColor, AppColors.error);
    expect(
      find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)),
      findsOneWidget,
    );
  });

  testWidgets('onError runs on failure and onCompleted does not', (
    tester,
  ) async {
    when(
      () => repo.sendPasswordResetEmail(any()),
    ).thenThrow(FirebaseAuthException(code: 'invalid-email'));
    var errors = 0;
    var completions = 0;
    final container = await pumpHost(
      tester,
      onError: () => errors++,
      onCompleted: () => completions++,
    );

    await container.read(authProvider.notifier).sendPasswordResetEmail('nope');
    await tester.pump();

    expect(errors, 1);
    expect(completions, 0);
  });

  testWidgets('onCompleted runs once a pending operation succeeds', (
    tester,
  ) async {
    when(() => repo.sendPasswordResetEmail(any())).thenAnswer((_) async {});
    var completions = 0;
    final container = await pumpHost(tester, onCompleted: () => completions++);

    await container
        .read(authProvider.notifier)
        .sendPasswordResetEmail('a@b.com');
    await tester.pump();

    expect(completions, 1);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('nothing is reported after the host leaves the tree', (
    tester,
  ) async {
    when(
      () => repo.sendPasswordResetEmail(any()),
    ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));
    var errors = 0;
    final container = await pumpHost(tester, onError: () => errors++);

    await pumpHost(tester, onError: () => errors++, showHost: false);
    await container
        .read(authProvider.notifier)
        .sendPasswordResetEmail('a@b.com');
    await tester.pump();

    expect(errors, 0);
    expect(find.byType(SnackBar), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
