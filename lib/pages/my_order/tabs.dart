import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItem {
  final int key;
  final String label;
  final int? status;

  const TabItem({required this.key, required this.label, this.status});
}

class Tabs extends StatelessWidget {
  final int activeKey;
  final List<TabItem> tabList;
  final void Function(int key) onChanged;

  const Tabs({super.key, required this.activeKey, required this.tabList, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final item in tabList)
                GestureDetector(
                  onTap: () => onChanged(item.key),
                  child: Container(
                    width: 56.w,
                    height: 30.w,
                    padding: EdgeInsets.only(top: 12.w),
                    child: Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1,
                        fontSize: 13.w,
                        color:
                            activeKey == item.key
                                ? const Color(0xFF333333)
                                : const Color(0xFF666666),
                        fontWeight: activeKey == item.key ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 336.w,
            height: 6.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 200),
                    offset: Offset(activeKey.toDouble(), 0),
                    child: SizedBox(
                      width: 56.w,
                      child: Center(
                        child: Container(
                          width: 20.w,
                          height: 2.w,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ),
                    ),
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
