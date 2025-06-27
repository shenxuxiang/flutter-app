import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/form_item.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input.dart';
import 'package:qm_agricultural_machinery_services/components/select_region_widget.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart'
    show addUserAddress, updateUserAddress, queryUserAddressList, queryUserAddressDetail;

class ModifyReceivingAddressPage extends BasePage {
  const ModifyReceivingAddressPage({super.key, required super.title, required super.author});

  @override
  BasePageState<ModifyReceivingAddressPage> createState() => _ModifyReceivingAddressPageState();
}

class _ModifyReceivingAddressPageState extends BasePageState<ModifyReceivingAddressPage> {
  String _phone = '';
  String _address = '';
  bool _isEdit = false;
  String _username = '';
  String _addressId = '';
  bool _defaultFlag = false;
  String _title = '添加地址';
  List<SelectedTreeNode> _region = [];

  bool get _disable => _username.isEmpty || _phone.isEmpty || _region.isEmpty || _address.isEmpty;

  @override
  void onMounted() {
    if (Get.parameters.containsKey('id')) {
      _isEdit = true;
      _title = '修改地址';
      _addressId = Get.parameters['id']!;
      handleQueryUserAddressDetail();
    }
  }

  handleQueryUserAddressDetail() async {
    final closeLoading = Loading.show();
    try {
      final resp = await queryUserAddressDetail({'id': _addressId});
      final data = resp.data;
      final List<SelectedTreeNode> regions = await getParentRegions(data['regionCode']);

      if (!mounted) return;

      setState(() {
        _region = regions;
        _phone = data['phone'];
        _address = data['address'];
        _username = data['username'];
        _defaultFlag = data['defaultFlag'];
      });
    } finally {
      closeLoading();
    }
  }

  /// 修改姓名
  handleChangeName(String input) {
    setState(() {
      _username = input;
    });
  }

  /// 修改联系电话
  handleChangePhone(String input) {
    setState(() {
      _phone = input;
    });
  }

  /// 修改地区
  handleChangeRegion(List<SelectedTreeNode> region) {
    setState(() {
      _region = region;
    });
  }

  /// 修改详细地址
  handleChangeAddress(String input) {
    setState(() {
      _address = input;
    });
  }

  /// 设置为默认地址
  handleChangedFlag() {
    setState(() {
      _defaultFlag = !_defaultFlag;
    });
  }

  getDisabled() {
    return _username.isEmpty || _phone.isEmpty || _region.isEmpty || _address.isEmpty;
  }

  handleSubmit() async {
    if (!GlobalVars.phoneRegExp.hasMatch(_phone)) {
      Toast.warning('请输入正确的联系方式');
      return;
    }
    final closeLoading = Loading.show(message: '正在保存');
    var params = {
      'phone': _phone,
      'address': _address,
      'username': _username,
      'defaultFlag': _defaultFlag,
      'regionCode': _region.last.value,
      'regionName': _region.last.label,
    };

    try {
      if (_isEdit) {
        params['addressId'] = _addressId;
        await updateUserAddress(params);
      } else {
        await addUserAddress(params);
      }

      /// 更新用户收获地址
      final mainModel = Get.find<MainModel>();
      await mainModel.queryReceivingAddressList();
      // final resp = await queryUserAddressList({'pageNum': 1, 'pageSize': 999});
      // mainModel.setUserReceivingAddressList(resp.data['list'] ?? []);
      // if (_defaultFlag) {
      //   for (final item in mainModel.userReceivingAddressList.value) {
      //     if (item.defaultFlag) setStorageReceivingAddress(item);
      //   }
      // }

      if (!mounted) return;
      await closeLoading();
      Toast.show(_isEdit ? '修改成功~' : '添加成功~');

      Get.back();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: _title),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: FocusScope(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormItemInput(
                  maxLength: 6,
                  label: '姓名',
                  value: _username,
                  hintText: '请输入姓名',
                  onChanged: handleChangeName,
                ),
                FormItemInput(
                  maxLength: 11,
                  value: _phone,
                  label: '联系方式',
                  hintText: '请输入电话码号',
                  onChanged: handleChangePhone,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                ),
                SelectRegionWidget(
                  value: _region,
                  label: '所在地区',
                  hintText: '请选择所在地区',
                  onChanged: handleChangeRegion,
                ),
                FormItemInput(
                  value: _address,
                  label: '详细地址',
                  hintText: '请输入详细地址',
                  onChanged: handleChangeAddress,
                  textInputAction: TextInputAction.done,
                  suffix: GestureDetector(
                    onTap: () async {
                      final location = await Get.toNamed('/user_location');
                      if (location != null) handleChangeAddress(location.address);
                    },
                    child: Padding(
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
                  ),
                ),
                FormItem(
                  onTap: handleChangedFlag,
                  height: 48.w,
                  bordered: false,
                  child: Row(
                    children: [
                      CheckboxWidget(
                        size: 20.w,
                        radius: 10.w,
                        ghost: true,
                        checked: _defaultFlag,
                        onChanged: (_) => {},
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '设置为默认地址',
                        style: TextStyle(
                          height: 1.2,
                          fontSize: 14.sp,
                          color: const Color(0xFF4A4A4A),
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
              BoxShadow(color: Color(0xFFEfEfEF), offset: Offset(0, -0.3), blurRadius: 2),
            ],
          ),

          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                height: 36.w,
                width: 266.w,
                radius: 18.w,
                text: '立即保存',
                disabled: _disable,
                onTap: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
