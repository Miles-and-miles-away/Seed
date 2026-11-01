import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/core/utils/date_helpers.dart';
import 'package:seed_app/features/actions/data/models/action_model.dart';
import 'package:seed_app/features/actions/domain/enums/action_category.dart';
import 'package:seed_app/features/actions/presentation/providers/actions_providers.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:seed_app/features/challenge/domain/models/challenge_templates.dart';
import 'package:seed_app/features/challenge/presentation/providers/challenge_providers.dart';
import 'package:seed_app/features/challenge/presentation/widgets/daily_challenge_card.dart';
import 'package:seed_app/features/settings/data/repositories/settings_repository.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

import '../../../../helpers/test_helpers.dart';
import '../../../walkthrough/walkthrough_test_support.dart';

const _lights = ActionModel(
  id: 'turn_off_lights',
  nameEn: 'Turn Off Lights',
  nameJa: '電気を消す',
  nameEs: 'Apagar las luces',
  category: 'energy',
  points: 5,
);

const _lightsTemplate = DailyChallengeTemplate(
  actionId: 'turn_off_lights',
  category: 'energy',
);

/// The curated daily actions as the seed file names them.
List<ActionModel> _curatedActions() {
  final seed =
      jsonDecode(File('data/seed/co2_actions_database.json').readAsStringSync())
          as Map<String, dynamic>;
  final templates =
      (jsonDecode(File('data/app/challenge_templates.json').readAsStringSync())
              as Map<String, dynamic>)['daily']
          as List<dynamic>;
  final ids = {
    for (final t in templates) (t as Map<String, dynamic>)['actionId'],
  };
  return [
    for (final a in seed['actions'] as List<dynamic>)
      if (ids.contains((a as Map<String, dynamic>)['action_id']))
        ActionModel(
          id: a['action_id'] as String,
          nameEn: a['name_en'] as String,
          nameJa: a['name_ja'] as String,
          nameEs: a['name_es'] as String,
          category: a['category'] as String,
          points: 1,
        ),
  ];
}

final _yesterday = formatDateKey(
  DateTime.now().subtract(const Duration(days: 1)),
);
final _today = formatDateKey(DateTime.now());

AppUserModel _user({int streak = 0, bool completed = false}) => AppUserModel(
  uid: 'test-uid',
  email: 'test@example.com',
  challengeStreak: streak,
  // A live streak needs a completion yesterday or today.
  challengeCompletedDate: completed
      ? _today
      : streak > 0
      ? _yesterday
      : '',
);

List<Override> _overrides({
  required AppUserModel user,
  DailyChallengeTemplate template = _lightsTemplate,
  Future<List<ActionModel>> Function()? library,
}) => [
  currentUserProvider.overrideWith((_) => Stream.value(user)),
  challengeTemplateDataProvider.overrideWith(
    (_) async => ChallengeTemplateData(daily: [template], multiDay: const []),
  ),
  actionLibraryProvider.overrideWith(
    (_) => library?.call() ?? Future.value(const [_lights]),
  ),
];

/// The card as Home lays it out, inside the page's side padding.
Widget _buildCard({
  required AppUserModel user,
  DailyChallengeTemplate template = _lightsTemplate,
  Future<List<ActionModel>> Function()? library,
  Locale? locale,
  ThemeData? theme,
}) => createTestWidget(
  locale: locale,
  theme: theme,
  overrides: _overrides(user: user, template: template, library: library),
  child: const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: DailyChallengeCard(),
    ),
  ),
);

