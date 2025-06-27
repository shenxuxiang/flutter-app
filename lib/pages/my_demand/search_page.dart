import 'demand_item.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart' show queryMyDemandList;
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/input_search.dart';

class SearchPage extends BasePage {
  const SearchPage({super.key, required super.title, required super.author});

  @override
  BasePageState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage> {
  int _pageNum = 1;
  final int _pageSize = 20;
  String _searchKeyword = '';

  final List<dynamic> _resourceList = [];
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController _easyRefreshController = EasyRefreshController(
    controlFinishLoad: true,
  );

  @override
  onLoad() {
    eventBus.add('MyDemandUpdateQueue.republish', handleRepublish);
    eventBus.add('MyDemandUpdateQueue.deleted', handleDeleteRepublish);
    eventBus.add('MyDemandUpdateQueue.canceled', handleCancelRepublish);
  }

  @override
  onUnload() {
    eventBus.off('MyDemandUpdateQueue.republish', handleRepublish);
    eventBus.off('MyDemandUpdateQueue.deleted', handleDeleteRepublish);
    eventBus.off('MyDemandUpdateQueue.canceled', handleCancelRepublish);
  }

  handleSearch(String value) {
    _searchKeyword = value;
    handleQueryMyDemandList(1);
  }

  /// 获取订单列表
  Future<void> handleQueryMyDemandList(int pageNum) async {
    try {
      final resp = await queryMyDemandList({
        'pageNum': pageNum,
        'pageSize': _pageSize,
        'keyword': _searchKeyword,
      });
      if (!mounted) return;

      final data = resp.data;
      setState(() {
        if (pageNum == 1) _resourceList.clear();

        _pageNum = pageNum;
        _resourceList.addAll(data['list']);
        _easyRefreshController.finishLoad(
          _resourceList.length >= int.parse(data['total'])
              ? IndicatorResult.noMore
              : IndicatorResult.success,
        );
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      _easyRefreshController.finishLoad(IndicatorResult.fail);
    }
  }

  /// 加载更多数据
  handleLoad() async {
    await handleQueryMyDemandList(_pageNum + 1);
  }

  handleRepublish([dynamic detail]) {
    final serviceId = detail['serviceId'];
    final filterResult = _resourceList.where((item) => item['serviceId'] == serviceId).toList();

    if (filterResult.isNotEmpty) {
      final item = filterResult.first;
      setState(() {
        item['status'] = detail['status'];
        item['statusName'] = detail['statusName'];
        item['regionName'] = detail['regionName'];
        item['regionCode'] = detail['regionCode'];
        item['updateTime'] = detail['updateTime'];
        item['serviceTitle'] = detail['serviceTitle'];
        item['serviceEndTime'] = detail['serviceEndTime'];
        item['serviceStartTime'] = detail['serviceStartTime'];
        item['demandCategoryName'] = detail['demandCategoryName'];
        item['contactPersonAddress'] = detail['contactPersonAddress'];
        item['demandSubcategoryName'] = detail['demandSubcategoryName'];
      });
    }
  }

  /// 取消发布
  handleCancelRepublish([dynamic serviceId]) {
    final target = _resourceList.where((it) => it['serviceId'] == serviceId);
    if (target.isEmpty) return;

    target.first['status'] = 2;
    target.first['statusName'] = '已下架';
    setState(() {});
  }

  /// 删除需求发布
  handleDeleteRepublish([dynamic serviceId]) {
    _resourceList.removeWhere((it) => it['serviceId'] == serviceId);

    setState(() {});
  }

  renderDOM() {
    if (_resourceList.isEmpty) {
      return [
        const SliverPadding(padding: EdgeInsets.only(top: 105)),
        const SliverToBoxAdapter(child: Center(child: EmptyWidget(size: 60, text: '没有找到匹配的结果'))),
      ];
    } else {
      return [
        SliverList.builder(
          itemCount: _resourceList.length,
          itemBuilder: (BuildContext context, int idx) {
            final data = _resourceList[idx];
            return DemandItem(dataSource: data);
          },
        ),
        const FooterLocator.sliver(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
          image: AssetImage('assets/images/home_bg.png'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52.w),
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.w),
              child: InputSearch(onSearch: handleSearch),
            ),
          ),
        ),
        body: EasyRefresh(
          onLoad: handleLoad,
          controller: _easyRefreshController,
          footer: EasyRefreshFooter(controller: _easyRefreshController),
          child: CustomScrollView(controller: _scrollController, slivers: renderDOM()),
        ),
      ),
    );
  }
}
