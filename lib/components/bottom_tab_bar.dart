import 'tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItem {
  final int key;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const TabItem({
    required this.key,
    required this.icon,
    required this.label,
    required this.activeIcon,
  });
}

class BottomTabBar extends StatelessWidget {
  final int activeKey;
  final List<TabItem> tabs;
  final void Function(int key) onChanged;

  const BottomTabBar({
    super.key,
    required this.tabs,
    required this.onChanged,
    required this.activeKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F8F8),
        boxShadow: [BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -1), blurRadius: 2)],
      ),
      height: 49.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final tab in tabs)
            GestureDetector(
              onTap: () {
                onChanged(tab.key);
              },
              child: TabItemWidget(
                icon: tab.icon,
                title: tab.label,
                activeIcon: tab.activeIcon,
                isActive: tab.key == activeKey,
              ),
            ),
        ],
      ),
    );
  }
}
