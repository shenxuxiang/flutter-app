import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/date_picker.dart';

class SelectServerTime extends StatelessWidget {
  final DateTime? serverTime;
  final void Function(DateTime? date) onChanged;

  const SelectServerTime({super.key, required this.onChanged, this.serverTime});

  renderServerTime(DateTime time) {
    int year = time.year;
    String month = '${time.month}'.padLeft(2, '0');
    String day = '${time.day}'.padLeft(2, '0');
    String hour = '${time.hour}'.padLeft(2, '0');
    String minute = '${time.minute}'.padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }

  handleOpenDatePicker() {
    DatePicker.showDateTimePicker(dateTime: serverTime, onConfirm: onChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.w,
      margin: EdgeInsets.only(top: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '期望服务时间',
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1),
          ),
          GestureDetector(
            onTap: handleOpenDatePicker,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  serverTime == null ? '请选择时间' : renderServerTime(serverTime!),
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    color: serverTime == null ? const Color(0xFF999999) : const Color(0xFF333333),
                  ),
                ),
                Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF999999)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
