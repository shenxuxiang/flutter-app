import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/models/publish.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/permissions.dart';
import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/utils/platform_info.dart';
import 'package:qm_agricultural_machinery_services/utils/cache_cleaner.dart';
import 'package:qm_agricultural_machinery_services/api/login.dart' show queryLogOut;
import 'package:qm_agricultural_machinery_services/api/app_version.dart' show queryCheckAppVersion;

class MenuItemSource {
  final dynamic link;
  final String title;
  final String icon;

  const MenuItemSource({required this.title, required this.link, required this.icon});

  factory MenuItemSource.fromJson(Map<String, dynamic> json) =>
      MenuItemSource(title: json['title'], link: json['link'], icon: json['icon']);
}

/// 缓存清理
clearAppMemoryCache() {
  Alert.confirm(
    title: '确定要清理缓存吗？',
    onConfirm: () async {
      final closeLoading = Loading.show(message: '正在清理');
      CacheCleaner.clearImageMemoryCache();
      await CacheCleaner.clearTempFiles();
      await closeLoading();
      Toast.success('清理成功');
    },
  );
}

/// 版本检测
checkAppVersion() async {
  var closeLoading = Loading.show();
  try {
    ///
    final packageInfo = await PlatformInfo.getPlatformInfo();
    final resp = await queryCheckAppVersion({'clientType': '1', 'version': packageInfo.appVersion});
    final data = resp.data;
    final updateFlag = data['updateFlag'];
    await closeLoading();
    if (updateFlag == 0) {
      Toast.show('当前已是最新版本');
    } else if (updateFlag == 1) {
      Alert.confirm(
        showCancel: false,
        confirmText: '立即升级',
        onConfirm: () async {
          try {
            closeLoading = Loading.show(message: '正在下载');
            final tempDir = await getTemporaryDirectory();

            /// 指定下载后的文件路径
            final fileName = path.join(tempDir.path, 'app-v${data['version']}.apk');
            await request.download(getNetworkAssetURL(data['url']), fileName);
            closeLoading();

            /// 请求是否可以自动安装
            if (await Permissions.requestInstallPackage()) {
              await OpenFile.open(fileName, type: "application/vnd.android.package-archive");
            }
          } catch (error, stack) {
            closeLoading();
            printLog(error);
            printLog(stack);
          }
        },
        builder: (context, close) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 77.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/update_version.png', width: 38.w, height: 38.w),
                        const SizedBox(width: 12),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '版本更新提醒',
                              style: TextStyle(
                                height: 1,
                                fontSize: 16.w,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              '最新版本：V${data['version']}',
                              style: TextStyle(
                                fontSize: 13.w,
                                color: const Color(0xFF4B4B4B),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// 更新类型 1-强制更新, 2-强提示更新, 3-弱提示更新
                    /// 强制更新时不会展示关闭按钮
                    data['updateType'] == 1
                        ? const SizedBox()
                        : Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: close,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 0, 4),
                              child: Icon(
                                QmIcons.closeRound,
                                size: 28.sp,
                                color: const Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const Divider(thickness: 0.5, height: 0.5, color: Color(0xFFE0E0E0)),
              Container(
                constraints: BoxConstraints(maxHeight: 187.w),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '新版本特性',
                        style: TextStyle(
                          height: 1,
                          fontSize: 14.w,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4B4B4B),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        data['content'],
                        style: TextStyle(
                          fontSize: 13.w,
                          color: const Color(0xFF4B4B4B),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  } catch (error, stack) {
    closeLoading();
    printLog(error);
    printLog(stack);
  }
}

/// 退出登录
logOut() {
  Alert.confirm(
    title: '确定要退出登录吗？',
    onConfirm: () async {
      final mainModel = Get.find<MainModel>();
      final publishModel = Get.find<PublishModel>();

      final closeLoading = Loading.show();
      try {
        mainModel.clearCache();
        publishModel.clearCache();

        /// 清除用户数据缓存
        setStorageUserInfo(null);
        setStorageUserToken(null);
        // setStorageReceivingAddress(null);
        await queryLogOut({});
        await closeLoading();
        Get.offAllNamed('/login?is_logout=true');
      } catch (error, stack) {
        closeLoading();
        printLog(error);
        printLog(stack);
      }
    },
  );
}

_handleTap() {
  Toast.show('功能暂未开放');
}

/// 我的服务
final myServiceMenus = [
  {'title': '我的订单', 'icon': 'assets/images/mine/service_order.png', 'link': '/my_order'},
  {'title': '我的需求', 'icon': 'assets/images/mine/service_demand.png', 'link': '/my_demand'},
  {'title': '我的提问', 'icon': 'assets/images/mine/service_question.png', 'link': _handleTap},
  {'title': '我的农场', 'icon': 'assets/images/mine/service_farm.png', 'link': '/my_farm'},
  {'title': '我的贷款', 'icon': 'assets/images/mine/service_credit.png', 'link': _handleTap},
  {'title': '我的保险', 'icon': 'assets/images/mine/service_insurance.png', 'link': _handleTap},
  {'title': '我的奖补', 'icon': 'assets/images/mine/service_cup.png', 'link': _handleTap},
  {'title': '客服热线', 'icon': 'assets/images/mine/service_customer.png', 'link': _handleTap},
].map((item) => MenuItemSource.fromJson(item));

/// 我的设置
final mySettingsMenus = [
  {
    'title': '个人资料',
    'icon': 'assets/images/mine/settings_personal_data.png',
    'link': '/personal_data',
  },
  {'title': '地址管理', 'icon': 'assets/images/mine/setting_location.png', 'link': '/address_manage'},
  {
    'title': '更新记录',
    'icon': 'assets/images/mine/setting_update_record.png',
    'link': '/update_record',
  },
  {'title': '检查更新', 'icon': 'assets/images/mine/setting_check_update.png', 'link': checkAppVersion},
  {'title': '清除缓存', 'icon': 'assets/images/mine/setting_clean.png', 'link': clearAppMemoryCache},
  {'title': '关于我们', 'icon': 'assets/images/mine/setting_about_us.png', 'link': '/about_us'},
  {'title': '退出登录', 'icon': 'assets/images/mine/setting_logout.png', 'link': logOut},
].map((item) => MenuItemSource.fromJson(item));
