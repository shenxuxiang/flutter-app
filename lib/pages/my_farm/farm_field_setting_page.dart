import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/my_farm.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/models/my_farm.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/entity/breeding_type.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input.dart';
import 'package:qm_agricultural_machinery_services/components/select_region_widget.dart';
import 'package:qm_agricultural_machinery_services/components/select_breeding_type.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/select_farm_widget.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_date_range_picker.dart';
import 'package:qm_agricultural_machinery_services/pages/my_farm/select_circulation_method.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input_multiple_lines.dart';

const _signList = [ListItemOption(label: '是', value: '1'), ListItemOption(label: '否', value: '2')];

class FarmFieldSettingPage extends BasePage {
  const FarmFieldSettingPage({super.key, required super.author, required super.title});

  @override
  State<FarmFieldSettingPage> createState() => _FarmFieldSettingPageState();
}

class _FarmFieldSettingPageState extends BasePageState<FarmFieldSettingPage> {
  String area = '';
  String location = '';
  String fieldName = '';
  String farmFieldId = '';
  ListItemOption? selectedFarm; // 所属农场
  List<SelectedTreeNode> region = []; // 所在地区
  List<BreedingType> breedingTypeList = []; // 种养殖业

  String circulationPrice = ''; // 流转价格

  String circulationPeriod = ''; // 流转期限

  ListItemOption? circulationMethod; // 流转方式

  String circulationUse = ''; // 流转用途

  DateTime? endTime;

  DateTime? startTime;

  ListItemOption? contractSigned; // 是否签订合同

  final myFarmModel = Get.find<MyFarmModel>();

  @override
  onMounted() async {
    farmFieldId = Get.parameters['id']!;
    CloseLoading closeLoading = Loading.show();

    try {
      final resp = await queryFarmFieldDetail(farmFieldId);
      final detail = resp.data;

      location = detail['location'] ?? '';
      fieldName = detail['fieldName'] ?? '';
      area = detail['area']?.toString() ?? '';
      circulationUse = detail['circulationUse'] ?? '';
      circulationPrice = detail['circulationPrice']?.toString() ?? '';
      circulationPeriod = detail['circulationPeriod']?.toString() ?? '';

      /// 流转年份（开始时间、结束时间）
      startTime =
          detail['circulationStartDate']?.isEmpty ?? true
              ? null
              : DateTime.parse(detail['circulationStartDate']);
      endTime =
          detail['circulationEndDate']?.isEmpty ?? true
              ? null
              : DateTime.parse(detail['circulationEndDate']);

      /// 流转方式
      final circulationMethodName = detail['circulationMethodName'];
      circulationMethod =
          circulationMethodName == null
              ? null
              : ListItemOption(label: circulationMethodName, value: circulationMethodName);

      /// 是否签订合同（1-是，2-否）
      final signed = detail['contractSigned'] ?? 2;
      contractSigned = ListItemOption(label: signed == 1 ? '是' : '否', value: '$signed');

      /// 所属农场
      final targetFarm = myFarmModel.farmList.value.where((farm) => farm.value == detail['farmId']);
      selectedFarm = targetFarm.isEmpty ? null : targetFarm.first;

      /// 种养殖业
      final breedingTypeIdList = detail['breedingTypeIdList'] ?? [];
      if (breedingTypeIdList.isNotEmpty) {
        final breedingTypeNameList = detail['breedingTypeNames']?.split(',') ?? [];
        for (int i = 0; i < breedingTypeNameList.length; i++) {
          breedingTypeList.add(
            BreedingType(
              breedingTypeId: breedingTypeIdList![i],
              breedingTypeName: breedingTypeNameList[i],
            ),
          );
        }
      }

      /// 根据 regionCode 计算完成的省市区县
      final regions = await getParentRegions(detail['regionCode']);
      region = regions ?? [];

      setState(() {});
    } finally {
      closeLoading();
    }
  }

  /// 地块名称
  handleInputChangeFieldName(String input) {
    setState(() {
      fieldName = input;
    });
  }

  handleInputChangeArea(String input) {
    setState(() {
      area = input;
    });
  }

  /// 更新所在地区
  onChangeRegion(List<SelectedTreeNode> regions) {
    setState(() {
      region = regions;
    });
  }

  /// 种养殖业
  handleInputChangeBreedingTypeList(List<BreedingType> input) {
    setState(() {
      breedingTypeList = input;
    });
  }

  /// 选择农场
  handleInputChangeSelectFarm(ListItemOption input) {
    setState(() {
      selectedFarm = input;
    });
  }

  /// 流转价格
  handleInputChangeCirculationPrice(String input) {
    setState(() {
      circulationPrice = input.replaceAll(RegExp(r'[^0-9.]'), '');
    });
  }

  /// 流转期限
  handleInputChangeCirculationPeriod(String input) {
    setState(() {
      circulationPeriod = input.replaceAll(RegExp(r'[^0-9]'), '');
    });
  }

  /// 流转年份（开始时间-结束时间）
  handleInputChangeDate([DateTime? start, DateTime? end]) {
    setState(() {
      endTime = end;
      startTime = start;
    });
  }

