import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/api/service.dart' show queryUserOrderList;
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/input_search.dart';

import '../../utils/event_bus.dart';
import 'order_item.dart';

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
  initState() {
    eventBus.add('OrderUpdateQueue.canceled', handleOrderCanceled);
    eventBus.add('OrderUpdateQueue.completed', handleOrderCompleted);
    super.initState();
  }

  @override
  dispose() {
    eventBus.off('OrderUpdateQueue.canceled', handleOrderCanceled);
    eventBus.off('OrderUpdateQueue.completed', handleOrderCompleted);
    super.dispose();
  }

  handleSearch(String value) {
    _searchKeyword = value;
    handleQueryUserOrderList(1);
  }

  /// 获取订单列表
  Future<void> handleQueryUserOrderList(int pageNum) async {
    try {
      final resp = await queryUserOrderList({
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
    await handleQueryUserOrderList(_pageNum + 1);
  }

  handleOrderCompleted([dynamic serviceOrderId]) {
    final order = _resourceList.where((item) => item['serviceOrderId'] == serviceOrderId).first;
    setState(() {
      order['status'] = 4;
      order['statusName'] = '已完结';
    });
  }

  handleOrderCanceled([dynamic serviceOrderId]) {
    final order = _resourceList.where((item) => item['serviceOrderId'] == serviceOrderId).first;
    setState(() {
      order['status'] = 5;
      order['statusName'] = '已取消';
    });
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
            return OrderItem(
              count: data['count'],
              status: data['status'],
              picUrl: data['picUrl'],
              orderCode: data['orderCode'],
              priceUnit: data['priceUnit'],
              serverName: data['serverName'],
              statusName: data['statusName'],
              price: data['price'].toString(),
              productName: data['productName'],
              amount: data['amount'].toDouble(),
              serviceOrderId: data['serviceOrderId'],
              serviceSubcategoryName: data['serviceSubcategoryName'],
            );
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
