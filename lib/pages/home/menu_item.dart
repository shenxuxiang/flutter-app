import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final String imgURL;
  final String title;
  final String? link;

  const MenuItem({super.key, required this.title, required this.imgURL, this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (link?.isEmpty ?? true) return;
        Get.toNamed(link!);
      },
      child: Container(
        color: Colors.transparent,
        width: 32.w,
        height: 55.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Image.asset(imgURL, width: 32.w, height: 32.w, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              child: Text(
                title,
                style: TextStyle(fontSize: 11.sp, height: 1, color: const Color(0xFF4A4A4A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
