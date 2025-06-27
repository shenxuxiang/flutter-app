import 'drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class DrawerModal {
  static show({
    BuildContext? context,
    required Widget child,
    required String title,
    VoidCallback? onReset,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
  }) {
    final ctx = context ?? GlobalVars.context!;

    QmDrawer.show(
      width: 290.w,
      builder: (BuildContext context, VoidCallback closeModal) {
        return _DrawerModalContent(
          title: title,
          onReset: onReset,
          close: closeModal,
          onCancel: onCancel,
          onConfirm: onConfirm,
          child: child,
        );
      },
    );
  }
}

class _DrawerModalContent extends StatelessWidget {
  final String title;
  final Widget? child;
  final VoidCallback close;
  final VoidCallback? onReset;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const _DrawerModalContent({
    super.key,
    this.child,
    this.onReset,
    this.onCancel,
    this.onConfirm,
    required this.close,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 44.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (onCancel is Function) onCancel!();
                  close();
                },
                child: Icon(QmIcons.close, size: 18.sp, color: const Color(0xFF333333)),
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFFE0E0E0), height: 1),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.w),
            child: child,
          ),
        ),
        Container(
          height: 49.w,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.33), blurRadius: 2),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonWidget(
                width: 120.w,
                height: 36.w,
                radius: 18.w,
                ghost: true,
                text: '重置',
                type: 'default',
                onTap: () {
                  if (onReset is Function) onReset!();
                  close();
                },
              ),
              ButtonWidget(
                width: 120.w,
                height: 36.w,
                radius: 18.w,
                text: '确定',
                onTap: () {
                  if (onConfirm is Function) onConfirm!();
                  close();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
