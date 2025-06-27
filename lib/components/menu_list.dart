import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemOption {
  final String icon;
  final String title;
  final dynamic link;

  const MenuItemOption({required this.icon, required this.title, this.link});

  factory MenuItemOption.fromJson(Map<String, dynamic> json) =>
      MenuItemOption(icon: json['icon'], title: json['title'], link: json['link']);
}

class _MenuItem extends StatelessWidget {
  final MenuItemOption value;

  const _MenuItem({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (value.link == null) return;
        if (value.link is Function) {
          value.link.call();
        } else if (value.link is String && value.link.isNotEmpty) {
          Get.toNamed(value.link);
        }
      },
      child: Container(
        color: Colors.transparent,
        width: 32.w,
        height: 55.w,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Image.asset(value.icon, width: 32.w, height: 32.w, fit: BoxFit.cover),
            Positioned(
              bottom: 0,
              child: Text(
                value.title,
                style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF4A4A4A)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuListWidget extends StatelessWidget {
  final List<MenuItemOption> menus;

  const MenuListWidget({super.key, required this.menus});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(horizontal: 29.w, vertical: 20.w),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Wrap(
        spacing: 50.w,
        runSpacing: 24.w,
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.spaceBetween,
        children: [for (final menu in menus) _MenuItem(value: menu)],
      ),
    );
  }
}
