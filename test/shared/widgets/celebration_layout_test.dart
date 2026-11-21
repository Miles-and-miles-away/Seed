import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_theme.dart';
import 'package:seed_app/features/actions/presentation/widgets/points_animation_overlay.dart';
import 'package:seed_app/features/auth/data/models/app_user_model.dart';
import 'package:seed_app/features/mascot/data/models/evolution_stage_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_model.dart';
import 'package:seed_app/features/mascot/data/models/mascot_species_model.dart';
import 'package:seed_app/features/mascot/data/repositories/mascot_repository.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_discovery_celebration.dart';
import 'package:seed_app/features/mascot/presentation/widgets/egg_hatching_celebration.dart';
import 'package:seed_app/features/mascot/presentation/widgets/evolution_celebration.dart';
import 'package:seed_app/features/settings/presentation/widgets/streak_milestone_dialog.dart';
import 'package:seed_app/shared/widgets/celebration_overlay.dart';

import '../../features/walkthrough/walkthrough_test_support.dart';
import '../../helpers/test_helpers.dart';

class _Repo extends Mock implements MascotRepository {}

const _svg = 'assets/eco_dex/climate_02.svg';
const _uid = walkthroughTestUid;

const _sizes = [Size(320, 568), Size(360, 740)];
const _scales = [1.0, 2.0, 3.0];
const _langs = ['en', 'ja', 'es'];

final _stages = [
  for (final (level, en, ja, es) in [
    (1, 'Polyp', 'ポリプ', 'Pólipo'),
    (10, 'Colony', 'コロニー', 'Colonia'),
    (25, 'Reef', 'サンゴしょう', 'Arrecife'),
    (50, 'Ecosystem', 'せいたいけい', 'Ecosistema'),
  ])
    EvolutionStageModel(
      level: level,
      assetPath: _svg,
      nameEn: en,
      nameJa: ja,
      nameEs: es,
    ),
];

final _species = MascotSpeciesModel(
  id: 'coral',
  nameEn: 'Coral',
  nameJa: 'サンゴ',
  nameEs: 'Coral',
  descriptionEn: '',
  descriptionJa: '',
  evolutionStages: _stages,
);

const _mascot = MascotModel(
  id: 'm',
  speciesId: 'coral',
  name: 'Bud',
  mascotLevel: 50,
);

enum _Kind { evolution, eggDiscovery, eggHatching, streak }

ThemeData _theme(String lang) {
  final base = appTheme(Brightness.light);
  if (lang != 'ja') return base;
  return base.copyWith(
    textTheme: base.textTheme.apply(fontFamily: 'FlutterTest'),
  );
}

void _open(_Kind kind, BuildContext context) {
  unawaited(switch (kind) {
    _Kind.evolution => showCelebrationOverlay(
      context,
      (d) => EvolutionCelebration(onDismiss: d),
    ),
    _Kind.eggDiscovery => showCelebrationOverlay(
      context,
      (d) => EggDiscoveryCelebration(onDismiss: d),
    ),
    _Kind.eggHatching => showEggHatchingCelebration(
      context,
      const MascotModel(id: 'h', speciesId: 'coral'),
    ),
    _Kind.streak => showCelebrationOverlay(
      context,
      (d) =>
          StreakMilestoneDialog(weekNumber: 52, totalDays: 364, onDismiss: d),
    ),
  });
}

Finder _root(_Kind kind) => find.byType(switch (kind) {
  _Kind.evolution => EvolutionCelebration,
  _Kind.eggDiscovery => EggDiscoveryCelebration,
  _Kind.eggHatching => EggHatchingCelebration,
  _Kind.streak => StreakMilestoneDialog,
});

String _dismissLabel(_Kind kind, AppLocalizations l10n) => switch (kind) {
  _Kind.evolution => l10n.evolutionContinue,
  _Kind.eggDiscovery => l10n.eggDiscoveryDismiss,
  _Kind.eggHatching => l10n.eggHatchingConfirm,
  _Kind.streak => l10n.streakMilestoneContinue,
};

Future<void> _runCase(
  WidgetTester tester,
  _Kind kind,
  Size size,
  double scale,
  String lang,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final repo = _Repo();
  when(
    () => repo.updateMascotName(any(), any(), any()),
  ).thenAnswer((_) async {});
  when(() => repo.setActiveMascot(any(), any())).thenAnswer((_) async {});
  final overflows = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    if (message.contains('overflowed')) {
      overflows.add(message.split('\n').first);
    } else {
      previous?.call(details);
    }
  };

  late BuildContext context;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        languageStoreOverride(),
        userOverride(
          const AppUserModel(
            uid: _uid,
            email: 'e',
            mascots: [_mascot],
            activeMascotId: 'm',
          ),
        ),
        mascotRepositoryProvider.overrideWithValue(repo),
        mascotSpeciesDataProvider.overrideWith((_) async => [_species]),
        activeMascotProvider.overrideWith((_) => Stream.value(_mascot)),
        activeSpeciesProvider.overrideWithValue(_species),
        activeMascotStageProvider.overrideWithValue(4),
        activeStageDataProvider.overrideWithValue(_stages[3]),
        activeMascotAssetPathProvider.overrideWithValue(_svg),
      ],
      child: MaterialApp(
        theme: _theme(lang),
        locale: Locale(lang),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: WarmUser(
          child: Builder(
            builder: (c) {
              context = c;
              return const SizedBox.expand();
            },
          ),
        ),
      ),
    ),
  );
  _open(kind, context);
  for (var i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }

  if (kind == _Kind.eggHatching) {
    await tester.enterText(find.byType(TextField), 'Bud');
  }
  final label = _dismissLabel(kind, lookupAppLocalizations(Locale(lang)));
  final button = find
      .ancestor(
        of: find.text(label),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      )
      .first;
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
  await tester.pump();

  FlutterError.onError = previous;
  expect(overflows, isEmpty);
  expect(_root(kind), findsNothing);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 5));
}

void main() {
  setUpAll(loadTestFonts);

  for (final kind in _Kind.values) {
    for (final size in _sizes) {
      for (final scale in _scales) {
        for (final lang in _langs) {
          testWidgets(
            '${kind.name} ${size.width.round()}x${size.height.round()} '
            'scale $scale $lang has no overflow and closes',
            (tester) => _runCase(tester, kind, size, scale, lang),
          );
        }
      }
    }
  }

  for (final lang in _langs) {
    testWidgets('points pill 320 wide scale 3 $lang has no overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          theme: _theme(lang),
          locale: Locale(lang),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(3)),
            child: child!,
          ),
          home: Builder(
            builder: (c) {
              context = c;
              return const SizedBox.expand();
            },
          ),
        ),
      );
      PointsAnimationOverlay.show(context, points: 1000);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PointsAnimationOverlay), findsOneWidget);
      await tester.pumpAndSettle();
    });
  }
}
