import 'tabs.dart';
import 'search_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/pages/my_order/tab_panel.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

class MyOrderPage extends BasePage {
  const MyOrderPage({super.key, required super.title, required super.author});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

const _tabs = [
  TabItem(key: 0, label: '全部'),
  TabItem(key: 1, label: '待确认', status: 1),
  TabItem(key: 2, label: '服务中', status: 2),
  TabItem(key: 3, label: '已服务', status: 3),
  TabItem(key: 4, label: '已完结', status: 4),
  TabItem(key: 5, label: '已取消', status: 5),
];

class _MyOrderPageState extends BasePageState<MyOrderPage> {
  late final PageController _pageController;

  int _tabIndex = 0;

  @override
  void onLoad() {
    _tabIndex = int.parse(Get.parameters['tab'] ?? '0');
    _pageController = PageController(initialPage: _tabIndex);
  }

  @override
  void onUnload() {
    _pageController.dispose();
  }

  handleChangeTabIndex(int index) {
    setState(() => _tabIndex = index);
    _pageController.jumpToPage(index);
  }

  handlePageChanged(int index) {
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          bottom: PreferredSize(
            preferredSize: Size(360.w, 36.w),
            child: Tabs(activeKey: _tabIndex, onChanged: handleChangeTabIndex, tabList: _tabs),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await Get.to(
                  fullscreenDialog: true,
                  SearchPage(author: false, title: widget.title),
                );
              },
              child: Icon(QmIcons.search, color: const Color(0xFF333333), size: 24.sp),
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: handlePageChanged,
          children: [for (final item in _tabs) TabPanel(status: item.status)],
        ),
      ),
    );
  }
}
