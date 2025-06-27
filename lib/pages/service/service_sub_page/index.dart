import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/order.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';
import 'package:qm_agricultural_machinery_services/components/search_page.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/entity/service_filter_type.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/utils/filter_service_drawer_modal.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/filter_type.dart';
import 'package:qm_agricultural_machinery_services/pages/service/service_sub_page/app_bar_bottom.dart';

class SubPage extends BasePage {
  /// 100-农资服务; 101-农机服务;102-植保服务;103-劳务服务;104-土地流转
  final String categoryID;
  final Widget Function(BuildContext context, dynamic data) goodsItemBuilder;

  const SubPage({
    super.key,
    required super.title,
    required super.author,
    required this.categoryID,
    required this.goodsItemBuilder,
  });

  @override
  BasePageState<SubPage> createState() => _SubPageState();
}

class _SubPageState extends BasePageState<SubPage> {
  int _pageNum = 0;
  String _endPrice = '';
  String _startPrice = '';
  ServiceFilterType? _selectedFilterType;
  OrderStatus _saleOrder = OrderStatus.none;
  OrderStatus _priceOrder = OrderStatus.none;
  List<SelectedTreeNode> _selectedRegion = [];
  final int _pageSize = 30;
  final List<dynamic> _productList = [];
  final mainModel = Get.find<MainModel>();
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  @override
  void onLoad() {
    /// 每次进入页面时，更新服务大类
    mainModel.queryServiceSubCategory();
    super.onLoad();
  }

  @override
  onMounted() async {
    final closeLoading = Loading.show();

    /// 数据初始化
    await handleQueryProductList(_pageNum + 1);
    closeLoading();
  }

  @override
  onUnload() {
    _controller.dispose();
    _scrollController.dispose();
  }

