import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/farm_list_selector.dart';

class HeaderWidget extends StatelessWidget {
  final String regionName;
  final ListItemOption? selectedFarm;
  final List<ListItemOption> farmList;
  final void Function(ListItemOption value) onChanged;

  const HeaderWidget({
    super.key,
    this.selectedFarm,
    required this.farmList,
    required this.onChanged,
    required this.regionName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(QmIcons.location, size: 22.sp, color: const Color(0xFF333333)),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              regionName,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4A4A4A), height: 1),
            ),
          ),
          SelectFarmDropdown(farmList: farmList, value: selectedFarm, onChanged: onChanged),
        ],
      ),
    );
  }
}
