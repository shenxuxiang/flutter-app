import 'package:vector_math/vector_math_64.dart' show Vector3, Quaternion, Matrix3;
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'utils.dart';

typedef CloseAlertFunction = Future<void> Function();
typedef AlertBuilder = Widget Function(BuildContext context, CloseAlertFunction close);

class Alert {
  static confirm({
    String? title,
    double? width,
    AlertBuilder? builder,
    bool showCancel = true,
    VoidCallback? onCancel,
    bool showConfirm = true,
    VoidCallback? onConfirm,
    String cancelText = '取消',
    String confirmText = '确认',
    bool barrierDismissible = false,
  }) {
    assert(
      title != null || builder != null,
      'The parameters title and builder cannot be empty at the same time',
    );
    assert(
      !(title != null && builder != null),
      'The parameter title and builder cannot exist simultaneously',
    );

    AlertBuilder alertBuilder;
    if (title != null) {
      alertBuilder = (BuildContext context, CloseAlertFunction close) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 36.w, horizontal: 18.w),
          child: Text(
            title,
            style: TextStyle(height: 1, fontSize: 15.sp, color: const Color(0xFF333333)),
          ),
        );
      };
    } else {
      alertBuilder = builder!;
    }

    showDialog(
      useSafeArea: false,
      barrierDismissible: false,
      context: GlobalVars.context!,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return _AlertWidget(
          width: width,
          onClosed: () {
            Navigator.of(context).pop();
          },
          onCancel: onCancel,
          onConfirm: onConfirm,
          builder: alertBuilder,
          cancelText: cancelText,
          showCancel: showCancel,
          confirmText: confirmText,
          showConfirm: showConfirm,
          barrierDismissible: barrierDismissible,
        );
      },
    );
  }
}

class _AlertWidget extends StatefulWidget {
  final double? width;
  final bool showCancel;
  final bool showConfirm;
  final String cancelText;
  final String confirmText;
  final AlertBuilder builder;
  final VoidCallback onClosed;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final bool barrierDismissible;
  final Duration animationDuration;
  final Duration animationReverseDuration;

  const _AlertWidget({
    super.key,
    this.width,
    this.onCancel,
    this.onConfirm,
    required this.builder,
    required this.onClosed,
    this.showCancel = true,
    this.showConfirm = true,
    this.cancelText = '取消',
    this.confirmText = '确认',
    this.barrierDismissible = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationReverseDuration = const Duration(milliseconds: 200),
  });

  @override
  State<_AlertWidget> createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<_AlertWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.forward();

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> willClose() async {
    _controller.reverseDuration = widget.animationReverseDuration;
    await _controller.reverse();
    widget.onClosed();
  }

  Matrix4 onTransform(double value) {
    return Matrix4Tween(
      begin:
          _controller.status == AnimationStatus.forward
              ? Matrix4.compose(
                Vector3(0, -100, 0),
                Quaternion.fromRotation(Matrix3.zero()),
                Vector3(0.7, 0.7, 1),
              )
              : Matrix4.identity(),
      end: Matrix4.identity(),
    ).lerp(value);
  }

  Future<void> handleCancel() async {
    _controller.reverseDuration = widget.animationReverseDuration;
    await _controller.reverse();
    if (widget.onCancel != null) widget.onCancel!();
    widget.onClosed();
  }

  void handleConfirm() async {
    _controller.reverseDuration = widget.animationReverseDuration;
    await _controller.reverse();
    if (widget.onConfirm != null) widget.onConfirm!();
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final boxWidth = widget.width ?? 294.w;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: const Alignment(0, -0.1),
        children: [
          Positioned.fill(
            child: FadeTransition(
              opacity: _animation,
              child: GestureDetector(
                onTap: () {
                  if (widget.barrierDismissible) handleCancel();
                },
                child: Container(
                  constraints: BoxConstraints.tight(size),
                  color: Colors.black.withAlpha(opacity2Alpha(0.3)),
                ),
              ),
            ),
          ),
          Positioned(
            width: boxWidth,
            child: FadeTransition(
              opacity: _animation,
              child: MatrixTransition(
                animation: _animation,
                onTransform: onTransform,
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(blurRadius: 6, offset: Offset(0, 0), color: Color(0xFFF1FBF5)),
                    ],
                  ),
                  // padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // IntrinsicHeight(child: widget.builder(context, handleCancel)),
                      widget.builder(context, handleCancel),

                      /// footer
                      Container(
                        margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 20.w),
                        height: 36.w,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                              widget.showConfirm && widget.showCancel
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.showCancel
                                ? ElevatedButton(
                                  onPressed: handleCancel,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(120.w, 36.w),
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    overlayColor: Theme.of(context).primaryColorDark,
                                    side: const BorderSide(width: 1, color: Color(0xFF666666)),
                                  ),
                                  child: Text(
                                    widget.cancelText,
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 13.sp,
                                      color: const Color(0xFF4A4A4A),
                                    ),
                                  ),
                                )
                                : const SizedBox(),
                            widget.showConfirm
                                ? ElevatedButton(
                                  onPressed: handleConfirm,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    fixedSize: Size(120.w, 36.w),
                                    shadowColor: Colors.transparent,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    backgroundColor: Theme.of(context).primaryColor,
                                    overlayColor: Theme.of(context).primaryColorDark,
                                  ),
                                  child: Text(
                                    widget.confirmText,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      height: 1,
                                    ),
                                  ),
                                )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
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
