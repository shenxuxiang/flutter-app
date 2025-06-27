import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/list_selector.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class SelectFarmDropdown extends StatefulWidget {
  final ListItemOption? value;
  final List<ListItemOption> farmList;
  final void Function(ListItemOption value) onChanged;

  const SelectFarmDropdown({
    super.key,
    this.value,
    required this.farmList,
    required this.onChanged,
  });

  @override
  State<SelectFarmDropdown> createState() => _SelectFarmDropdownState();
}

class _SelectFarmDropdownState extends State<SelectFarmDropdown> {
  final isShow = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ListSelector(
      value: widget.value,
      options: widget.farmList,
      onChanged: widget.onChanged,
      onOpenChanged: (bool opened) => isShow.value = opened,
      builder: (BuildContext context) {
        return ButtonWidget(
          ghost: true,
          width: 120.w,
          height: 28.w,
          radius: 14.w,
          child: Row(
            children: [
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  widget.value?.label ?? '我的农场',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, height: 1, color: primaryColor),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: isShow,
                builder: (BuildContext context, isShow, Widget? child) {
                  return AnimatedRotation(
                    curve: Curves.ease,
                    turns: isShow ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: child,
                  );
                },
                child: Icon(QmIcons.down, size: 21.sp, color: primaryColor),
              ),
              SizedBox(width: 8.w),
            ],
          ),
        );
      },
    );
  }
}
