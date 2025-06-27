import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/sheet_dialog.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

import '../components/badge.dart';
import 'loading.dart';
import 'bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/checkbox.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUserAddressList;

class SelectReceivingAddress {
  static show({
    required Function(ReceivingAddress? address) onChanged,
    ReceivingAddress? value,
  }) async {
    final mainModel = Get.find<MainModel>();
    final currentUserAddress = Rx<ReceivingAddress?>(value);
    final userReceivingAddressList = mainModel.userReceivingAddressList;

    if (userReceivingAddressList.value.isEmpty) {
      final closeLoading = Loading.show();
      try {
        final resp = await queryUserAddressList({'pageNum': 1, 'pageSize': 999});
        mainModel.setUserReceivingAddressList(resp.data['list'] ?? []);
      } catch (error, stack) {
        printLog(error);
        printLog(stack);
      }
      closeLoading();
    }

    handleChanged({required ReceivingAddress source, required bool selected}) {
      if (selected) {
        currentUserAddress.value = source;
        onChanged(source);
      }
    }

    showSheetDialog(
      height: 382.w,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 48,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    '选择地址',
                    style: TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(QmIcons.close, size: 24, color: const Color(0xFF333333)),
                  ),
                ),
              ],
            ),
            const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
            Expanded(
              child: Obx(() {
                if (userReceivingAddressList.value.isEmpty) {
                  return const Center(child: EmptyWidget(size: 50));
                }

                return CustomScrollView(
                  slivers: [
                    for (final item in userReceivingAddressList.value)
                      SliverToBoxAdapter(
                        child: _AddressItem(
                          source: item,
                          onModify: (ReceivingAddress source) {
                            Navigator.of(context).pop();
                            Get.toNamed('/modify_receiving_address?id=${source.addressId}');
                          },
                          onChanged: handleChanged,
                          selected: currentUserAddress.value?.addressId == item.addressId,
                        ),
                      ),
                  ],
                );
              }),
            ),
            Container(
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3333), blurRadius: 2),
                ],
              ),
              alignment: Alignment.center,
              child: ButtonWidget(
                onTap: () {
                  Navigator.of(context).pop();
                  Get.toNamed('/modify_receiving_address');
                },
                text: '添加新地址',
                height: 36,
                width: 266,
                radius: 18,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AddressItem extends StatelessWidget {
  final bool selected;
  final ReceivingAddress source;
  final void Function(ReceivingAddress source) onModify;
  final void Function({required ReceivingAddress source, required bool selected}) onChanged;

  const _AddressItem({
    super.key,
    required this.source,
    required this.onModify,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.w,
      padding: EdgeInsets.only(left: 12.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!selected) onChanged(source: source, selected: true);
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  children: [
                    CheckboxWidget(size: 20, radius: 10, checked: selected, onChanged: (_) {}),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 95.w),
                                child: Text(
                                  source.username,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 16.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                source.phone,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF4A4A4A),
                                  height: 1,
                                ),
                              ),
                              const SizedBox(width: 14),
                              source.defaultFlag
                                  ? BadgeWidget(
                                    title: '默认',
                                    radius: 10.w,
                                    width: 60.w,
                                    size: 'small',
                                  )
                                  : const SizedBox(height: 20),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            maxLines: 1,
                            source.address,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              height: 1,
                              fontSize: 13,
                              color: Color(0xFF4A4A4A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onModify(source),
            child: Container(
              height: 72.w,
              color: Colors.transparent,
              padding: EdgeInsets.only(left: 5.w, right: 12.w),
              child: Icon(QmIcons.modify, size: 24, color: const Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}
