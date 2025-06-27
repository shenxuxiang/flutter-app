import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class EmptyWidget extends StatelessWidget {
  final Color color;
  final String text;
  final double? size;

  const EmptyWidget({
    super.key,
    this.size,
    this.text = '暂无数据',
    this.color = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(QmIcons.empty, size: size ?? 40.w, color: color),
        SizedBox(height: 16.w),
        Text(text, style: TextStyle(height: 1, color: const Color(0xFF666666), fontSize: 14.sp)),
      ],
    );
  }
}
