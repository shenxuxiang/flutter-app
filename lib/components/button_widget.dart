import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool enableFeedback;
  final double? height;
  final double? width;
  final bool disabled;
  final Widget? child;
  final double radius;
  final String? text;
  final String type;
  final bool ghost;

  ButtonWidget({
    super.key,
    this.text,
    this.child,
    this.onTap,
    this.width,
    this.height,
    this.radius = 4,
    this.ghost = false,
    this.type = 'primary',
    this.disabled = false,
    this.enableFeedback = true,
  }) : assert(() {
         if (text != null && child != null) {
           return false;
         } else {
           return true;
         }
       }());

  void handleTap() {
    if (disabled) return;
    if (enableFeedback) UserTapFeedback.selection();
    if (onTap is Function) onTap!();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (ghost) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 36.w,
        child: OutlinedButton(
          onPressed: handleTap,
          style: OutlinedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            overlayColor: disabled ? Colors.transparent : themeData.primaryColorDark,
            side: BorderSide(
              color:
                  disabled
                      ? const Color(0xFFCCCCCC)
                      : type == 'default'
                      ? const Color(0xFF666666)
                      : themeData.primaryColor,
            ),
          ),
          child:
              child ??
              Text(
                text!,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                  color:
                      disabled
                          ? const Color(0xFF999999)
                          : type == 'default'
                          ? const Color(0xFF4A4A4A)
                          : themeData.primaryColor,
                ),
              ),
        ),
      );
    } else {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 36.w,
        child: ElevatedButton(
          onPressed: handleTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            overlayColor: disabled ? Colors.transparent : themeData.primaryColorDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
            backgroundColor: disabled ? themeData.disabledColor : themeData.primaryColor,
          ),
          child:
              child ??
              Text(
                text!,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
        ),
      );
    }
  }
}
