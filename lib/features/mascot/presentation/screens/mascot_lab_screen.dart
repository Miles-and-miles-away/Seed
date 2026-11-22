import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot.dart';
import 'package:seed_app/features/mascot/presentation/drawn/drawn_mascot_painter.dart';
import 'package:seed_app/features/mascot/presentation/providers/mascot_providers.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_display.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_housing.dart';
import 'package:seed_app/features/mascot/presentation/widgets/mascot_image.dart';

/// Debug-only comparison of the code-drawn mascots and the Rive ones.
class MascotLabScreen extends ConsumerStatefulWidget {
  const MascotLabScreen({super.key});

  @override
  ConsumerState<MascotLabScreen> createState() => _MascotLabScreenState();
}

class _MascotLabScreenState extends ConsumerState<MascotLabScreen> {
  static const Map<String, ({String asset, String artboard})> _rive = {
    'seed': (asset: 'assets/animations/sprout_mascot.riv', artboard: 'Sprout'),
    'coral': (asset: 'assets/animations/coral_mascot.riv', artboard: 'Coral'),
  };
  static const double _heroSize = 150;
  static const double _castSize = 72;
  static const double _thumbSize = 48;

  String _speciesId = drawnSpeciesIds.first;
  int _stage = 2;

  @override
  Widget build(BuildContext context) {
    final rive = _rive[_speciesId];
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
        key: ValueKey('$_speciesId $_stage'),
        padding: const EdgeInsets.all(spacingLg),
        children: [
          MascotHousing(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DrawnMascot(
                  speciesId: _speciesId,
                  stage: _stage,
                  size: _heroSize,
                ),
                if (rive != null)
                  MascotImage(
                    assetPath: rive.asset,
                    artboardName: '${rive.artboard}_stage$_stage',
                    width: _heroSize,
                    height: _heroSize,
                  ),
              ],
            ),
          ),
          const SizedBox(height: spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DrawnMascot(
                speciesId: _speciesId,
                stage: _stage,
                size: _thumbSize,
                animate: false,
              ),
              if (rive != null)
                MascotAvatar(
                  assetPath: rive.asset,
                  artboardName: '${rive.artboard}_stage$_stage',
                  size: _thumbSize,
                  animate: false,
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
                    child: DrawnMascot(
                      speciesId: speciesId,
                      stage: stage,
                      size: _castSize,
                      animate: false,
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
