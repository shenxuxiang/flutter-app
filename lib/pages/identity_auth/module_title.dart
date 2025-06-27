import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModuleTitle extends StatelessWidget {
  final String title;

  const ModuleTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.w,
          decoration: const BoxDecoration(
            color: Color(0xFF3AC786),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
        SizedBox(width: 6.w),
        Text(title, style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4A4A4A), height: 1)),
      ],
    );
  }
}
