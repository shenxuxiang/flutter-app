import '../common/global_vars.dart';
import 'toast.dart';
import 'utils.dart';
import 'bottom_sheet.dart';
import 'package:get/get.dart';
import 'user_tap_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showCallPhoneSheetDialog({BuildContext? context, required String phone}) {
  final ctx = context ?? GlobalVars.context;

  QmBottomSheet.showSimpleSheet(
    context: ctx,
    builder: (BuildContext context, VoidCallback onClose) {
      final primaryColor = Theme.of(context).primaryColor;
      return SizedBox(
        width: 336.w,
        height: 104.w,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                UserTapFeedback.selection();
                onClose();

                if (getStorageUserToken()?.isEmpty ?? true) {
                  Toast.show('用户未登录', duration: const Duration(seconds: 1));
                  await Future.delayed(const Duration(seconds: 1));
                  Get.toNamed('/login');
                } else {
                  callPhone(phone);
                }
              },
              child: Container(
                width: 336.w,
                height: 44.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(color: Color(0xFFF1FBF5), offset: Offset(0, 0.67), blurRadius: 5.33),
                  ],
                ),
                child: Text('拨打电话', style: TextStyle(fontSize: 16.sp, color: primaryColor)),
              ),
            ),
            SizedBox(height: 8.w),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 336.w,
                height: 44.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  boxShadow: [
                    BoxShadow(blurRadius: 5.33, offset: Offset(0, 0.67), color: Color(0xFFF1FBF5)),
                  ],
                ),
                child: Text('取消', style: TextStyle(fontSize: 16.sp, color: primaryColor)),
              ),
            ),
          ],
        ),
      );
    },
  );
}
