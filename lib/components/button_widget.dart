import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

enum ButtonMode { primary, danger, normal }

class _ButtonModeColor {
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final Color overlayColor;

  const _ButtonModeColor({
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.overlayColor,
  });
}

const _defaultMode = _ButtonModeColor(
  bgColor: Colors.white,
  color: Color(0xFF4A4A4A),
  borderColor: Color(0xFF666666),
  overlayColor: Color(0xFF000000),
);

const _dangerMode = _ButtonModeColor(
  color: Color(0xFFFF4D4F),
  bgColor: Color(0xFFFF4D4F),
  borderColor: Color(0xFFFF4D4F),
  overlayColor: Color(0xFFFF4D4F),
);

class ButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool enableFeedback;
  final ButtonMode type;
  final double? height;
  final double? width;
  final bool disabled;
  final Widget? child;
  final double radius;
  final String? text;
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
    this.disabled = false,
    this.enableFeedback = true,
    this.type = ButtonMode.primary,
  }) : assert(() {
         if (text != null && child != null) {
           return false;
         } else {
           return true;
         }
       }());

  void _handleTap() {
    if (disabled) return;
    if (enableFeedback) UserTapFeedback.selection();
    if (onTap is Function) onTap!();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Container(
      height: height ?? 36.w,
      width: width ?? double.infinity,
      foregroundDecoration: BoxDecoration(
        color: disabled ? Colors.white54 : Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child:
          ghost
              ? OutlinedButton(
                onPressed: _handleTap,
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
                  overlayColor:
                      type == ButtonMode.primary
                          ? themeData.primaryColorDark
                          : type == ButtonMode.danger
                          ? _dangerMode.overlayColor
                          : _defaultMode.overlayColor,
                  side: BorderSide(
                    color:
                        type == ButtonMode.primary
                            ? themeData.primaryColor
                            : type == ButtonMode.danger
                            ? _dangerMode.borderColor
                            : _defaultMode.borderColor,
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
                            type == ButtonMode.primary
                                ? themeData.primaryColor
                                : type == ButtonMode.danger
                                ? _dangerMode.color
                                : _defaultMode.color,
                      ),
                    ),
              )
              : ElevatedButton(
                onPressed: _handleTap,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shadowColor: Colors.transparent,
                  overlayColor: const Color(0xFF000000),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
                  backgroundColor: type == 'danger' ? _dangerMode.bgColor : themeData.primaryColor,
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
