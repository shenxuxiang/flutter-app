import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show printLog, setStorageReceivingAddress;
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart'
    show queryUserAddressList, queryUserAddressSetDefault, queryUserAddressDelete;

import '../../components/button_widget.dart';

class AddressManagePage extends BasePage {
  const AddressManagePage({super.key, required super.author, required super.title});

  @override
  BasePageState<AddressManagePage> createState() => _AddressManagePageState();
}

class _AddressManagePageState extends BasePageState<AddressManagePage> {
  final mainModel = Get.find<MainModel>();

  @override
  void onLoad() {
    dataInitial();
  }

  dataInitial([bool enforceRefresh = false]) async {
    final userReceivingAddressList = mainModel.userReceivingAddressList;

    if (enforceRefresh || userReceivingAddressList.value.isEmpty) {
      await mainModel.queryReceivingAddressList();
    }
  }

  handleSetDefault(ReceivingAddress address) async {
    if (address.defaultFlag) return;

    final closeLoading = Loading.show();
    try {
      await queryUserAddressSetDefault({'addressId': address.addressId});
      closeLoading();
      await dataInitial(true);
      Toast.success('设置成功');
    } catch (error, stack) {
      closeLoading();
      printLog(error);
      printLog(stack);
    }
  }

  handleDelete(ReceivingAddress address) {
    if (address.defaultFlag) {
      Toast.warning('默认地址不能删除');
      return;
    }

    Alert.confirm(
      title: '确定要删除该地址吗？',
      onConfirm: () async {
        final closeLoading = Loading.show();
        try {
          await queryUserAddressDelete({'id': address.addressId});
          await dataInitial(true);
          await closeLoading();
          Toast.success('删除成功');
        } catch (error, stack) {
          closeLoading();
          printLog(error);
          printLog(stack);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: GetX<MainModel>(
          builder: (mainModel) {
            final userReceivingAddressList = mainModel.userReceivingAddressList.value;
            return ListView.builder(
              itemCount: userReceivingAddressList.length,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemBuilder: (BuildContext context, int index) {
                ReceivingAddress addressItem = userReceivingAddressList[index];
                return Container(
                  padding: EdgeInsets.all(12.w),
                  margin: EdgeInsets.only(top: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(QmIcons.userFill, size: 20.sp, color: const Color(0xFFFF8800)),
                          SizedBox(width: 6.w),
                          Text(
                            addressItem.username,
                            style: TextStyle(
                              height: 1,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.w),
                      Row(
                        children: [
                          SizedBox(width: 2.w),
                          Icon(QmIcons.phone, size: 18.sp, color: Theme.of(context).primaryColor),
                          SizedBox(width: 6.w),
                          Text(
                            addressItem.phone,
                            style: TextStyle(
                              height: 1,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.w),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(QmIcons.location, size: 20.sp, color: const Color(0xFF999999)),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              addressItem.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 14.sp,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, thickness: 0.5, color: Color(0xFFE0E0E0)),
                      Row(
                        children: [
                          CheckboxWidget(
                            checked: addressItem.defaultFlag,
                            onChanged: (checked) {
                              handleSetDefault(addressItem);
                            },
                            size: 22.w,
                            ghost: true,
                            radius: 11.w,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '设置为默认',
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/modify_receiving_address?id=${addressItem.addressId}');
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Icon(QmIcons.edit, size: 22.sp, color: const Color(0xFF4A4A4A)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '编辑',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 14.sp,
                                      color: const Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () => handleDelete(addressItem),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  Icon(QmIcons.delete, size: 22.sp, color: const Color(0xFF4A4A4A)),
                                  const SizedBox(width: 6),
                                  Text(
                                    '删除',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 14.sp,
                                      color: const Color(0xFF4A4A4A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
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
              text: '添加新地址',
              onTap: () {
                Get.toNamed('/modify_receiving_address');
              },
            ),
          ),
        ),
      ),
    );
  }
}
