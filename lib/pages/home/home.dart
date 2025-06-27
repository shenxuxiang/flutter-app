import 'banner.dart';
import 'constant.dart';
import 'goods_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/api/home.dart' as api;
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/components/ai_robot.dart';
import 'package:qm_agricultural_machinery_services/components/menu_list.dart';
import 'package:qm_agricultural_machinery_services/components/module_title.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  int _pageNum = 1;
  int _bannerIndex = 0;
  final int _pageSize = 5;
  final List<dynamic> _newList = [];
  final List<dynamic> _bannerList = [];
  final mainModel = Get.find<MainModel>();
  late final EasyRefreshController _easyRefreshController;
  final _menus = menus.map((item) => MenuItemOption.fromJson(item)).toList();

  @override
  initState() {
    _easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );

    Future.wait([handleQueryNewList(1), handleQueryBannerList()]).then((responses) {
      setState(() => _loading = false);
    });

    super.initState();
  }

  /// 获取首页 Banner
  Future<void> handleQueryBannerList() async {
    try {
      final resp = await api.queryBannerList();
      setState(() {
        _bannerIndex = 0;
        _bannerList.clear();
        _bannerList.addAll(resp.data.map((item) => item['imageUrl']));
      });
    } catch (error, stack) {
      printLog('$error');
      printLog('$stack');
    }
  }

  /// 请求新闻咨询列表
  Future<void> handleQueryNewList(int pageNum) async {
    try {
      final resp = await api.queryNewsList({'pageSize': _pageSize, 'pageNum': pageNum});
      final data = resp.data;
      final list = data['list'] ?? [];
      final loadStatus = _pageSize > list.length ? IndicatorResult.noMore : IndicatorResult.success;
      setState(() {
        if (pageNum == 1) _newList.clear();
        _pageNum = pageNum;
        _newList.addAll(list);
      });
      _easyRefreshController.finishLoad(loadStatus);
      if (pageNum == 1) _easyRefreshController.finishRefresh(IndicatorResult.success);
    } catch (error, stack) {
      printLog('$error');
      printLog('$stack');
      _easyRefreshController.finishLoad(IndicatorResult.fail);
      if (pageNum == 1) _easyRefreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> handleLoad() async {
    _pageNum++;
    handleQueryNewList(_pageNum + 1);
  }

  Future<void> handleRefresh() async {
    handleQueryBannerList();
    handleQueryNewList(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('首页'), scrolledUnderElevation: 0),
      body: EasyRefresh.builder(
        canLoadAfterNoMore: false,
        canRefreshAfterNoMore: true,
        header: const CupertinoHeader(),
        controller: _easyRefreshController,
        onRefresh: _loading ? null : handleRefresh,
        childBuilder: (BuildContext context, ScrollPhysics physics) {
          return CustomScrollView(
            physics: physics,
            slivers:
                _loading
                    ? [const SliverToBoxAdapter(child: SkeletonScreen())]
                    : [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 154.w,
                          width: double.infinity,
                          child: BannerWidget(
                            index: _bannerIndex,
                            bannerList: _bannerList,
                            onChanged: (idx) {
                              setState(() => _bannerIndex = idx);
                            },
                          ),
                        ),
                      ),
                      SliverPadding(padding: EdgeInsets.only(top: 11.w)),
                      SliverToBoxAdapter(child: MenuListWidget(menus: _menus)),
                      const SliverToBoxAdapter(
                        child: ModuleTitle(link: '/policy_information', title: '农业资讯'),
                      ),
                      SliverList.builder(
                        itemCount: _newList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GoodsItem(
                            title: _newList[index]['title'],
                            img: _newList[index]['primaryUrl'],
                            date: _newList[index]['updateTime'],
                            id: '${_newList[index]['policyInformationId']}',
                          );
                        },
                      ),
                    ],
          );
        },
      ),
      floatingActionButton: const AiRobot(),
    );
  }
}
