import 'package:flutter/material.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/features/explore/presentation/explore_entries.dart';
import 'package:seed_app/features/explore/presentation/widgets/explore_tile.dart';
import 'package:seed_app/features/fact_games/fact_games.dart';
import 'package:seed_app/features/walkthrough/walkthrough.dart';

/// The Explore tab: the three calculators, then the surfaces that teach
/// and play over the same data.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _listKey = GlobalKey();

  /// The tiles the calculators walkthrough explains, in page order: the
  /// three calculators, then the ranking.
  final _tileKeys = List.generate(
    calculatorEntries.length + 1,
    (_) => GlobalKey(),
  );

  /// Walkthrough page being shown, or null.
  final _page = ValueNotifier<int?>(null);

  int get _rankedPage => calculatorEntries.length;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  /// [page]'s tile on screen, or null when the page has no tile or the
  /// tile is not wholly inside the list's viewport.
  Rect? _tileRect(int page) {
    if (page >= _tileKeys.length) return null;
    final tile = _rectOf(_tileKeys[page]);
    final viewport = _rectOf(_listKey);
    if (tile == null || viewport == null) return null;
    return viewport.intersect(tile) == tile ? tile : null;
  }

  Rect? _rectOf(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Widget _tile(int page, ExploreEntry entry, int? shown) => ExploreTile(
    key: _tileKeys[page],
    entry: entry,
    dimmed: shown != null && shown != page,
    ringed: shown == page,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.exploreTitle)),
      body: WalkthroughTrigger(
        item: WalkthroughItem.calculators,
        spotlight: _tileRect,
        onPage: (page) => _page.value = page,
        child: ValueListenableBuilder<int?>(
          valueListenable: _page,
          builder: (context, shown, _) => ListView(
            key: _listKey,
            padding: const EdgeInsets.all(spacingLg),
            children: [
              _SectionHeader(l10n.calculatorsSheetTitle),
              for (final (i, entry) in calculatorEntries.indexed) ...[
                if (i > 0) const SizedBox(height: spacingSm),
                _tile(i, entry, shown),
              ],
              const SizedBox(height: spacingXxl),
              _SectionHeader(l10n.explorePlayHeader),
              _tile(_rankedPage, energyRankedEntry, shown),
              const SizedBox(height: spacingSm),
              WalkthroughShimmer(
                item: WalkthroughItem.quiz,
                borderRadius: borderRadiusLg,
                child: ExploreTile(entry: quizEntry, dimmed: shown != null),
              ),
              const SizedBox(height: spacingSm),
              FactGameExploreTile(entry: factPairsEntry, dimmed: shown != null),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: spacingSm),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
