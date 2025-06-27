import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/my_farm.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/entity/farm_info.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/entity/location_info.dart';
import 'package:qm_agricultural_machinery_services/components/text_area.dart';
import 'package:qm_agricultural_machinery_services/entity/breeding_type.dart';
import 'package:qm_agricultural_machinery_services/components/form_item.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input.dart';
import 'package:qm_agricultural_machinery_services/components/select_breeding_type.dart';
import 'package:qm_agricultural_machinery_services/components/select_region_widget.dart';

import '../../common/global_vars.dart';

class AddFarmPage extends BasePage {
  const AddFarmPage({super.key, required super.title, required super.author});

  @override
  State<AddFarmPage> createState() => _AddFarmPageState();
}

class _AddFarmPageState extends BasePageState<AddFarmPage> {
  final mainModel = Get.find<MainModel>();
  String id = '';
  String title = '';

  String leader = ''; // 负责人

  LocationInfo? location; // 地址

  String contact = ''; // 联系方式

  String farmName = ''; // 农场名称

  String scopeBusiness = ''; // 经营范围

  String farmerCount = ''; // 农场人员数量

  bool isDefault = false; // 是否为默认农场

  String organizationCode = ''; // 组织机构代码

  List<SelectedTreeNode> region = []; // 所在地区

  String unifiedSocialCreditCode = ''; // 统一社会信用代码

  List<BreedingType> breedingTypeList = [];

  bool get canSave => computedDisabled();

  @override
  void onMounted() {
    id = Get.parameters['id'] ?? '';
    title = id.isNotEmpty ? '农场设置' : '添加农场';

    if (id.isEmpty) return;

    /// 获取详情
    handleQueryFarmDetail();
  }

  /// 获取农场详情、以及天气信息
  Future<void> handleQueryFarmDetail() async {
    CloseLoading closeLoading = Loading.show();
    try {
      /// 获取农场详情
      final resp = await queryMyFarmDetail(id);
      final farmInfo = FarmInfo.fromJson(resp.data);

      if (!mounted) return;
      farmName = farmInfo.farmName;
      leader = farmInfo.leader ?? '';
      contact = farmInfo.contact ?? '';
      contact = farmInfo.contact ?? '';
      isDefault = farmInfo.systemDefault;
      scopeBusiness = farmInfo.scopeBusiness ?? '';
      organizationCode = farmInfo.organizationCode ?? '';
      location = LocationInfo.fromJson(farmInfo.toJson());
      farmerCount = (farmInfo.farmerCount ?? '').toString();
      unifiedSocialCreditCode = farmInfo.unifiedSocialCreditCode ?? '';

      /// 种养殖业
      if (farmInfo.breedingTypeIdList?.isNotEmpty ?? false) {
        final breedingTypeNameList = farmInfo.breedingTypeNames?.split(',') ?? [];
        for (int i = 0; i < breedingTypeNameList.length; i++) {
          breedingTypeList.add(
            BreedingType(
              breedingTypeName: breedingTypeNameList[i],
              breedingTypeId: farmInfo.breedingTypeIdList![i],
            ),
          );
        }
      }

      /// 根据 regionCode 计算完成的省市区县
      final regions = await getParentRegions(farmInfo.regionCode);
      if (!mounted) return;
      region = regions;
      setState(() {});
    } finally {
      closeLoading();
    }
  }

  computedDisabled() {
    return farmName.isEmpty || region.isEmpty || location == null;
  }

  /// 农场名称
  handleInputChangeFarmName(String input) {
    setState(() {
      farmName = input;
    });
  }

  /// 统一社会信用代码
  handleInputChangeUnifiedSocialCreditCode(String input) {
    setState(() {
      unifiedSocialCreditCode = input;
    });
  }

  /// 组织机构代码
  handleInputChangeOrganizationCode(String input) {
    setState(() {
      organizationCode = input;
    });
  }

  /// 更新所在地区
  onChangeRegion(List<SelectedTreeNode> regions) {
    setState(() {
      region = regions;
    });
  }

  /// 更新位置
  handleInputChangeAddress(LocationInfo input) {
    setState(() {
      location = input;
    });
  }

  /// 负责人
  handleInputChangeLeader(String input) {
    setState(() {
      leader = input;
    });
  }

  /// 联系方式
  handleInputChangeContact(String input) {
    setState(() {
      contact = input;
    });
  }

  /// 农场人员数量
  handleInputChangeFarmerCount(String input) {
    setState(() {
      farmerCount = input.replaceAll(RegExp(r'[^0-9]'), '');
    });
  }

  /// 种养殖业
  handleInputChangeBreedingTypeList(List<BreedingType> input) {
    setState(() {
      breedingTypeList = input;
    });
  }

  /// 经营范围
  handleInputChangeScopeBusiness(String input) {
    setState(() {
      scopeBusiness = input;
    });
  }

