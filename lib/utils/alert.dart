import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Quaternion, Matrix3;
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:async';

typedef CloseAlertFunction = Future<void> Function();
typedef AlertBuilder = Widget Function(BuildContext context, CloseAlertFunction close);

class Alert {
  static confirm({
    String? title,
    double? width,
    AlertBuilder? content,
    VoidCallback? onCancel,
    bool showCancel = true,
    bool showConfirm = true,
    bool showActions = true,
    VoidCallback? onConfirm,
    String cancelText = '取消',
    String confirmText = '确认',
    bool barrierDismissible = true,
    Duration transitionDuration = const Duration(milliseconds: 200),
  }) {
    assert(
      title != null || content != null,
      'The parameters title and builder cannot be empty at the same time',
    );

    final titleWidget =
        title == null
            ? const SizedBox.shrink()
            : Padding(
              padding: EdgeInsets.symmetric(vertical: 36.w, horizontal: 18.w),
              child: Text(
                title,
                style: TextStyle(height: 1, fontSize: 15.sp, color: const Color(0xFF333333)),
              ),
            );

    Future<void> handleCancel() async {
      onCancel?.call();
      Navigator.of(GlobalVars.context!).pop();
    }

    handleConfirm() {
      onConfirm?.call();
      Navigator.of(GlobalVars.context!).pop();
    }

    showGeneralDialog(
      context: GlobalVars.context!,
      barrierColor: Colors.black45,
      barrierLabel: 'QM_ALERT_DIALOG',
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
      transitionBuilder: (_, _, _, child) => child,
      pageBuilder: (BuildContext context, Animation<double> a1, Animation<double> a2) {
        final boxWidth = width ?? 294.w;
        return PopScope(
          canPop: barrierDismissible,
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              alignment: const Alignment(0, -0.1),
              children: [
                Positioned(
                  width: boxWidth,
                  child: FadeTransition(
                    opacity: a1,
                    child: MatrixTransition(
                      animation: a1,
                      alignment: Alignment.topCenter,
                      onTransform: (_) => _onTransform(a1),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              offset: Offset(0, 0),
                              color: Color(0xFFF1FBF5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            titleWidget,
                            content == null
                                ? const SizedBox.shrink()
                                : content(context, handleCancel),

                            /// footer
                            showActions
                                ? Container(
                                  margin: EdgeInsets.fromLTRB(18.w, 0, 18.w, 20.w),
                                  height: 36.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        showConfirm && showCancel
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      showCancel
                                          ? ButtonWidget(
                                            width: 120.w,
                                            height: 36.w,
                                            radius: 18.w,
                                            ghost: true,
                                            type: ButtonMode.normal,
                                            onTap: handleCancel,
                                            child: Text(
                                              cancelText,
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 13.sp,
                                                color: const Color(0xFF4A4A4A),
                                              ),
                                            ),
                                          )
                                          : const SizedBox(),
                                      showConfirm
                                          ? ButtonWidget(
                                            width: 120.w,
                                            height: 36.w,
                                            radius: 18.w,
                                            onTap: handleConfirm,
                                            child: Text(
                                              confirmText,
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
                                )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Matrix4 _onTransform(Animation<double> animation) {
    return Matrix4Tween(
      begin:
          animation.status == AnimationStatus.forward
              ? Matrix4.compose(
                Vector3(0, -100, 0),
                Quaternion.fromRotation(Matrix3.zero()),
                Vector3(0.6, 0.6, 1),
              )
              : Matrix4.identity(),
      end: Matrix4.identity(),
    ).evaluate(animation);
  }
}