  /// 流转方式
  handleInputChangeCirculationMethod(ListItemOption? input) {
    setState(() {
      circulationMethod = input;
    });
  }

  /// 流转用途
  handleInputChangeCirculationUse(String input) {
    setState(() {
      circulationUse = input;
    });
  }

  handleSave() async {
    if (circulationPrice.isNotEmpty &&
        !RegExp(r'(^0(\.[0-9]+)?$|^[1-9][0-9]*\.?[0-9]*$)').hasMatch(circulationPrice)) {
      Toast.warning('流转价格输入格式不正确');
      return;
    }

    CloseLoading closeLoading = Loading.show();

    try {
      final params = {
        // 'area': area,
        'fieldName': fieldName,
        'farmFieldId': farmFieldId,
        'farmId': selectedFarm?.value,
        'circulationUse': circulationUse,
        'circulationPrice': circulationPrice,
        'circulationPeriod': circulationPeriod,
        'contractSigned': contractSigned?.value,
        'circulationMethodName': circulationMethod?.value,
        'regionCode': region.isEmpty ? null : region.last.value,
        'regionName': region.isEmpty ? null : region.last.label,
        'circulationEndDate': endTime?.toString().substring(0, 10),
        'circulationStartDate': startTime?.toString().substring(0, 10),
        'breedingTypeIdList': breedingTypeList.map((item) => item.breedingTypeId).toList(),
      };

      await queryUpdateFarmFieldDetail(params);
      await closeLoading();
      if (!mounted) return;
      Toast.success('保存成功');
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) Get.back();
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          child: FocusScope(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      FormItemInput(
                        isRequired: true,
                        label: '地块名称',
                        value: fieldName,
                        hintText: '请输入地块名称',
                        onChanged: handleInputChangeFieldName,
                      ),
                      FormItemInput(
                        disabled: true,
                        label: '地块面积',
                        value: area,
                        hintText: '请输入地块面积',
                        // onChanged: handleInputChangeArea,
                      ),
                      FormItemInputMultipleLines(label: '地块位置', value: location, disabled: true),
                      SelectRegionWidget(
                        value: region,
                        label: '所在地区',
                        hintText: '请选择所在地区',
                        onChanged: onChangeRegion,
                        prefix: Text(
                          '*',
                          style: TextStyle(fontSize: 14.sp, color: const Color(0xFFFF0000)),
                        ),
                      ),
                      SelectBreedingTypeWidget(
                        label: '种养殖类型',
                        value: breedingTypeList,
                        hintText: '请选择种养殖类型',
                        onChanged: handleInputChangeBreedingTypeList,
                      ),

                      SelectFarmWidget(
                        label: '所属农场',
                        value: selectedFarm,
                        hintText: '请选择所属农场',
                        onChanged: handleInputChangeSelectFarm,
                      ),

                      FormItemInput(
                        label: '流转价格',
                        value: circulationPrice,
                        hintText: '请输入流转价格',
                        keyboardType: TextInputType.number,
                        onChanged: handleInputChangeCirculationPrice,
                        suffix: Text(
                          ' 元/亩*年',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14.sp,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                      FormItemInput(
                        label: '流转期限',
                        hintText: '请输入流转期限',
                        value: circulationPeriod,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: handleInputChangeCirculationPeriod,
                        suffix: Text(
                          ' 年',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14.sp,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                      FormItemDateRangePicker(
                        label: '流转年份',
                        endTime: endTime,
                        startTime: startTime,
                        hintText: '请选择流转年份',
                        onChanged: handleInputChangeDate,
                      ),

                      /// 流转方式
                      SelectCirculationMethodWidget(
                        onChanged: handleInputChangeCirculationMethod,
                        value: circulationMethod,
                      ),
                      FormItemInput(
                        label: '流转用途',
                        value: circulationUse,
                        hintText: '请输入流转用途',
                        textInputAction: TextInputAction.done,
                        onChanged: handleInputChangeCirculationUse,
                      ),
                      Container(
                        height: 48.w,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              '是否签订合同',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF4A4A4A),
                                height: 1,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  for (final item in _signList)
                                    GestureDetector(
                                      onTap: () {
                                        UserTapFeedback.selection();
                                        setState(() => contractSigned = item);
                                      },
                                      child: Container(
                                        width: 80.w,
                                        height: 40.w,
                                        color: Colors.transparent,
                                        alignment: Alignment.centerRight,
                                        margin: EdgeInsets.only(left: 20.w),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CheckboxWidget(
                                              size: 21.sp,
                                              ghost: true,
                                              radius: 11.w,
                                              checked: contractSigned?.value == item.value,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              item.label,
                                              style: TextStyle(
                                                height: 1,
                                                fontSize: 14.sp,
                                                color: const Color(0xFF333333),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 48.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3), blurRadius: 2),
            ],
          ),
          child: Center(
            child: ButtonWidget(
              height: 36.w,
              width: 266.w,
              radius: 18.w,
              text: '保存',
              onTap: handleSave,
            ),
          ),
        ),
      ),
    );
  }
}
