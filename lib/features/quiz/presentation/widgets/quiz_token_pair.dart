import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Two tokens side by side at the taller one's height, found by layout:
/// a paragraph's intrinsic sizes depend on the order they are asked in.
class QuizTokenPair extends MultiChildRenderObjectWidget {
  QuizTokenPair({
    required Widget left,
    required Widget right,
    required this.gap,
    super.key,
  }) : super(children: [left, right]);

  final double gap;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTokenPair(gap);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) =>
      (renderObject as _RenderTokenPair).gap = gap;
}

class _PairParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTokenPair extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _PairParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _PairParentData> {
  _RenderTokenPair(this._gap);

  double _gap;
  double get gap => _gap;

  set gap(double value) {
    if (value == _gap) return;
    _gap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _PairParentData) {
      child.parentData = _PairParentData();
    }
  }

  @override
  void performLayout() {
    final width = (constraints.maxWidth - _gap) / 2;
    var height = 0.0;
    var child = firstChild;
    while (child != null) {
      child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
      height = max(height, child.size.height);
      child = childAfter(child);
    }
    var x = 0.0;
    child = firstChild;
    while (child != null) {
      // Not tight, so a change inside a token lays the pair out again.
      child.layout(
        BoxConstraints(minWidth: width, maxWidth: width, minHeight: height),
        parentUsesSize: true,
      );
      (child.parentData! as _PairParentData).offset = Offset(x, 0);
      x += width + _gap;
      child = childAfter(child);
    }
    size = constraints.constrain(Size(constraints.maxWidth, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
