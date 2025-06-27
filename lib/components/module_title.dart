import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class ModuleTitle extends StatelessWidget {
  final String title;
  final String? link;
  final double? spacing;

  const ModuleTitle({super.key, required this.title, this.link, this.spacing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 16.w, left: spacing ?? 12.w),
            child: Text(
              title,
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333), height: 1),
            ),
          ),
          link == null
              ? const SizedBox.shrink()
              : GestureDetector(
                onTap: () {
                  if (link?.isNotEmpty ?? false) Get.toNamed(link!);
                },
                child: Container(
                  height: 44.w,
                  color: Colors.transparent,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 16.w, right: spacing ?? 12.w, left: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('更多', style: TextStyle(color: const Color(0xFF4A4A4A), fontSize: 11.sp)),
                      Icon(QmIcons.forward, size: 16.sp, color: const Color(0xFF4A4A4A)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
