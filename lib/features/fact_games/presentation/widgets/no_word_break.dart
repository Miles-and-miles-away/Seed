import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Lays its text child out at the available width, or wider when its
/// widest unbreakable run needs more, then scales it down to fit, so a
/// word too wide for the box shrinks the text instead of breaking.
class NoWordBreak extends StatelessWidget {
  const NoWordBreak({
    required this.child,
    this.alignment = Alignment.center,
    super.key,
  });

  final Widget child;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: _AtLeastWordWidth(width: constraints.maxWidth, child: child),
    ),
  );
}

class _AtLeastWordWidth extends SingleChildRenderObjectWidget {
  const _AtLeastWordWidth({required this.width, super.child});

  final double width;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderNoWordBreak(width);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderNoWordBreak renderObject,
  ) => renderObject.width = width;
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
