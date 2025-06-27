import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdaptiveLayout extends SingleChildRenderObjectWidget {
  // 设计稿的基准宽度
  final double designWidth;

  const AdaptiveLayout({super.key, required super.child, required this.designWidth});

  @override
  RenderObject createRenderObject(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return RenderAdaptiveLayout(screenWidth: screenWidth, dpr: dpr, designWidth: designWidth);
  }

  // @override
  // void updateRenderObject(BuildContext context, RenderAdaptiveLayout renderObject) {
  //   debugPrint('updateRenderObject adapt');
  //   final size = MediaQuery.sizeOf(context);
  //   final dpr = MediaQuery.devicePixelRatioOf(context);
  //   final screenWidth =
  //       MediaQuery.orientationOf(context) == Orientation.landscape ? size.height : size.width;
  //
  //   renderObject
  //     ..dpr = dpr
  //     ..screenWidth = screenWidth;
  // }
}

class RenderAdaptiveLayout extends RenderProxyBox {
  double screenWidth;
  double designWidth;
  double dpr;

  RenderAdaptiveLayout({required this.dpr, required this.screenWidth, required this.designWidth});

  @override
  void performLayout() {
    // 计算缩放比例
    final scale = screenWidth / designWidth * dpr;

    // 调整约束条件
    final childConstraints = BoxConstraints(
      minWidth: constraints.minWidth * scale,
      maxWidth: constraints.maxWidth * scale,
      minHeight: constraints.minHeight * scale,
      maxHeight: constraints.maxHeight * scale,
    );

    // 对子组件进行布局
    child!.layout(childConstraints, parentUsesSize: true);

    // 设置自身尺寸
    size = Size(child!.size.width / scale, child!.size.height / scale);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final scale = screenWidth / designWidth * dpr;
    // 保存画布当前状态
    context.canvas.save();
    // 应用缩放变换
    context.canvas.scale(scale);
    // 绘制子组件
    context.paintChild(child!, offset.scale(1 / scale, 1 / scale));
    // 恢复画布状态
    context.canvas.restore();
  }
}
