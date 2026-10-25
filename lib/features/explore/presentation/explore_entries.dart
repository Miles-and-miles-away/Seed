import 'package:flutter/material.dart';

import 'package:seed_app/app/router.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/theme/app_colors.dart';

/// One destination on the Explore screen.
class ExploreEntry {
  const ExploreEntry({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.color,
  });

  final IconData icon;
  final String Function(AppLocalizations l10n) title;
  final String Function(AppLocalizations l10n) subtitle;
  final String route;

  /// The domain's category colour; null takes the scheme's primary.
  final Color? color;
}

/// Transport, food and home energy, in walkthrough page order.
final calculatorEntries = [
  ExploreEntry(
    icon: Icons.commute,
    color: AppColors.categoryTransport,
    title: (l10n) => l10n.categoryTransport,
    subtitle: (l10n) => l10n.exploreTransportSubtitle,
    route: appRoutes.transportCalculator,
  ),
  ExploreEntry(
    icon: Icons.restaurant,
    color: AppColors.categoryFood,
    title: (l10n) => l10n.categoryFood,
    subtitle: (l10n) => l10n.exploreFoodSubtitle,
    route: appRoutes.foodCalculator,
  ),
  ExploreEntry(
    icon: Icons.bolt,
    color: AppColors.categoryEnergy,
    title: (l10n) => l10n.calculatorHomeEnergy,
    subtitle: (l10n) => l10n.exploreEnergySubtitle,
    route: appRoutes.energyCalculator,
  ),
];

/// A chart rather than the bolt, which already marks the energy calculator.
final energyRankedEntry = ExploreEntry(
  icon: Icons.bar_chart,
  color: AppColors.categoryEnergy,
  title: (l10n) => l10n.energyRankedTitle,
  subtitle: (l10n) => l10n.exploreEnergyRankedSubtitle,
  route: appRoutes.energyExplore,
);

/// Domain-neutral: the game rotates between all three datasets.
final quizEntry = ExploreEntry(
  icon: Icons.quiz_outlined,
  title: (l10n) => l10n.quizTitle,
  subtitle: (l10n) => l10n.exploreQuizSubtitle,
  route: appRoutes.quiz,
);

/// Blue grey sets the fact games apart from the quiz's primary green.
final factPairsEntry = ExploreEntry(
  icon: Icons.style,
  color: AppColors.categoryLearning,
  title: (l10n) => l10n.factPairsTitle,
  subtitle: (l10n) => l10n.factPairsSubtitle,
  route: appRoutes.factPairs,
);

/// Purple, unused by the other tiles, tells the two fact games apart.
final factRecallEntry = ExploreEntry(
  icon: Icons.psychology_outlined,
  color: AppColors.categoryConsumption,
  title: (l10n) => l10n.factRecallTitle,
  subtitle: (l10n) => l10n.factRecallSubtitle,
  route: appRoutes.factRecall,
);