  handleSubmit() async {
    if (contact.isNotEmpty && !GlobalVars.phoneRegExp.hasMatch(contact)) {
      Toast.warning('请输入正确的手机号');
      return;
    }

    final closeLoading = Loading.show(message: '正在提交···');
    try {
      final params = {
        'breedingTypeIdList': breedingTypeList.map((item) => item.breedingTypeId).toList(),
        'unifiedSocialCreditCode': unifiedSocialCreditCode,
        'organizationCode': organizationCode,
        'longitude': location?.longitude,
        'latitude': location?.latitude,
        'scopeBusiness': scopeBusiness,
        'cityname': location?.cityname,
        'address': location?.address,
        'farmerCount': farmerCount,
        'adname': location?.adname,
        'pname': location?.pname,
        'name': location?.name,
        'farmName': farmName,
        'contact': contact,
        'leader': leader,
      };
      if (region.isNotEmpty) {
        params['regionCode'] = region.last.value;
        params['regionName'] = region.last.label;
      }

      if (id.isEmpty) {
        await queryAddFarm(params);
        await closeLoading();
        Toast.success('添加成功', duration: const Duration(milliseconds: 1500));
      } else {
        params['farmId'] = id;
        await queryUpdateFarm(params);
        await closeLoading();
        Toast.success('更新成功', duration: const Duration(milliseconds: 1500));
      }
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      closeLoading();
    }
  }

  handleDelete() async {
    final closeLoading = Loading.show(message: '正在提交···');
    try {
      await queryDeleteFarm(id);
      await closeLoading();
      Toast.success('删除成功', duration: const Duration(milliseconds: 1000));
      await Future.delayed(const Duration(milliseconds: 1500));
      Get.back();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      closeLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: title),
        body: SingleChildScrollView(
          child: FocusScope(
            child: Column(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Text(
                          '基本信息',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      FormItemInput(
                        maxLength: 20,
                        value: farmName,
                        label: '农场名称',
                        isRequired: true,
                        hintText: '请输入农场名称',
                        onChanged: handleInputChangeFarmName,
                      ),
                      FormItemInput(
                        maxLength: 20,
                        label: '统一社会信用代码',
                        hintText: '请输入统一社会信用代码',
                        value: unifiedSocialCreditCode,
                        keyboardType: TextInputType.number,
                        onChanged: handleInputChangeUnifiedSocialCreditCode,
                      ),
                      FormItemInput(
                        maxLength: 20,
                        label: '组织机构代码',
                        value: organizationCode,
                        hintText: '请输入组织机构代码',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: handleInputChangeOrganizationCode,
                      ),
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
                      FormItem(
                        height: 48.5.w,
                        label: '农场位置',
                        isRequired: true,
                        onTap: () async {
                          final location = await Get.toNamed('/user_location');
                          if (location != null) handleInputChangeAddress(location);
                          await Future.delayed(const Duration(milliseconds: 100));
                          if (context.mounted) FocusScope.of(context).unfocus();
                        },
                        suffix: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(QmIcons.location, size: 21.sp, color: const Color(0xFF4A4A4A)),
                              const SizedBox(height: 2),
                              Text(
                                '定位',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 11.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        child: Text(
                          location?.address ?? '请输入农场位置详细地址',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SelectBreedingTypeWidget(
                        label: '种养殖类型',
                        value: breedingTypeList,
                        hintText: '请选择种养殖类型',
                        onChanged: handleInputChangeBreedingTypeList,
                      ),
                      FormItemInput(
                        value: leader,
                        label: '负责人',
                        hintText: '请输入负责人',
                        onChanged: handleInputChangeLeader,
                      ),
                      FormItemInput(
                        value: contact,
                        label: '联系方式',
                        hintText: '请输入联系方式',
                        keyboardType: TextInputType.phone,
                        onChanged: handleInputChangeContact,
                      ),
                      FormItemInput(
                        bordered: false,
                        label: '农场人员数量',
                        value: farmerCount,
                        hintText: '请输入农场人员数量',
                        keyboardType: TextInputType.number,
                        onChanged: handleInputChangeFarmerCount,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.w),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Text(
                          '经营范围',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      TextArea(
                        height: 120.w,
                        maxLength: 300,
                        value: scopeBusiness,
                        hintText: '请输入经营范围',
                        onChanged: handleInputChangeScopeBusiness,
                      ),
                      SizedBox(height: 12.w),
                    ],
                  ),
                ),
                SizedBox(height: 12.w),
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
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child:
              id.isEmpty
                  ? Center(
                    child: ButtonWidget(
                      height: 36.w,
                      width: 266.w,
                      radius: 18.w,
                      text: '保存',
                      disabled: canSave,
                      onTap: handleSubmit,
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonWidget(
                        height: 36.w,
                        width: 120.w,
                        radius: 18.w,
                        text: '删除',
                        ghost: true,
                        type: 'default',
                        disabled: isDefault,
                        onTap: handleDelete,
                      ),
                      SizedBox(width: 20.w),
                      ButtonWidget(
                        height: 36.w,
                        width: 120.w,
                        radius: 18.w,
                        text: '保存',
                        disabled: canSave,
                        onTap: handleSubmit,
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
