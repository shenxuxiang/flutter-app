import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CheckboxWidget extends LeafRenderObjectWidget {
  final bool ghost;
  final double size;
  final bool checked;
  final bool disabled;
  final double radius;
  final double borderWidth;
  final void Function(bool checked)? onChanged;

  const CheckboxWidget({
    super.key,
    this.size = 16,
    this.radius = 4,
    this.onChanged,
    this.ghost = false,
    this.borderWidth = 1,
    required this.checked,
    this.disabled = false,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return RenderCheckbox(
      width: size,
      ghost: ghost,
      height: size,
      value: checked,
      radius: radius,
      disabled: disabled,
      onChanged: onChanged,
      fillColor: primaryColor,
      borderWidth: borderWidth,
    );
  }

  @override
  updateRenderObject(BuildContext context, RenderCheckbox renderObject) {
    if (renderObject.value != checked) {
      renderObject.repaint(checked);
    }

    renderObject
      ..width = size
      ..height = size
      ..ghost = ghost
      ..radius = radius
      ..disabled = disabled
      ..onChanged = onChanged
      ..borderWidth = borderWidth;
  }
}

class RenderCheckbox extends RenderBox {
  bool value;
  bool ghost;
  double width;
  double height;
  int? _pointer;
  double radius;
  bool disabled;
  Color fillColor;
  double borderWidth;
  double _progress = 0.0;
  Duration? _lastTimeStamp;
  void Function(bool checked)? onChanged;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  final Duration animationDuration = const Duration(milliseconds: 200);

  RenderCheckbox({
    this.onChanged,
    required this.ghost,
    required this.value,
    required this.width,
    required this.height,
    required this.radius,
    required this.disabled,
    required this.fillColor,
    required this.borderWidth,
  }) : _animationStatus = value ? AnimationStatus.completed : AnimationStatus.dismissed,
       _progress = value ? 1 : 0;

  @override
  bool get isRepaintBoundary => true;

  @override
  hitTestSelf(Offset position) => disabled == false;

  @override
  handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _pointer = event.pointer;
    } else if (event is PointerMoveEvent) {
      if (event.delta.dx != 0 || event.delta.dy != 0) _pointer = null;
    } else {
      if (event.pointer == _pointer && onChanged is Function) onChanged!(!value);
    }
  }

  @override
  performLayout() {
    size = constraints.isTight ? constraints.biggest : Size(width, height);
  }

  @override
  paint(PaintingContext context, Offset offset) {
    final rect = offset & size;
    if (ghost) {
      drawBorder(context.canvas, rect, _progress);
      drawTick(context.canvas, rect, _progress);
    } else {
      if (_progress <= 0.4) {
        drawBG(context.canvas, rect, _progress / 0.4);
      } else {
        drawBG(context.canvas, rect, 1);
        drawTick(context.canvas, rect, (_progress - 0.4) / 0.6);
      }
    }

    if (_animationStatus == AnimationStatus.forward ||
        _animationStatus == AnimationStatus.reverse) {
      WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
        if (_lastTimeStamp == null) {
          _lastTimeStamp = timeStamp;
          markNeedsPaint();
        } else {
          double delta =
              (timeStamp - _lastTimeStamp!).inMilliseconds / animationDuration.inMilliseconds;

          if (_animationStatus == AnimationStatus.forward) {
            _progress += delta;
          } else {
            _progress -= delta;
          }

          /// 更新时间戳、进度条
          _progress = _progress.clamp(0, 1);
          _lastTimeStamp = timeStamp;

          /// 更新动画状态
          if (_progress >= 1) {
            _animationStatus = AnimationStatus.completed;
          } else if (_progress <= 0) {
            _animationStatus = AnimationStatus.dismissed;
          }

          markNeedsPaint();
        }
      });
    }
  }

  repaint(bool value) {
    if (value) {
      _animationStatus = AnimationStatus.forward;
    } else {
      _animationStatus = AnimationStatus.reverse;
    }
    markNeedsPaint();
    this.value = value;
    _lastTimeStamp = null;
  }

  /// 绘制边框
  drawBorder(Canvas canvas, Rect rect, double progress) {
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        rect.left + borderWidth / 2,
        rect.top + borderWidth / 2,
        rect.width - borderWidth,
        rect.height - borderWidth,
      ),
      Radius.circular(radius),
    );

    final paint =
        Paint()
          ..isAntiAlias = true
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke
          ..color = Color.lerp(const Color(0xFF666666), fillColor, progress)!;

    canvas.drawRRect(rRect, paint);
  }

  /// 绘制背景
  drawBG(Canvas canvas, Rect rect, double progress) {
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final paint =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = Color.lerp(Colors.white, fillColor, progress)!;
    canvas.drawRRect(rRect, paint);

    drawBorder(canvas, rect, progress);
  }

  drawTick(Canvas canvas, Rect rect, double progress) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = rect.width / 12
          ..color =
              ghost ? Color.lerp(const Color(0x00000000), fillColor, progress)! : Colors.white;

    /// 绘制"勾"
    // "勾"的起始点
    final firstPoint = Offset(rect.left + rect.width / 3.6, rect.top + rect.height / 1.9);
    // "勾"的中间拐点位置
    final secondPoint = Offset(rect.left + rect.width / 2.3, rect.bottom - rect.height / 3.2);
    // "勾"的第三个点的位置
    final lastPoint = Offset(rect.right - rect.width / 3.6, rect.top + rect.height / 2.8);

    Path path;
    if (progress <= 0.5) {
      Offset offset = Offset.lerp(firstPoint, secondPoint, progress / 0.5)!;
      path =
          Path()
            ..moveTo(firstPoint.dx, firstPoint.dy)
            ..lineTo(offset.dx, offset.dy);
    } else {
      Offset offset = Offset.lerp(secondPoint, lastPoint, (progress - 0.5) / 0.5)!;
      path =
          Path()
            ..moveTo(firstPoint.dx, firstPoint.dy)
            ..lineTo(secondPoint.dx, secondPoint.dy)
            ..lineTo(offset.dx, offset.dy);
    }

    canvas.drawPath(path, paint);
  }
}
