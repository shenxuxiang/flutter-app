import 'dart:async';
import 'demand_panel.dart';
import 'service_panel.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';
import 'package:qm_agricultural_machinery_services/components/button_group.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show generateUniqueString;

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

const buttonGroupList = [
  ButtonGroupOption(value: 'service', label: '服务'),
  ButtonGroupOption(value: 'demand', label: '需求'),
];

class _ServicePageState extends State<ServicePage> with SingleTickerProviderStateMixin {
  final homeModel = Get.find<HomeModel>();
  late final TabController _tabController;
  late final StreamSubscription<int> subscriptionHomeTabKey;
  ValueKey? demandPanelKey;
  int _activeTabKey = 0;

  @override
  void initState() {
    _tabController = TabController(initialIndex: _activeTabKey, length: 2, vsync: this);

    /// 监听底部导航兰的 tabKey 的变化
    /// 每当切换至服务大厅时重新渲染【DemandPanel】需求面板
    subscriptionHomeTabKey = homeModel.tabKey.listen(handleListener);
    super.initState();
  }

  @override
  dispose() {
    subscriptionHomeTabKey.cancel();
    super.dispose();
  }

  handleListener(int homeTabKey) {
    if (homeTabKey == 1) {
      setState(() {
        demandPanelKey = ValueKey(generateUniqueString());
      });
    }
  }

  handleChangedTab(int key) {
    _tabController.index = key;
    setState(() => _activeTabKey = key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('服务大厅'),
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44.w),
          child: Container(
            height: 44.w,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
            child: ButtonGroup(
              index: _activeTabKey,
              options: buttonGroupList,
              onChanged: handleChangedTab,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [const ServicePanel(), DemandPanel(key: demandPanelKey)],
      ),
    );
  }
}
