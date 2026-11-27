import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/drawn/mascot_pose.dart';
import 'package:seed_app/features/mascot/presentation/drawn/reveal_effects.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_cheer.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_housing.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_speech_bubble.dart';

const double _heroSize = 150;
const int _labStreak = 6;

/// Debug-only preview of the code-drawn mascots and their routines.
class MascotLabScreen extends ConsumerStatefulWidget {
  const MascotLabScreen({super.key});

  @override
  ConsumerState<MascotLabScreen> createState() => _MascotLabScreenState();
}

class _MascotLabScreenState extends ConsumerState<MascotLabScreen> {
  static const Map<String, MascotRoutine?> _routines = {
    'idle': null,
    'dance': dance,
    'cheer': cheer,
    'evolve': evolve,
    'hatch': hatch,
  };
  static const List<String> _scenes = ['greet', 'first log', 'jump'];
  static const double _castSize = 72;
  static const double _thumbSize = 48;

  String _speciesId = drawnSpeciesIds.first;
  int _stage = 2;
  String _routine = _routines.keys.first;

  @override
  Widget build(BuildContext context) {
    final stage = switch (_routine) {
      'hatch' => 1,
      'evolve' => math.max(2, _stage),
      _ => _stage,
    };
    final drawn = drawnMascotPath(_speciesId, stage);
    final hero = MascotImage(
      assetPath: drawn,
      width: _heroSize,
      height: _heroSize,
      hero: true,
      wavesOnTap: true,
      routine: _routines[_routine],
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.sentiment_satisfied_alt),
            onPressed: () =>
                ref.read(mascotSmileTriggerProvider.notifier).triggerSmile(),
          ),
        ],
      ),
      body: ListView(
        key: ValueKey('$_speciesId $_stage $_routine'),
        padding: const EdgeInsets.all(spacingLg),
        children: [
          MascotHousing(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                switch (_routine) {
                  'hatch' => HatchingEgg(size: _heroSize, child: hero),
                  'evolve' => EvolutionSmoke(
                    size: _heroSize,
                    before: MascotImage(
                      assetPath: drawnMascotPath(_speciesId, stage - 1),
                      width: _heroSize,
                      height: _heroSize,
                    ),
                    after: hero,
                  ),
                  _ when _scenes.contains(_routine) => _Scene(
                    scene: _routine,
                    assetPath: drawn,
                  ),
                  _ => hero,
                },
                MascotAvatar(
                  assetPath: drawn,
                  size: _thumbSize,
                  animate: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: spacingLg),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: spacingSm,
            children: [
              for (final name in [..._routines.keys, ..._scenes])
                ChoiceChip(
                  label: Text(name),
                  selected: name == _routine,
                  onSelected: (_) => setState(() => _routine = name),
                ),
            ],
          ),
          const SizedBox(height: spacingLg),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              for (final speciesId in drawnSpeciesIds)
                for (
                  var stage = 1;
                  stage <= DrawnMascotPainter.stageCount;
                  stage++
                )
                  InkWell(
                    onTap: () => setState(() {
                      _speciesId = speciesId;
                      _stage = stage;
                    }),
                    child: MascotImage(
                      assetPath: drawnMascotPath(speciesId, stage),
                      width: _castSize,
                      height: _castSize,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The daily greeting, the first log of the day or the goal jump, played
/// once as Home and the action cheer show them.
class _Scene extends StatefulWidget {
  const _Scene({required this.scene, required this.assetPath});

  final String scene;
  final String assetPath;

  @override
  State<_Scene> createState() => _SceneState();
}

class _SceneState extends State<_Scene> with SingleTickerProviderStateMixin {
  late final _hop = AnimationController(
    vsync: this,
    duration: mascotHopDuration,
  );
  var _waves = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.scene == 'jump') _hop.forward();
      if (widget.scene == 'greet') setState(() => _waves++);
    });
  }

  @override
  void dispose() {
    _hop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hero = MascotImage(
      assetPath: widget.assetPath,
      width: _heroSize,
      height: _heroSize,
      hero: true,
      hopOnLoad: widget.scene == 'jump',
      waveCount: _waves,
      routine: widget.scene == 'first log' ? dance : null,
    );
    if (widget.scene == 'greet') {
      return Column(
        children: [
          hero,
          const SizedBox(height: spacingMd),
          SpeechBubble(
            title: l10n.mascotGreetingWelcome,
            text: l10n.mascotGreetingStreak(_labStreak),
            pointsUp: true,
          ),
        ],
      );
    }
    final stage = drawnMascotStage(widget.assetPath)!.stage;
    return Padding(
      padding: const EdgeInsets.only(top: _heroSize / 2),
      child: widget.scene == 'jump'
          ? AnimatedBuilder(
              animation: _hop,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                  0,
                  -_heroSize / 2 * mascotHopLift.evaluate(_hop),
                ),
                child: child,
              ),
              child: hero,
            )
          : Stack(
              clipBehavior: Clip.none,
              children: [
                hero,
                Positioned(
                  left: -_heroSize / 4,
                  right: -_heroSize / 4,
                  bottom:
                      _heroSize * (1 - drawnMascotHeadTops[stage - 1]) +
                      spacingXs,
                  child: Center(
                    child: SpeechBubble(
                      text: l10n.mascotCheerStreak(_labStreak),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
