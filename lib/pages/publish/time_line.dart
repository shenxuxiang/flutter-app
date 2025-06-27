import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeLine extends StatelessWidget {
  final int step;

  const TimeLine({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248.w,
      height: 50.w,
      margin: EdgeInsets.symmetric(horizontal: 56.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 13.w,
            child: Container(
              width: 150.w,
              height: 1.5.w,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width:
                      step >= 3
                          ? 150.w
                          : step >= 2
                          ? 120.w
                          : 30.w,
                  height: 1.5.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3AC786),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeLineStep(step: 1, title: '选择服务', completed: step >= 1),
              TimeLineStep(step: 2, title: '填写信息', completed: step >= 2),
              TimeLineStep(step: 3, title: '完成发布', completed: step >= 3),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeLineStep extends StatelessWidget {
  final int step;
  final String title;
  final bool completed;

  const TimeLineStep({super.key, required this.step, required this.title, required this.completed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 50.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 28.w,
              height: 28.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: completed ? const Color(0xFF3AC786) : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
                border: completed ? null : Border.all(width: 1, color: const Color(0xFF999999)),
              ),
              child: Text(
                '$step',
                style: TextStyle(
                  height: 1,
                  fontSize: 14.sp,
                  color: completed ? Colors.white : const Color(0xFF999999),
                ),
              ),
            ),
          ),
          Positioned(
            top: 37.w,
            child: Text(
              title,
              softWrap: false,
              style: TextStyle(
                height: 1,
                fontSize: 14.sp,
                color: completed ? const Color(0xFF333333) : const Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
