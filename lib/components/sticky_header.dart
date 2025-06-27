import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StickyHeader extends MultiChildRenderObjectWidget {
  final Widget body;
  final Widget header;

  StickyHeader({super.key, required this.header, required this.body})
    : super(children: [body, header]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final scrollPosition = Scrollable.of(context).position;
    return _RenderStickyHeader(scrollPosition: scrollPosition);
  }
}

class _RenderStickyHeader extends RenderBox
    with
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData>,
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData> {
  final ScrollPosition scrollPosition;

  _RenderStickyHeader({required this.scrollPosition});

  @override
  void attach(PipelineOwner owner) {
    scrollPosition.addListener(markNeedsLayout);
    super.attach(owner);
  }

  @override
  void detach() {
    scrollPosition.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }

    super.setupParentData(child);
  }

  @override
  void performLayout() {
    final header = lastChild!;
    final body = firstChild!;

    body.layout(constraints, parentUsesSize: true);
    header.layout(constraints, parentUsesSize: true);

    double bodyW = body.size.width;
    double bodyH = body.size.height;
    double headerW = header.size.width;
    double headerH = header.size.height;

    size = constraints.constrain(
      Size(
        constraints.maxWidth == double.infinity ? math.max(headerW, bodyW) : double.infinity,
        bodyH + headerH,
      ),
    );

    final bodyParentData = body.parentData as MultiChildLayoutParentData;
    bodyParentData.offset = Offset(0, headerH);
    final headerParentData = header.parentData as MultiChildLayoutParentData;

    double currentPosition = computePosition();
    if (currentPosition >= 0) {
      headerParentData.offset = const Offset(0, 0);
    } else {
      double maxOffset = bodyH;
      headerParentData.offset = Offset(0, math.min(currentPosition.abs(), maxOffset));
    }
  }

  double computePosition() {
    final scrollBox = scrollPosition.context.notificationContext?.findRenderObject();
    if (scrollBox?.attached ?? false) {
      try {
        return localToGlobal(Offset.zero, ancestor: scrollBox).dy;
      } catch (err, stack) {
        debugPrint('$err');
        debugPrint('$stack');
      }
    }

    return 0.0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return firstChild!.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return firstChild!.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return lastChild!.getMinIntrinsicHeight(width) + firstChild!.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return (lastChild!.getMaxIntrinsicHeight(width) + firstChild!.getMaxIntrinsicHeight(width));
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }
}
