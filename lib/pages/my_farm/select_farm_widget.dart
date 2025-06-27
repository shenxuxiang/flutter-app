import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/list_selector.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/models/my_farm.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/bottom_sheet.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class SelectFarmWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final ListItemOption? value;
  final void Function(ListItemOption input) onChanged;

  const SelectFarmWidget({
    super.key,
    this.value,
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final myFarmModel = Get.find<MyFarmModel>();
    final farmList = myFarmModel.farmList;

    return ListSelector(
      value: value,
      onChanged: onChanged,
      options: farmList.value,
      builder: (BuildContext context) {
        return Container(
          height: 48.5.w,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4A4A4A), height: 1),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  value == null ? '请选择' : value!.label,
                  maxLines: 1,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    color: value == null ? const Color(0xFF999999) : const Color(0xFF333333),
                  ),
                ),
              ),
              Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF333333)),
            ],
          ),
        );
      },
    );
  }
}
