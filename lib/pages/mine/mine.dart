import 'dart:async';
import '../../utils/toast.dart';
import 'constant.dart';
import 'menu_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/mine.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/utils/storage.dart';
import 'package:qm_agricultural_machinery_services/pages/mine/header.dart';
import 'package:qm_agricultural_machinery_services/pages/mine/user_status.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUserInfo;
import 'package:qm_agricultural_machinery_services/api/mine.dart' show queryUserStatus;

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  final homeModel = Get.find<HomeModel>();
  final mineModel = Get.find<MineModel>();
  final mainModel = Get.find<MainModel>();
  bool isInitial = false;

  late final StreamSubscription<int> subscriptionHomeTabKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((Duration _) async {
      if (!mounted) return;

      if (Storage.getItem('User_Token') == null) {
        await Get.toNamed('login');
        handleRefresh();
      } else {
        handleRefresh();
      }

      subscriptionHomeTabKey = homeModel.tabKey.listen((int tabIndex) {
        if (tabIndex == 4) handleRefresh();
      });
    });

    super.initState();
  }

  handleRefresh() async {
    final closeLoading = Loading.show();
    try {
      /// 获取用户认证状态
      final userCheckStatus = await queryUserStatus();
      mineModel.setUserCheckStatus(userCheckStatus.data);

      /// 获取用户信息
      final userInfo = await queryUserInfo();
      mainModel.setUserInfo(userInfo.data);
    } catch (error, stack) {
      printLog('$error');
      printLog('$stack');
    }
    closeLoading();
  }

  @override
  void dispose() {
    subscriptionHomeTabKey.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          UserStatus(),
          Container(
            height: 190.w,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44.w,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    '我的服务',
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333), height: 1),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.w, 21.w, 30.w, 0),
                    child: Wrap(
                      spacing: 34.6.w,
                      runSpacing: 21.3.w,
                      children: [
                        for (final item in myServiceMenus)
                          MenuItem(title: item.title, link: item.link, icon: item.icon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 190.w,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(12.w, 10.w, 12.w, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 44,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    '我的设置',
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333), height: 1),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30.w, 21.w, 30.w, 0),
                    child: Wrap(
                      spacing: 34.6.w,
                      runSpacing: 21.3.w,
                      children: [
                        for (final item in mySettingsMenus)
                          MenuItem(title: item.title, link: item.link, icon: item.icon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
