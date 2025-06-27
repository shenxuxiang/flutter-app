import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Quaternion, Matrix3;

class Toast {
  static bool _closed = true;
  static final _message = ''.obs;
  static OverlayState? _overlayState;
  static OverlayEntry? _overlayEntry;

  /// 全局始终只有一个 Toast，强制关闭（没有动画）可能会有异常。
  /// 建议在路由组件的 dispose 回调函数中调用。
  static close() {
    if (_closed) return;

    _closed = true;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    _overlayState = null;
  }

  static show(
    String message, {
    Widget? prefix,
    BuildContext? context,
    bool barrierDismissible = true,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    _message.value = message;
    if (_closed) {
      _closed = false;
      _overlayEntry?.remove();
      _overlayEntry?.dispose();
      _overlayState = Overlay.of(context ?? GlobalVars.context!);

      _overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return Obx(
            () => _ToastWidget(
              prefix: prefix,
              onClosed: close,
              duration: duration,
              message: _message.value,
              barrierDismissible: barrierDismissible,
              animationDuration: const Duration(milliseconds: 200),
              animationReverseDuration: const Duration(milliseconds: 150),
            ),
          );
        },
      );

      _overlayState!.insert(_overlayEntry!);
    }
  }

  /// message 最多只展示一行.
  static warning(
    String message, {
    BuildContext? context,
    bool barrierDismissible = true,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    show(
      message,
      context: context,
      duration: duration,
      barrierDismissible: barrierDismissible,
      prefix: Icon(QmIcons.warn, size: 21.sp, color: const Color(0xFFFF4949)),
    );
  }

  /// message 最多只展示一行.
  static success(
    String message, {
    BuildContext? context,
    bool barrierDismissible = true,
    Duration duration = const Duration(milliseconds: 2500),
  }) {
    show(
      message,
      context: context,
      duration: duration,
      barrierDismissible: barrierDismissible,
      prefix: Icon(QmIcons.checked, size: 21.sp, color: const Color(0xFF3AC786)),
    );
  }
}

class _ToastWidget extends StatefulWidget {
  final Widget? prefix;
  final String message;
  final Duration duration;
  final VoidCallback onClosed;
  final bool barrierDismissible;
  final Duration animationDuration;
  final Duration animationReverseDuration;

  const _ToastWidget({
    super.key,
    this.prefix,
    required this.message,
    required this.onClosed,
    required this.duration,
    required this.animationDuration,
    required this.barrierDismissible,
    required this.animationReverseDuration,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer1;
  Timer? _timer2;

  @override
  void didUpdateWidget(_ToastWidget oldWidget) {
    if (oldWidget.message != widget.message) {
      _timer1?.cancel();
      _timer1 = Timer(widget.duration, willClose);
      if (_timer2 != null) {
        _timer2!.cancel();
        _controller.forward(from: 1);
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.forward();

    _timer1 = Timer(widget.duration, willClose);

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> willClose() async {
    if (!mounted) return;

    _timer1?.cancel();
    _controller.reverseDuration = widget.animationReverseDuration;
    _controller.reverse();
    _timer2 = Timer(widget.animationReverseDuration, () {
      _timer2 = null;
      widget.onClosed();
    });
  }

  Matrix4 onTransform(double value) {
    return Matrix4Tween(
      begin:
          _controller.status == AnimationStatus.forward
              ? Matrix4.compose(
                Vector3(0, -50, 0),
                Quaternion.fromRotation(Matrix3.zero()),
                Vector3(0.7, 0.7, 1),
              )
              : Matrix4.identity(),
      end: Matrix4.identity(),
    ).lerp(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: const Alignment(0, -0.25),
        children: [
          Positioned(
            top: 0,
            left: 0,
            width: size.width,
            height: size.height,
            child: GestureDetector(
              onTap: () {
                if (widget.barrierDismissible) willClose();
              },
              child: Container(constraints: BoxConstraints.tight(size), color: Colors.transparent),
            ),
          ),
          Positioned(
            // height: 54.w,
            child: FadeTransition(
              opacity: _animation,
              child: MatrixTransition(
                animation: _animation,
                onTransform: onTransform,
                alignment: Alignment.topCenter,
                child: IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF34332E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.fromLTRB(13.w, 0, 16.w, 0),
                      constraints: BoxConstraints(
                        minHeight: 54.w,
                        maxWidth: size.width * 0.7,
                        maxHeight: widget.prefix == null ? 68.w : 54.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                widget.prefix == null
                                    ? EdgeInsets.zero
                                    : EdgeInsets.only(right: 6.w),
                            child: widget.prefix,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.w),
                              child: Text(
                                widget.message,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: widget.prefix == null ? 2 : 1,
                                style: TextStyle(fontSize: 15.sp, color: Colors.white, height: 1.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