  /// 获取产品列表
  Future<void> handleQueryProductList(int pageNum) async {
    // 计算排序
    final orders =
        [
          'price,${_priceOrder == OrderStatus.none
              ? 'none'
              : _priceOrder == OrderStatus.asc
              ? 'asc'
              : 'desc'}',
          'sales,${_saleOrder == OrderStatus.none
              ? 'none'
              : _saleOrder == OrderStatus.asc
              ? 'asc'
              : 'desc'}',
        ].where((item) => !item.endsWith(',none')).toList();

    final params = {
      'keyword': '',
      'orders': orders,
      'pageNum': pageNum,
      'pageSize': _pageSize,
      'endPrice': _endPrice,
      'startPrice': _startPrice,
      // 大类，大类用来区分不同的页面
      'parentServiceSubcategoryId': widget.categoryID,
      // 子类，表示该页面下面筛选数据的类型，比如：农药、化肥、种子、其他
      'serviceSubcategoryId': _selectedFilterType?.value ?? '',
      'regionCode': _selectedRegion.isNotEmpty ? _selectedRegion.last.value : '',
    };

    try {
      final resp = await api.queryServiceProductList(params);
      final data = resp.data;

      if (!mounted) return;

      setState(() {
        _pageNum = pageNum;
        if (pageNum == 1) _productList.clear();
        _productList.addAll(data['list'] ?? []);
      });

      IndicatorResult indicatorResult =
          _productList.length >= int.parse(data['total'])
              ? IndicatorResult.noMore
              : IndicatorResult.success;

      _controller.finishLoad(indicatorResult);
      if (pageNum == 1) _controller.finishRefresh(indicatorResult);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      _controller.finishLoad(IndicatorResult.fail);
      if (pageNum == 1) _controller.finishRefresh(IndicatorResult.fail);
    }
  }

  /// 刷新数据
  handleRefresh() async {
    final closeLoading = Loading.show();
    await handleQueryProductList(1);
    printLog('END');
    _scrollController.jumpTo(0);
    closeLoading();
  }

  onRefreshData() async {
    await handleQueryProductList(1);
  }

  /// 加载更多数据
  onLoadData() async {
    await handleQueryProductList(_pageNum + 1);
  }

  /// 更新价格排序、销量排序、筛选条件
  _handleChangeOrders(String key, [OrderStatus? order]) async {
    if (key == 'filter') {
      FilterServiceDrawerModal.show(
        onChanged: handleChangeFilterConditional,
        categoryId: widget.categoryID,
        type: _selectedFilterType,
        region: _selectedRegion,
        startPrice: _startPrice,
        endPrice: _endPrice,
      );

      return;
    }

    if (key == 'price') {
      setState(() {
        _priceOrder = order!;
        _saleOrder = OrderStatus.none;
      });
    } else if (key == 'sale') {
      setState(() {
        _saleOrder = order!;
        _priceOrder = OrderStatus.none;
      });
    }

    /// 页面数据刷新，pageNum = 1
    handleRefresh();
  }

  /// 更新筛选条件
  handleChangeFilterConditional(FilterConditional value) {
    setState(() {
      _selectedRegion = value.region;
      _endPrice = value.rangePrice[1];
      _selectedFilterType = value.type;
      _startPrice = value.rangePrice[0];
    });

    /// 页面数据刷新，pageNum = 1
    handleRefresh();
  }

  /// 更新筛选类型，这是【100-农资服务】页面特有的。101、102、103 页面没有。
  void handleChangeFilterType(ServiceFilterType? type) {
    setState(() => _selectedFilterType = type);
    handleRefresh();
  }

  renderAppBarBottom() {
    return widget.categoryID == '100'
        ? SliverAppBar(
          snap: true,
          elevation: 0,
          floating: true,
          toolbarHeight: 95.w,
          scrolledUnderElevation: 0,
          actions: [const SizedBox()],
          automaticallyImplyLeading: false,
          flexibleSpace: FilterTypeWidget(
            value: _selectedFilterType,
            onChanged: handleChangeFilterType,
          ),
        )
        : const SliverPadding(padding: EdgeInsets.zero);
  }

  Future<ResponseData> queryResourceList(dynamic query) async {
    query['parentServiceSubcategoryId'] = widget.categoryID;
    return api.queryServiceProductList(query);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        key: _globalKey,
        backgroundColor: Colors.transparent,
        endDrawerEnableOpenDragGesture: false,
        appBar: HeaderNavBar(
          title: widget.title,
          actions: [
            GestureDetector(
              onTap: () {
                Get.to(
                  SearchPage(
                    author: true,
                    title: widget.title,
                    queryResourceList: queryResourceList,
                    itemBuilder: widget.goodsItemBuilder,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.w,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.635,
                    ),
                  ),
                  fullscreenDialog: true,
                );
              },
              child: Icon(QmIcons.search, color: const Color(0xFF333333), size: 24.sp),
            ),
            SizedBox(width: 8.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(34.w),
            child: AppBarBottom(
              saleOrder: _saleOrder,
              priceOrder: _priceOrder,
              onChanged: _handleChangeOrders,
              isActive:
                  _endPrice.isNotEmpty ||
                  _startPrice.isNotEmpty ||
                  _selectedRegion.isNotEmpty ||
                  (_selectedFilterType?.value ?? '') != '',
            ),
          ),
        ),

        body: EasyRefresh(
          onLoad: onLoadData,
          controller: _controller,
          onRefresh: onRefreshData,
          canLoadAfterNoMore: false,
          canRefreshAfterNoMore: true,
          footer: EasyRefreshFooter(controller: _controller),
          header: const CupertinoHeader(position: IndicatorPosition.locator),
          child: CustomScrollView(
            controller: _scrollController,
            slivers:
                _productList.isEmpty
                    ? [
                      renderAppBarBottom(),
                      const SliverPadding(padding: EdgeInsets.only(top: 100)),
                      const SliverToBoxAdapter(child: EmptyWidget()),
                    ]
                    : [
                      renderAppBarBottom(),
                      const HeaderLocator.sliver(),
                      SliverPadding(padding: EdgeInsets.only(top: 12.w)),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        sliver: SliverGrid.builder(
                          itemCount: _productList.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.w,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 0.635,
                          ),
                          itemBuilder: (BuildContext context, int idx) {
                            final p = _productList[idx];
                            return widget.goodsItemBuilder(context, p);
                          },
                        ),
                      ),
                      SliverPadding(padding: EdgeInsets.only(top: 12.w)),
                      const FooterLocator.sliver(),
                    ],
          ),
        ),
      ),
    );
  }
}
