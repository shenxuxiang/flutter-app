import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _specialists = [
  {'title': '高级农艺师', 'name': '肖建彬', 'avatar': 'assets/images/technology/avatar_1.png'},
  {'title': '农业技术推广研究员', 'name': '代金锋', 'avatar': 'assets/images/technology/avatar_3.png'},
  {'title': '农艺师', 'name': '李舒瑶', 'avatar': 'assets/images/technology/avatar_2.png'},
];

class SpecialistModule extends StatelessWidget {
  const SpecialistModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124.w,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 21.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final item in _specialists)
            SizedBox(
              width: 64.w,
              height: 92.w,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 0,
                    child: ClipOval(
                      child: Image.asset(
                        width: 52.w,
                        height: 52.w,
                        fit: BoxFit.cover,
                        item['avatar']!,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 61.w,
                    child: Text(
                      item['name']!,
                      style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1),
                    ),
                  ),
                  Positioned(
                    top: 81.w,
                    child: Text(
                      item['title']!,
                      style: TextStyle(fontSize: 11.sp, color: const Color(0xFF666666), height: 1),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
