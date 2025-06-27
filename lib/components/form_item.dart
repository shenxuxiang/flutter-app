import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class FormItem extends StatelessWidget {
  final String? label;
  final String? value;
  final Widget? child;
  final bool bordered;
  final Widget? prefix;
  final Widget? suffix;
  final double? height;
  final bool isRequired;
  final TextAlign textAlign;
  final VoidCallback? onTap;

  const FormItem({
    super.key,
    this.label,
    this.onTap,
    this.value,
    this.child,
    this.height,
    this.suffix,
    this.prefix,
    this.bordered = true,
    this.isRequired = false,
    this.textAlign = TextAlign.end,
  }) : assert(
         child != null || value != null,
         'The parameter value and child cannot both be null at the same time',
       );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              bordered
                  ? const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5))
                  : null,
        ),
        child: Row(
          children: [
            prefix == null ? const SizedBox.shrink() : prefix!,
            label == null
                ? const SizedBox.shrink()
                : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: isRequired ? '* ' : '',
                        style: const TextStyle(color: Color(0xFFFF0000)),
                      ),
                      TextSpan(text: label),
                      WidgetSpan(child: SizedBox(width: 12.w)),
                    ],
                  ),
                  style: TextStyle(height: 1.5, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
                ),
            Expanded(
              child:
                  value != null
                      ? Text(
                        value!,
                        textAlign: textAlign,
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                        ),
                      )
                      : child!,
            ),
            suffix == null ? const SizedBox.shrink() : suffix!,
          ],
        ),
      ),
    );
  }
}
