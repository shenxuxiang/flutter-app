import 'loading.dart';
import 'drawer_modal.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/models/publish.dart';
import 'package:qm_agricultural_machinery_services/components/badge.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_category.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_sub_category.dart';

/// 发布状态
const publishStatusList = [
  ListItemOption(label: '全部', value: ''),
  ListItemOption(label: '已发布', value: '1'),
  ListItemOption(label: '已下架', value: '2'),
];

/// 大类
const defaultDemandCategory = DemandCategory(demandCategoryId: '', demandName: '全部');

/// 小类
const defaultDemandSubCategory = DemandSubCategory(
  demandSubcategoryId: '',
  demandSubcategoryName: '全部',
);

/// 首页-我的-我的需求-【筛选】
class FilterDemandDrawerModal {
  static show({
    BuildContext? context,
    ListItemOption? publishStatus,
    DemandCategory? demandCategory,
    DemandSubCategory? demandSubCategory,
    Function(Map<String, dynamic> data)? onChanged,
  }) async {
    final ctx = context ?? GlobalVars.context!;
    final releaseModel = Get.find<PublishModel>();

    /// 所有大类-副本
    final categoryListCopy = List.of(releaseModel.demandCategoryList.value);

    /// 所有子类列表
    final List<DemandSubCategory> allSubCategoryList = [];
    for (final item in categoryListCopy) {
      allSubCategoryList.addAll(item.children!);
    }

    /// 所有大类副本中添加【全部】
    categoryListCopy.insert(
      0,
      DemandCategory(demandCategoryId: '', demandName: '全部', children: allSubCategoryList),
    );

    final selectedCategory = Rx<DemandCategory?>(demandCategory);
    final selectedPublishStatus = Rx<ListItemOption?>(publishStatus);
    final selectedSubCategory = Rx<DemandSubCategory?>(demandSubCategory);

    /// 选择大类
    handleSelectCategory(DemandCategory category) {
      selectedCategory.value = category;
    }

    handleSelectSubCategory(DemandSubCategory? subCategory) {
      selectedSubCategory.value = subCategory;
    }

    handleSelectReleaseStatus(ListItemOption status) {
      selectedPublishStatus.value = status;
    }

    onConfirm() {
      final params = {
        'demandCategory': selectedCategory.value,
        'status': selectedPublishStatus.value,
        'demandSubCategory': selectedSubCategory.value,
      };

      onChanged?.call(params);
    }

    onReset() {
      final params = {'status': null, 'demandCategory': null, 'demandSubcategory': null};

      onChanged?.call(params);
    }

    DrawerModal.show(
      context: ctx,
      title: '筛选需求',
      onReset: onReset,
      onConfirm: onConfirm,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '需求大类',
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666)),
            ),
            SizedBox(height: 12.w),
            Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.w,
                children: [
                  for (final item in categoryListCopy)
                    BadgeWidget(
                      radius: 14.w,
                      title: item.demandName,
                      onTap: () => handleSelectCategory(item),
                      type:
                          item.demandCategoryId == (selectedCategory.value?.demandCategoryId ?? '')
                              ? 'primary'
                              : 'default',
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.w),

            Text(
              '需求小类',
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666)),
            ),
            SizedBox(height: 12.w),
            Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.w,
                children: [
                  BadgeWidget(
                    radius: 14.w,
                    title: '全部',
                    onTap: () => handleSelectSubCategory(null),
                    type:
                        selectedSubCategory.value?.demandSubcategoryId.isEmpty ?? true
                            ? 'primary'
                            : 'default',
                  ),
                  for (DemandSubCategory item
                      in selectedCategory.value?.children ?? allSubCategoryList)
                    BadgeWidget(
                      radius: 14.w,
                      title: item.demandSubcategoryName,
                      onTap: () => handleSelectSubCategory(item),
                      type:
                          item.demandSubcategoryId == selectedSubCategory.value?.demandSubcategoryId
                              ? 'primary'
                              : 'default',
                    ),
                ],
              ),
            ),
            SizedBox(height: 20.w),
            Text(
              '发布状态',
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF666666)),
            ),
            SizedBox(height: 12.w),
            Obx(
              () => Wrap(
                spacing: 12.w,
                runSpacing: 12.w,
                children: [
                  for (final item in publishStatusList)
                    BadgeWidget(
                      radius: 14.w,
                      title: item.label,
                      onTap: () => handleSelectReleaseStatus(item),
                      type:
                          item.value == (selectedPublishStatus.value?.value ?? '')
                              ? 'primary'
                              : 'default',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
