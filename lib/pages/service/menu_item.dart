import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final String img;
  final dynamic link;
  final String title;
  final double width;
  final double height;

  const MenuItem({
    super.key,
    this.link,
    required this.img,
    required this.title,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (link is String) {
          Get.toNamed(link!);
        } else if (link is Function) {
          link.call();
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(img, width: 32.w, height: 32.w, fit: BoxFit.cover),
            SizedBox(height: 12.w),
            Text(
              title,
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF4A4A4A)),
            ),
          ],
        ),
      ),
    );
  }
}
