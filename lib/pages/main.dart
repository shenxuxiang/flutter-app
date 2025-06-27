import 'dart:async';
import '../api/main.dart';
import '../api/publish.dart';
import '../models/main.dart';
import '../models/publish.dart';
import '../utils/utils.dart';
import 'home/home.dart';
import 'mine/mine.dart';
import 'publish/index.dart';
import 'package:get/get.dart';
import 'service/service.dart';
import 'technology/technology.dart';
import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/keep_alive.dart';
import 'package:qm_agricultural_machinery_services/components/bottom_tab_bar.dart';

final _tabs = [
  TabItem(key: 0, label: '首页', icon: QmIcons.home, activeIcon: QmIcons.homeFill),
  TabItem(key: 1, label: '服务', icon: QmIcons.service, activeIcon: QmIcons.serviceFill),
  TabItem(key: 2, label: '发布', icon: QmIcons.release, activeIcon: QmIcons.releaseFill),
  TabItem(key: 3, label: '农技', icon: QmIcons.agricultural, activeIcon: QmIcons.agriculturalFill),
  TabItem(key: 4, label: '我的', icon: QmIcons.user, activeIcon: QmIcons.userFill),
];

class MainPage extends BasePage {
  const MainPage({super.key, required super.title, super.author = false});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends BasePageState<MainPage> {
  late final StreamSubscription<int> subscriptionTabKey;
  late final PageController _pageController;

  final mainModel = Get.find<MainModel>();
  final homeModel = Get.find<HomeModel>();
  final publishModel = Get.find<PublishModel>();

  /// 设置一个 tabKey 的阀门，
  bool switchOfTabKey = true;

  @override
  void onLoad() {
    final activeKey = int.parse(Get.parameters['tab'] ?? '0');
    homeModel.tabKey.value = activeKey;
    _pageController = PageController(initialPage: activeKey);

    /// 监听 tabKey 的变化
    subscriptionTabKey = homeModel.tabKey.listen(handleListenKeyChange);

    /// 获取需求大类
    publishModel.queryDemandSubcategoryTreeList();

    /// 获取服务大类
    mainModel.queryServiceSubCategory();
  }

  @override
  void onUnload() {
    subscriptionTabKey.cancel();
    _pageController.dispose();
  }

  handleListenKeyChange(int tabKey) {
    /// 当阀门关闭时，不执行任何逻辑
    if (!switchOfTabKey) {
      switchOfTabKey = true;
    } else {
      _pageController.jumpToPage(tabKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: PageWidget(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  const KeepAliveWidget(child: HomePage()),
                  const KeepAliveWidget(child: ServicePage()),
                  const KeepAliveWidget(child: PublishPage()),
                  const KeepAliveWidget(child: TechnologyPage()),
                  const KeepAliveWidget(child: MinePage()),
                ],
                onPageChanged: (int key) {
                  if (homeModel.tabKey.value == key) return;

                  /// 将阀门关闭，避免 homeModel.tabKey 的监听函数再次调用 jumpToPage()
                  switchOfTabKey = false;
                  homeModel.tabKey.value = key;
                },
              ),
            ),
            Obx(
              () => BottomTabBar(
                tabs: _tabs,
                activeKey: homeModel.tabKey.value,
                onChanged: (key) => homeModel.tabKey.value = key,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
