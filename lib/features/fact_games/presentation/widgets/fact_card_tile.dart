import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:seed_app/core/constants/ui_constants.dart';
import 'package:seed_app/core/l10n/generated/app_localizations.dart';
import 'package:seed_app/core/utils/ja_phrase.dart';
import 'package:seed_app/features/fact_games/domain/fact_pairs_board.dart';
import 'package:seed_app/shared/widgets/phrase_text.dart';

const _glyphSize = 28.0;
const _checkSize = 16.0;
const _perspective = 0.001;

/// Grid columns at text scale 1.0; larger text gets
/// [factCardWideColumns] taller faces so titles keep the user's size.
const factCardColumns = 3;
const factCardWideColumns = 2;
const factCardWideAspect = 0.75;

enum FactCardState { faceDown, faceUp, matched }

/// One Fact pairs card. Text wraps at the face's width but never inside a
/// word; a word wider than the face, or text taller than it, scales the
/// face down instead.
class FactCardTile extends StatelessWidget {
  const FactCardTile({
    required this.card,
    required this.state,
    required this.index,
    required this.total,
    this.onTap,
    super.key,
  });

  final FactCard card;
  final FactCardState state;

  /// Position on the board, for the face-down label.
  final int index;
  final int total;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final animate =
        !MediaQuery.disableAnimationsOf(context) &&
        !MediaQuery.reduceMotionOf(context);
    final face = KeyedSubtree(key: ValueKey(state), child: _face(context));
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: switch (state) {
        FactCardState.faceDown => l10n.factPairsCardHidden(index + 1, total),
        FactCardState.faceUp => card.text,
        FactCardState.matched => l10n.factPairsCardMatched(card.text),
      },
      onTap: onTap,
      excludeSemantics: true,
      child: animate
          ? AnimatedSwitcher(
              duration: durationNormal,
              // Out face turns edge-on in the first half, in face after.
              switchInCurve: const Interval(0.5, 1),
              switchOutCurve: const Interval(0.5, 1),
              transitionBuilder: _flip,
              child: face,
            )
          : face,
    );
  }

  static Widget _flip(Widget child, Animation<double> animation) =>
      AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, _perspective)
            ..rotateY((1 - animation.value) * pi / 2),
          child: child,
        ),
      );

  Widget _face(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final (background, foreground) = switch (state) {
      FactCardState.faceDown => (
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      FactCardState.faceUp => (
        scheme.surfaceContainerHigh,
        card.face == FactFace.title ? scheme.onSurface : scheme.primary,
      ),
      FactCardState.matched => (
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
    };
    return Card(
      margin: EdgeInsets.zero,
      color: background,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(spacingSm),
                child: state == FactCardState.faceDown
                    ? Icon(Icons.eco, size: _glyphSize, color: foreground)
                    : _text(context, theme, foreground),
              ),
            ),
            if (state == FactCardState.matched)
              PositionedDirectional(
                top: spacingXs,
                end: spacingXs,
                child: Icon(Icons.check, size: _checkSize, color: foreground),
              ),
          ],
        ),
      ),
    );
  }

  Widget _text(BuildContext context, ThemeData theme, Color color) {
    final isTitle = card.face == FactFace.title;
    final style = isTitle
        ? theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          )
        : theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          );
    final figure = jaFigureWrap(
      card.text,
      locale: Localizations.localeOf(context),
    );
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _NoWordBreak(
            width: constraints.maxWidth,
            child: isTitle
                ? PhraseText(
                    card.text,
                    minLineWidth: constraints.maxWidth,
                    textAlign: TextAlign.center,
                    style: style,
                  )
                : Text.rich(
                    TextSpan(
                      text: figure,
                      semanticsLabel: figure == card.text ? null : card.text,
                    ),
                    textAlign: TextAlign.center,
                    style: style,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Lays its text child out at [width], or wider when its widest
/// unbreakable run needs more, so the engine never breaks inside a word.
class _NoWordBreak extends SingleChildRenderObjectWidget {
  const _NoWordBreak({required this.width, super.child});

  final double width;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderNoWordBreak(width);

  @override
  void updateRenderObject(BuildContext context, _RenderNoWordBreak render) =>
      render.width = width;
}

class _RenderNoWordBreak extends RenderProxyBox {
  _RenderNoWordBreak(this._width);

  double _width;
  double get width => _width;

  set width(double value) {
    if (value == _width) return;
    _width = value;
    markNeedsLayout();
  }

  BoxConstraints _childConstraints(RenderBox child) => BoxConstraints.tightFor(
    width: max(_width, child.getMinIntrinsicWidth(double.infinity)),
  );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) return constraints.smallest;
    return constraints.constrain(child.getDryLayout(_childConstraints(child)));
  }

  @override
  void performLayout() {
    final child = this.child!;
    child.layout(_childConstraints(child), parentUsesSize: true);
    size = constraints.constrain(child.size);
  }
}
