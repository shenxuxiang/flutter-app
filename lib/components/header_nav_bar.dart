import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class HeaderNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const HeaderNavBar({super.key, required this.title, this.actions, this.bottom, this.onBack});

  @override
  get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  navigateBack() {
    if (onBack == null) {
      Get.back();
    } else {
      onBack!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      bottom: bottom,
      actions: actions,
      title: Text(title),
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      leading: GestureDetector(
        onTap: navigateBack,
        child: Container(
          color: Colors.transparent,
          child: Icon(QmIcons.back, color: const Color(0xFF333333), size: 24),
        ),
      ),
    );
  }
}
