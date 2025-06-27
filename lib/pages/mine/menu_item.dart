import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final String icon;
  final dynamic link;
  final String title;

  const MenuItem({super.key, required this.title, required this.icon, required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (link is String) {
          Get.toNamed(link);
        } else if (link is Function) {
          link.call();
        }
      },
      child: Container(
        width: 43.w,
        height: 40.w,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: Image.asset(width: 24.w, height: 24.w, icon, fit: BoxFit.cover),
            ),
            Positioned(
              top: 29,
              child: Text(
                title,
                style: TextStyle(fontSize: 12.sp, height: 1, color: const Color(0xFF4A4A4A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
