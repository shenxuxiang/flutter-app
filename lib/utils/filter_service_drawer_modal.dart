import 'drawer_modal.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/badge.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/utils/bottom_sheet.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/entity/service_filter_type.dart';
import 'package:qm_agricultural_machinery_services/components/cascader/cascader.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/input_number.dart';

/// 首页-服务-农资服务-【筛选】
class FilterConditional {
  final ServiceFilterType? type;
  final List<String> rangePrice;
  final List<SelectedTreeNode> region;

  const FilterConditional({required this.type, required this.region, required this.rangePrice});

  factory FilterConditional.fromJson(Map<String, dynamic> json) => FilterConditional(
    type: json['type'],
    region: _convertToSelectedTreeNode(json['region']),
    rangePrice: [json['startPrice'], json['endPrice']],
  );

  static List<SelectedTreeNode> _convertToSelectedTreeNode(dynamic data) {
    if (data is! List) return [];
    return data
        .map((item) => item is SelectedTreeNode ? item : SelectedTreeNode.fromJson(item))
        .toList();
  }
}

class FilterServiceDrawerModal {
  static show({
    Function(FilterConditional value)? onChanged,
    required List<SelectedTreeNode> region,
    required String categoryId,
    required String startPrice,
    required String endPrice,
    ServiceFilterType? type,
    BuildContext? context,
  }) {
    final mainModel = Get.find<MainModel>();
    final ctx = context ?? GlobalVars.context!;
    final primaryColor = Theme.of(ctx).primaryColor;
    final List<ServiceFilterType> filterTypeList = [
      const ServiceFilterType(label: '全部', value: ''),
    ];

    /// 在树中查找目标 ID 的资源。
    final nodeTree = findSourceTree(
      mainModel.serviceSubCategory.value,
      categoryId,
      'serviceSubcategoryId',
    );

    /// 遍历子节点，这就是我们要找的筛选项列表。
    for (final node in (nodeTree['children'] ?? [])) {
      filterTypeList.add(ServiceFilterType.fromJson(node));
    }

    final selectedRegion = Rx<List<SelectedTreeNode>>(region);
    final selectedType = Rx<ServiceFilterType?>(type);
    final minPrice = Rx<String>(startPrice);
    final maxPrice = Rx<String>(endPrice);

    renderFilterTypeModule() {
      if (filterTypeList.length > 1) {
        return [
          Text('类型', style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666))),
          SizedBox(height: 12.w),
          Obx(
            () => Wrap(
              spacing: 12.w,
              runSpacing: 12.w,
              children: [
                for (final item in filterTypeList)
                  BadgeWidget(
                    radius: 14.w,
                    title: item.label,
                    onTap: () {
                      selectedType.value = item;
                    },
                    type: item.value == (selectedType.value?.value ?? '') ? 'primary' : 'default',
                  ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
        ];
      } else {
        return [];
      }
    }

    handleChangeRegion() {
      /// 隐藏软键盘
      FocusScope.of(ctx).unfocus();
      final mainModel = Get.find<MainModel>();
      if (mainModel.regionSourceTree.value.isEmpty) {
        api.queryRegionSourceTree(5).then((resp) {
          mainModel.setRegionSourceTree(resp.data);
        });
      }

      QmBottomSheet.show(
        builder: (BuildContext context, VoidCallback onClose) {
          return Obx(() {
            return CasCader(
              value: selectedRegion.value,
              hintText: '请选择所在地区',
              onConfirm: (List<SelectedTreeNode> input) {
                selectedRegion.value = input;
                onClose();
              },
              sourceList: mainModel.regionSourceTree.value,
            );
          });
        },
        padding: EdgeInsets.zero,
      );
    }

    handleConfirm() {
      final params = {
        'type': selectedType.value,
        'endPrice': maxPrice.value,
        'startPrice': minPrice.value,
        'region': selectedRegion.value,
      };
      onChanged?.call(FilterConditional.fromJson(params));
    }

    handleReset() {
      final params = {'type': null, 'endPrice': '', 'startPrice': '', 'region': []};

      onChanged?.call(FilterConditional.fromJson(params));
    }

    DrawerModal.show(
      title: '筛选产品/服务',
      onReset: handleReset,
      onConfirm: handleConfirm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...renderFilterTypeModule(),
          Text(
            '价格区间（元）',
            style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666)),
          ),
          SizedBox(height: 12.sp),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 122.w,
                  child: InputNumber(
                    value: minPrice.value,
                    hintText: '最低价',
                    textAlign: TextAlign.center,
                    onChanged: (String input) => minPrice.value = input,
                  ),
                ),
                const Text('-', style: TextStyle(color: Color(0xFF999999))),
                SizedBox(
                  width: 122.w,
                  child: InputNumber(
                    value: maxPrice.value,
                    hintText: '最高价',
                    textAlign: TextAlign.center,
                    onChanged: (String input) => maxPrice.value = input,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          Text('地区', style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666))),
          SizedBox(height: 12.sp),
          Obx(
            () => Row(
              children: [
                Icon(QmIcons.location, size: 22.sp, color: const Color(0xFF999999)),
                Expanded(
                  child:
                      selectedRegion.value.isNotEmpty
                          ? Text(
                            selectedRegion.value.map((item) => item.label).join(''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          )
                          : GestureDetector(
                            onTap: handleChangeRegion,
                            child: Text(
                              '定位选择',
                              style: TextStyle(fontSize: 14.sp, color: primaryColor, height: 1),
                            ),
                          ),
                ),
                selectedRegion.value.isNotEmpty
                    ? GestureDetector(
                      onTap: handleChangeRegion,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '修改',
                          style: TextStyle(fontSize: 14.sp, color: primaryColor, height: 1),
                        ),
                      ),
                    )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
