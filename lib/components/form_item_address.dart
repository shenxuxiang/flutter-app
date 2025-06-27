import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/badge.dart';
import 'package:qm_agricultural_machinery_services/components/form_item.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/utils/select_receiving_address.dart';

class FormItemAddress extends StatelessWidget {
  final bool bordered;
  final bool disabled;
  final ReceivingAddress? address;
  final Function(ReceivingAddress? address) onChanged;

  const FormItemAddress({
    super.key,
    this.address,
    this.bordered = true,
    this.disabled = false,
    required this.onChanged,
  });

  handleTap(BuildContext context) {
    if (disabled) return;
    FocusScope.of(context).unfocus();
    SelectReceivingAddress.show(onChanged: onChanged, value: address);
  }

  @override
  Widget build(BuildContext context) {
    if (address == null) {
      return FormItem(
        value: '',
        height: 48.5.w,
        bordered: bordered,
        label: '请您选择地址',
        onTap: () => handleTap(context),
        suffix: Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF999999)),
      );
    }

    return GestureDetector(
      onTap: () => handleTap(context),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 16.w, 0, 14.w),
        decoration: BoxDecoration(
          border:
              bordered
                  ? const Border(bottom: BorderSide(width: 0.5, color: Color(0xFFE0E0E0)))
                  : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address?.username ?? '请您选择地址',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                height: 1,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 10.w),
                            Row(
                              children: [
                                Icon(
                                  QmIcons.phone,
                                  size: 18.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  address?.phone ?? '',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF4A4A4A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      address?.defaultFlag ?? false
                          ? BadgeWidget(title: '默认', radius: 10.w, width: 60.w, size: 'small')
                          : const SizedBox.shrink(),
                      SizedBox(width: 12.w),
                    ],
                  ),

                  SizedBox(height: 12.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(QmIcons.location, size: 20.sp, color: const Color(0xFFFF4949)),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          address?.address ?? '需要添加地址后才能执行相关操作',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 13.sp,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                ],
              ),
            ),
            disabled
                ? const SizedBox.shrink()
                : Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF999999)),
          ],
        ),
      ),
    );
  }
}
