import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/mine.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class UserStatus extends StatelessWidget {
  final mineModel = Get.find<MineModel>();

  UserStatus({super.key});

  String computeStatusName(int? status, String? userTypeName) {
    switch (status) {
      case 0:
        return '未认证';
      case 1:
        return '待认证审核';
      case 2:
        return '认证不通过';
      case 3:
        return '$userTypeName | 已认证';
      default:
        return '--';
    }
  }

  computeButtonText(int? status) {
    switch (status) {
      case 0:
        return '立即认证';
      case 1:
        return '查看认证';
      case 2:
        return '查看认证';
      case 3:
        return '查看认证';
      default:
        return '查看认证';
    }
  }

  handleTap() {
    UserTapFeedback.selection();
    final status = mineModel.userCheckStatus.value?.checkStatus;

    switch (status) {
      case 0:
        return Get.toNamed('/identity_auth');
      case 1:
        return Get.toNamed('/identity_auth/view_auth');
      case 2:
        return Get.toNamed('/identity_auth/view_auth');
      case 3:
        return Get.toNamed('/identity_auth/view_auth');
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final userCheckStatus = mineModel.userCheckStatus;

    return Container(
      height: 49.w,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      margin: EdgeInsets.fromLTRB(12.w, 18.w, 12.w, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Obx(
            () => Icon(
              QmIcons.confirm,
              size: 22.sp,
              color:
                  userCheckStatus.value?.checkStatus == 3 ? primaryColor : const Color(0xFF333333),
            ),
          ),

          const SizedBox(width: 5),
          Obx(
            () => Text(
              computeStatusName(
                userCheckStatus.value?.checkStatus,
                userCheckStatus.value?.userTypeName,
              ),
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFF333333), height: 1),
            ),
          ),

          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: ButtonWidget(
                ghost: true,
                width: 80.w,
                radius: 14.w,
                height: 28.w,
                type: 'primary',
                onTap: handleTap,
                child: Obx(
                  () => Text(
                    computeButtonText(userCheckStatus.value?.checkStatus),
                    style: TextStyle(fontSize: 12.sp, color: primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
