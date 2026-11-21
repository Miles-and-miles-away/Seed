import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/sdg/presentation/providers/sdg_stats_provider.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_actions_grid.dart';

void main() {
  const action = ActionModel(
    id: 'tree',
    nameEn: 'Plant a tree',
    nameJa: '木を植える',
    category: 'community',
    points: 5,
    iconName: 'park',
  );

  test('actionLogForSdg carries the goal as a query parameter', () {
    expect(appRoutes.actionLogForSdg(13), '/log-action?sdg=13');
  });

  testWidgets('View all actions opens the action log filtered to the goal', (
    tester,
  ) async {
    Uri? opened;
    final router = GoRouter(
      initialLocation: '/sdg',
      routes: [
        GoRoute(
          path: '/sdg',
          builder: (_, _) => const Scaffold(
            body: SdgActionsGrid(
              goalNumber: 13,
              goalColor: Colors.green,
              languageCode: 'en',
            ),
          ),
        ),
        GoRoute(
          path: appRoutes.actionLog,
          builder: (_, state) {
            opened = state.uri;
            return const Scaffold(body: Text('Log Action'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sdgRelatedActionsProvider.overrideWith((ref, goal) => [action]),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(find.text('Log Action'), findsOneWidget);
    expect(opened?.path, appRoutes.actionLog);
    expect(opened?.queryParameters['sdg'], '13');
  });
}
