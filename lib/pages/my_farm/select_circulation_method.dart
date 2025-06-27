import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';

const _methodList = [
  ListItemOption(value: '出租（转包）', label: '出租'),
  ListItemOption(value: '入股', label: '入股'),
];

class SelectCirculationMethodWidget extends StatelessWidget {
  final ListItemOption? value;
  final void Function(ListItemOption? value) onChanged;

  const SelectCirculationMethodWidget({super.key, this.value, required this.onChanged});

  void handleOpenModal(BuildContext context) async {
    /// 隐藏软键盘
    FocusScope.of(context).unfocus();
    final checked = Rx<ListItemOption?>(value);

    Alert.confirm(
      barrierDismissible: true,
      builder: (BuildContext context, VoidCallback onClose) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 16.w, 0, 20.w),
          child: Column(
            children: [
              Text('请选择流转方式', style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 10.w),
              Container(
                height: 24.w,
                margin: EdgeInsets.fromLTRB(20.w, 12.w, 20.w, 22.w),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (final method in _methodList)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            method.label,
                            style: TextStyle(
                              height: 1,
                              fontSize: 16.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Obx(
                            () => CheckboxWidget(
                              size: 21.sp,
                              ghost: true,
                              radius: 11.w,
                              checked: checked.value?.value == method.value,
                              onChanged: (check) {
                                if (check) checked.value = method;
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
            ],
          ),
        );
      },
      onConfirm: () {
        onChanged(checked.value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) handleOpenModal(context);
      },
      child: GestureDetector(
        onTap: () => handleOpenModal(context),
        child: Container(
          height: 48.5.w,
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
          ),
          child: Row(
            children: [
              Text(
                '流转方式',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF4A4A4A), height: 1),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  value == null ? '请选择流转方式' : value!.label,
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
        ),
      ),
    );
  }
}