/// A router app that records the location the card opens.
Widget _routerApp(List<Override> overrides, List<RouteBase> routes) =>
    ProviderScope(
      overrides: [languageStoreOverride(), ...overrides],
      child: MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(initialLocation: '/', routes: routes),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyChallengeCard', () {
    testWidgets('renders nothing when user is null', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          overrides: [
            ..._overrides(user: _user()).skip(1),
            currentUserProvider.overrideWith((_) => Stream.value(null)),
          ],
          child: const Scaffold(body: DailyChallengeCard()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('renders nothing while the action library loads', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildCard(
          user: _user(),
          library: () => Completer<List<ActionModel>>().future,
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('names the action, the reward and the category rule', (
      tester,
    ) async {
      await tester.pumpWidget(_buildCard(user: _user()));
      await tester.pumpAndSettle();

      expect(find.text('DAILY ACTION CHALLENGE'), findsOneWidget);
      expect(
        find.text("Log 'Turn Off Lights' to unlock today's eco-fact"),
        findsOneWidget,
      );
      expect(find.text('Any energy action counts'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('reads in Japanese', (tester) async {
      await tester.pumpWidget(
        _buildCard(user: _user(), locale: const Locale('ja')),
      );
      await tester.pumpAndSettle();

      expect(find.text('アクションチャレンジ'), findsOneWidget);
      expect(find.text('「電気を消す」を記録して、今日のエコファクトを解除しよう'), findsOneWidget);
      expect(find.text('エネルギーのアクションならどれでもOK'), findsOneWidget);
    });

    testWidgets('reads in Spanish', (tester) async {
      await tester.pumpWidget(
        _buildCard(user: _user(), locale: const Locale('es')),
      );
      await tester.pumpAndSettle();

      expect(find.text('DESAFÍO DIARIO'), findsOneWidget);
      expect(
        find.text(
          'Registra «Apagar las luces» para desbloquear el eco-dato de hoy',
        ),
        findsOneWidget,
      );
      expect(find.text('Vale cualquier acción de energía'), findsOneWidget);
    });

    testWidgets('falls back to the category without a hint when the '
        'library lacks the action', (tester) async {
      await tester.pumpWidget(
        _buildCard(
          user: _user(),
          template: const DailyChallengeTemplate(
            actionId: 'retired_action',
            category: 'energy',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Log any energy action to unlock today's eco-fact"),
        findsOneWidget,
      );
      expect(find.text('Any energy action counts'), findsNothing);
    });

    testWidgets('falls back to the category when the library fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildCard(
          user: _user(),
          library: () => Future.error(Exception('offline')),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Log any energy action to unlock today's eco-fact"),
        findsOneWidget,
      );
    });

    testWidgets('opens Log Action filtered with the named action first', (
      tester,
    ) async {
      String? location;
      await tester.pumpWidget(
        _routerApp(_overrides(user: _user()), [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: DailyChallengeCard()),
          ),
          GoRoute(
            path: '/log-action',
            builder: (_, state) {
              location = state.uri.toString();
              return const Scaffold(body: Text('Action Log'));
            },
          ),
        ]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('DAILY ACTION CHALLENGE'));
      await tester.pumpAndSettle();

      expect(find.text('Action Log'), findsOneWidget);
      expect(location, '/log-action?category=energy&action=turn_off_lights');
    });

    testWidgets('the fallback opens Log Action filtered to the category', (
      tester,
    ) async {
      String? location;
      await tester.pumpWidget(
        _routerApp(
          _overrides(
            user: _user(),
            template: const DailyChallengeTemplate(
              actionId: 'retired_action',
              category: 'energy',
            ),
          ),
          [
            GoRoute(
              path: '/',
              builder: (_, _) => const Scaffold(body: DailyChallengeCard()),
            ),
            GoRoute(
              path: '/log-action',
              builder: (_, state) {
                location = state.uri.toString();
                return const Scaffold(body: Text('Action Log'));
              },
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DailyChallengeCard));
      await tester.pumpAndSettle();

      expect(location, '/log-action?category=energy');
    });

    testWidgets('completed: tapping anywhere on the card opens the inbox', (
      tester,
    ) async {
      await tester.pumpWidget(
        _routerApp(_overrides(user: _user(completed: true)), [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(body: DailyChallengeCard()),
          ),
          GoRoute(
            path: '/home/daily-fact',
            builder: (_, _) => const Scaffold(body: Text('Inbox')),
          ),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('DAILY ACTION CHALLENGE'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      await tester.tap(find.byIcon(Icons.check_circle));
      await tester.pumpAndSettle();

      expect(find.text('Inbox'), findsOneWidget);
    });

    testWidgets('shows the streak badge when streak > 0', (tester) async {
      await tester.pumpWidget(_buildCard(user: _user(streak: 5)));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('each state is one button, the streak read in words', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_buildCard(user: _user(streak: 5)));
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.text('DAILY ACTION CHALLENGE'));
      expect(node, isSemantics(isButton: true, hasTapAction: true));
      expect(node.label.split('\n'), contains('5 day challenge streak'));
      expect(node.label.split('\n'), isNot(contains('5')));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(_buildCard(user: _user(completed: true)));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.text('Complete!')),
        isSemantics(isButton: true, hasTapAction: true),
      );
      handle.dispose();
    });

    testWidgets('falls back when the library files the action elsewhere', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildCard(
          user: _user(),
          library: () async => [_lights.copyWith(category: 'consumption')],
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text("Log any energy action to unlock today's eco-fact"),
        findsOneWidget,
      );
      expect(find.text('Any energy action counts'), findsNothing);
    });

    testWidgets('hides the streak badge when streak is 0', (tester) async {
      await tester.pumpWidget(_buildCard(user: _user()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.local_fire_department), findsNothing);
    });

    group('colours', () {
      for (final species in ['seed', 'coral']) {
        for (final brightness in Brightness.values) {
          final label = '$species ${brightness.name}';
          final theme = appTheme(
            brightness,
            seedColor: AppColors.speciesThemeSeeds[species],
          );
          final scheme = theme.colorScheme;

          testWidgets('$label: tertiary shade, readable icon and streak', (
            tester,
          ) async {
            await tester.pumpWidget(
              _buildCard(user: _user(streak: 3), theme: theme),
            );
            await tester.pumpAndSettle();

            final shade = Color.alphaBlend(
              scheme.tertiaryContainer.withValues(alpha: 0.5),
              scheme.surfaceContainerLow,
            );
            expect(tester.widget<Card>(find.byType(Card)).color, shade);
            expect(
              tester
                  .widget<Icon>(find.byIcon(ActionCategory.energy.icon))
                  .color,
              ActionCategory.energy.textColorOn(brightness),
            );
            final count = tester.widget<Text>(find.text('3')).style!.color!;
            expect(count, readableTextColor(AppColors.streak, brightness));
            expect(contrastRatio(count, shade), greaterThanOrEqualTo(4.5));
          });

          testWidgets('$label: completed title is readable', (tester) async {
            await tester.pumpWidget(
              _buildCard(user: _user(completed: true), theme: theme),
            );
            await tester.pumpAndSettle();

            final shade = tester.widget<Card>(find.byType(Card)).color!;
            expect(shade.a, 1.0);
            final title = tester
                .widget<Text>(find.text('Complete!'))
                .style!
                .color!;
            expect(contrastRatio(title, shade), greaterThanOrEqualTo(4.5));
          });
        }
      }
    });

    group('text keeps its size and its words', () {
      setUpAll(loadTestFonts);
      final curated = _curatedActions();

      for (final language in ['en', 'es', 'ja']) {
        for (final scale in [1.0, 1.3, 2.0]) {
          testWidgets('at 320pt in $language at text scale $scale', (
            tester,
          ) async {
            expect(curated, hasLength(24));
            sizeViewport(
              tester,
              size: Size(
                language == 'es' ? 320 * robotoToSfWidthFactor : 320,
                1200,
              ),
            );
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );

            final bad = <String>[];
            for (final action in curated) {
              await tester.pumpWidget(const SizedBox.shrink());
              await tester.pumpWidget(
                _buildCard(
                  user: _user(streak: 12),
                  template: DailyChallengeTemplate(
                    actionId: action.id,
                    category: action.category,
                  ),
                  library: () => Future.value([action]),
                  locale: Locale(language),
                  theme: language == 'ja'
                      ? ThemeData(fontFamily: 'FlutterTest')
                      : null,
                ),
              );
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull, reason: action.id);

              for (final (text, shrink, needed) in noWordBreakScales(
                tester.renderObject(find.byType(DailyChallengeCard)),
              )) {
                if (language == 'ja' ? shrink < 1 : shrink < needed - 0.005) {
                  bad.add('${action.id}: $text shrinks to $shrink');
                }
              }
              if (language == 'ja' && scale > 1) continue;
              final texts = find.descendant(
                of: find.byType(DailyChallengeCard),
                matching: find.byType(RichText),
              );
              for (final element in texts.evaluate()) {
                final lines = renderedLines(
                  tester,
                  find.byElementPredicate((e) => e == element),
                );
                for (final b in breaksInsideWords(lines, language)) {
                  bad.add('${action.id}: $b');
                }
              }
            }
            expect(bad, isEmpty);
          });
        }
      }
    });

    group('overline', () {
      setUpAll(loadTestFonts);

      for (final language in ['en', 'es', 'ja']) {
        testWidgets('is one line at 320pt in $language with a streak', (
          tester,
        ) async {
          sizeViewport(
            tester,
            size: Size(
              language == 'es' ? 320 * robotoToSfWidthFactor : 320,
              640,
            ),
          );
          await tester.pumpWidget(
            _buildCard(
              user: _user(streak: 12),
              locale: Locale(language),
              theme: language == 'ja'
                  ? ThemeData(fontFamily: 'FlutterTest')
                  : null,
            ),
          );
          await tester.pumpAndSettle();

          final overline = lookupAppLocalizations(
            Locale(language),
          ).challengeOverline.toUpperCase();
          expect(renderedLines(tester, find.text(overline)), hasLength(1));
        });
      }
    });

    group('without a streak', () {
      stressWidthLayoutTests(
        (locale, theme) => _buildCard(
          user: _user(),
          template: const DailyChallengeTemplate(
            actionId: 'share_sustainability_tip',
            category: 'community',
          ),
          library: () async => _curatedActions(),
          locale: locale,
          theme: theme,
        ),
        widths: testPhoneWidths,
      );
    });

    group('with a streak', () {
      stressWidthLayoutTests(
        (locale, theme) => _buildCard(
          user: _user(streak: 12),
          template: const DailyChallengeTemplate(
            actionId: 'share_sustainability_tip',
            category: 'community',
          ),
          library: () async => _curatedActions(),
          locale: locale,
          theme: theme,
        ),
        widths: testPhoneWidths,
      );
    });

    group('walkthrough', () {
      late FakeFirebaseFirestore firestore;
      late SettingsRepository repo;
      const uid = 'test-uid';

      setUp(() async {
        firestore = FakeFirebaseFirestore();
        repo = SettingsRepository(firestore: firestore);
        await firestore.collection('users').doc(uid).set({'uid': uid});
        await repo.markWalkthroughFound(uid, WalkthroughItem.intro.name);
      });

      Widget app(AppUserModel user, List<RouteBase> routes) => _routerApp([
        ...walkthroughOverrides(
          user: user,
          settings: repo.watchSettings(uid),
          firestore: firestore,
        ),
        ..._overrides(user: user).skip(1),
      ], routes);

      // Home wraps the card in its shimmer, which keeps the pending
      // provider alive for the card's synchronous read.
      GoRoute home() => GoRoute(
        path: '/',
        builder: (_, _) => const Scaffold(
          body: WarmUser(
            child: WalkthroughShimmer(
              item: WalkthroughItem.dailyChallenge,
              child: DailyChallengeCard(),
            ),
          ),
        ),
      );

      testWidgets('incomplete card explains itself, then opens the log', (
        tester,
      ) async {
        sizeViewport(tester);
        String? location;
        await tester.pumpWidget(
          app(const AppUserModel(uid: uid, email: 'e'), [
            home(),
            GoRoute(
              path: '/log-action',
              builder: (_, state) {
                location = state.uri.toString();
                return const Scaffold(body: Text('Action Log'));
              },
            ),
          ]),
        );
        await pumpUntilFound(tester, find.text('DAILY ACTION CHALLENGE'));

        await tester.tap(find.text('DAILY ACTION CHALLENGE'));
        await pumpUntilFound(tester, find.byType(WalkthroughOverlay));
        expect(find.text('Action Log'), findsNothing);

        await tester.tap(find.text('Got it'));
        await pumpUntilFound(tester, find.text('Action Log'));
        expect(location, '/log-action?category=energy&action=turn_off_lights');
        await settleWrites(tester);
        final found = await foundInFirestore(firestore, uid);
        expect(found, contains(WalkthroughItem.dailyChallenge.name));
        expect(found, isNot(contains(WalkthroughItem.logAction.name)));
        await flushOverlayTimers(tester);
      });

      testWidgets('completed card ticks silently and opens the inbox', (
        tester,
      ) async {
        await tester.pumpWidget(
          app(
            AppUserModel(uid: uid, email: 'e', challengeCompletedDate: _today),
            [
              home(),
              GoRoute(
                path: '/home/daily-fact',
                builder: (_, _) => const Scaffold(body: Text('Inbox')),
              ),
            ],
          ),
        );
        await pumpUntilFound(tester, find.text("See today's eco-fact"));

        await tester.tap(find.text("See today's eco-fact"));
        await pumpUntilFound(tester, find.text('Inbox'));
        expect(find.byType(WalkthroughOverlay), findsNothing);
        await settleWrites(tester);
        final found = await foundInFirestore(firestore, uid);
        expect(found, contains(WalkthroughItem.dailyChallenge.name));
      });
    });
  });
}
