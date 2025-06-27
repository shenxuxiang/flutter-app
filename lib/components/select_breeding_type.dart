import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/badge.dart';
import 'package:qm_agricultural_machinery_services/utils/bottom_sheet.dart';
import 'package:qm_agricultural_machinery_services/entity/breeding_type.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryBreedingTypeTreeList;

import 'form_item.dart';

class SelectBreedingTypeWidget extends StatefulWidget {
  final String label;
  final bool bordered;
  final bool disabled;
  final String hintText;
  final List<BreedingType> value;
  final void Function(List<BreedingType> input) onChanged;

  const SelectBreedingTypeWidget({
    super.key,
    required this.label,
    required this.value,
    this.bordered = true,
    this.disabled = false,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<SelectBreedingTypeWidget> createState() => _SelectBreedingTypeWidgetState();
}

class _SelectBreedingTypeWidgetState extends State<SelectBreedingTypeWidget> {
  void handleOpenModal() async {
    if (widget.disabled) return;

    /// 隐藏软键盘
    FocusScope.of(context).unfocus();

    final mainModel = Get.find<MainModel>();
    if (mainModel.breadingTypeTreeList.value.isEmpty) {
      final closeLoading = Loading.show(message: '数据加载中');
      try {
        final resp = await queryBreedingTypeTreeList();
        mainModel.setBreadingTypeTreeList(resp.data);
      } catch (error, stack) {
        printLog(error);
        printLog(stack);
      }

      closeLoading();
    }

    final selectedBreedTypeList = Rx<List<BreedingType>>(List.of(widget.value));

    QmBottomSheet.show(
      height: 400.w,
      builder: (BuildContext context, VoidCallback onClose) {
        return Container(
          height: 400.w,
          color: Colors.white,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48.5.w,
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFE0E0E0))),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: onClose,
                        child: Text(
                          '取消',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF666666),
                            height: 2,
                          ),
                        ),
                      ),
                      Text(
                        '选择种养殖类型',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                          height: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedBreedTypeList.value.isEmpty) {
                            Toast.warning('请选择种养殖类型');
                            return;
                          }
                          onClose();
                          widget.onChanged(selectedBreedTypeList.value);
                        },
                        child: Text(
                          '确定',
                          style: TextStyle(
                            height: 2,
                            fontSize: 14.sp,
                            color: const Color(0xFF3AC786),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final item in mainModel.breadingTypeTreeList.value)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 26.w),
                                Text(
                                  item.breedingTypeName,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 12.w),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 12.w,
                                  runSpacing: 12.w,
                                  children: [
                                    for (BreedingType it in item.children ?? [])
                                      BadgeWidget(
                                        title: it.breedingTypeName,
                                        type:
                                            selectedBreedTypeList.value
                                                    .map((item) => item.breedingTypeId)
                                                    .contains(it.breedingTypeId)
                                                ? 'primary'
                                                : 'default',
                                        onTap: () {
                                          final ids =
                                              selectedBreedTypeList.value
                                                  .map((item) => item.breedingTypeId)
                                                  .toList();

                                          if (ids.contains(it.breedingTypeId)) {
                                            selectedBreedTypeList.update((list) {
                                              list?.removeWhere(
                                                (breedType) =>
                                                    breedType.breedingTypeId == it.breedingTypeId,
                                              );
                                            });
                                          } else {
                                            selectedBreedTypeList.update((list) => list?.add(it));
                                          }
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 12.w),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: widget.label,
      height: 48.5.w,
      bordered: widget.bordered,
      onTap: () => handleOpenModal(),
      suffix:
          widget.disabled
              ? null
              : Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF333333)),
      child: Text(
        widget.value.isEmpty
            ? widget.hintText
            : widget.value.map((item) => item.breedingTypeName).join(', '),
        maxLines: 1,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: 1.5,
          fontSize: 14.sp,
          color: widget.value.isEmpty ? const Color(0xFF999999) : const Color(0xFF333333),
        ),
      ),
    );
  }
}
