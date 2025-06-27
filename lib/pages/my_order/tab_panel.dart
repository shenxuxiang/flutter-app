import 'order_item.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/api/service.dart' show queryUserOrderList;

class TabPanel extends StatefulWidget {
  final int? status;

  const TabPanel({super.key, this.status});

  @override
  State<TabPanel> createState() => _TabPanelState();
}

class _TabPanelState extends State<TabPanel> {
  int _pageNum = 0;
  bool _loading = true;
  final int _pageSize = 20;
  final List<dynamic> _resourceList = [];
  late final EasyRefreshController _easyRefreshController;

  @override
  void initState() {
    _easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    handleQueryUserOrderList(_pageNum + 1);

    eventBus.add('OrderUpdateQueue.canceled', handleOrderCanceled);
    eventBus.add('OrderUpdateQueue.completed', handleOrderCompleted);
    super.initState();
  }

  @override
  void dispose() {
    eventBus.off('OrderUpdateQueue.canceled', handleOrderCanceled);
    eventBus.off('OrderUpdateQueue.completed', handleOrderCompleted);
    _easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> handleLoadResource() async {
    handleQueryUserOrderList(_pageNum + 1);
  }

  Future<void> handleQueryUserOrderList(int pageNum) async {
    try {
      final resp = await queryUserOrderList({
        'pageNum': pageNum,
        'pageSize': _pageSize,
        'status': widget.status,
      });
      if (!mounted) return;
      final data = resp.data;
      setState(() {
        if (_loading) _loading = false;
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
      if (_loading) setState(() => _loading = false);
      _easyRefreshController.finishLoad(IndicatorResult.fail);
    }
  }

  handleOrderCompleted([dynamic serviceOrderId]) {
    if (widget.status == null) {
      final orders = _resourceList.where((item) => item['serviceOrderId'] == serviceOrderId);
      if (orders.isEmpty) return;
      final order = orders.first;
      setState(() {
        order['status'] = 4;
        order['statusName'] = '已完结';
      });
    } else {
      setState(() {
        _resourceList.removeWhere((item) => item['serviceOrderId'] == serviceOrderId);
      });
    }
  }

  handleOrderCanceled([dynamic serviceOrderId]) {
    if (widget.status == null) {
      final orders = _resourceList.where((item) => item['serviceOrderId'] == serviceOrderId);
      if (orders.isEmpty) return;
      final order = orders.first;
      setState(() {
        order['status'] = 5;
        order['statusName'] = '已取消';
      });
    } else {
      setState(() {
        _resourceList.removeWhere((item) => item['serviceOrderId'] == serviceOrderId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onLoad: handleLoadResource,
      controller: _easyRefreshController,
      footer: EasyRefreshFooter(controller: _easyRefreshController),
      child: CustomScrollView(
        slivers:
            _loading
                ? [const SliverToBoxAdapter(child: SkeletonScreen())]
                : [
                  SliverList.builder(
                    itemCount: _resourceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = _resourceList[index];
                      return OrderItem(
                        count: data['count'],
                        status: data['status'],
                        amount: data['amount'].toDouble(),
                        picUrl: data['picUrl'],
                        orderCode: data['orderCode'],
                        priceUnit: data['priceUnit'],
                        serverName: data['serverName'],
                        statusName: data['statusName'],
                        price: data['price'].toString(),
                        productName: data['productName'],
                        serviceOrderId: data['serviceOrderId'],
                        serviceSubcategoryName: data['serviceSubcategoryName'],
                      );
                    },
                  ),
                  const FooterLocator.sliver(),
                ],
      ),
    );
  }
}
