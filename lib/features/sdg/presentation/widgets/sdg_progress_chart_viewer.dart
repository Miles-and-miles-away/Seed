import 'package:flutter/material.dart' hide Durations;

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/sdg/data/sdg_data.dart';
import 'package:seed_app/features/sdg/presentation/widgets/sdg_section_header.dart';

/// Every progress card is exported at one canvas size, so reserving the
/// space keeps the detail page from reflowing as the image decodes.
const _chartAspectRatio = 984 / 1296;

/// Tappable SDG progress chart that expands to a full-screen
/// zoomable view with Hero animation.
class SdgProgressChartViewer extends StatelessWidget {
  const SdgProgressChartViewer({
    required this.goal,
    this.locale = 'en',
    super.key,
  });

  final SdgGoal goal;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SdgSectionHeader(
          icon: Icons.insert_chart_outlined,
          title: l10n.sdgProgressChart,
          color: goal.color,
        ),
        const SizedBox(height: spacingMd),
        Semantics(
          label: '${goal.shortTitle(locale)}. ${l10n.sdgProgressChartHint}',
          button: true,
          image: true,
          child: GestureDetector(
            onTap: () => _showFullScreen(context),
            child: Hero(
              tag: 'sdg_progress_${goal.number}',
              child: ClipRRect(
                borderRadius: borderRadiusLg,
                child: AspectRatio(
                  aspectRatio: _chartAspectRatio,
                  // The card is a self-contained graphic whose header, axis
                  // and source line all carry meaning, so it is never cropped.
                  child: Image.asset(
                    goal.progressChartAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black54,
        transitionDuration: durationSlower,
        reverseTransitionDuration: durationEmphasis,
        pageBuilder: (_, _, _) =>
            _FullScreenProgressChart(goal: goal, locale: locale),
      ),
    );
  }
}

class _FullScreenProgressChart extends StatelessWidget {
  const _FullScreenProgressChart({required this.goal, required this.locale});

  final SdgGoal goal;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Goal ${goal.number}: '
          '${goal.shortTitle(locale)}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: Hero(
            tag: 'sdg_progress_${goal.number}',
            child: Image.asset(goal.progressChartAsset, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
