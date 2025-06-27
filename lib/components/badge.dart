import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';

class BadgeWidget extends StatelessWidget {
  final String type;
  final String title;
  final bool feedback;
  final double? width;
  final double? radius;
  final VoidCallback? onTap;

  /// size 可以是 default（28pt）、small（20pt）
  final String size;

  const BadgeWidget({
    super.key,
    this.onTap,
    this.width,
    this.radius,
    required this.title,
    this.feedback = true,
    this.size = 'default',
    this.type = 'primary',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: () {
        if (onTap is Function) {
          if (feedback) UserTapFeedback.selection();
          onTap!();
        }
      },
      child: IntrinsicWidth(
        child: AnimatedContainer(
          width: width,
          alignment: Alignment.center,
          height: size == 'default' ? 28.w : 20.w,
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
          constraints: BoxConstraints(minWidth: width == null ? 80.w : 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius ?? 6.w),
            border: Border.all(color: type == 'primary' ? primaryColor : const Color(0xFF999999)),
          ),
          child: Text(
            title,
            style: TextStyle(
              height: 1,
              fontSize: size == 'default' ? 13.sp : 12.sp,
              color: type == 'primary' ? primaryColor : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }
}
