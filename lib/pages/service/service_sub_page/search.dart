import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';

import '../../../components/easy_refresh_footer.dart';
import 'input_search.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';

class SearchPage extends BasePage {
  final String categoryID;
  final Widget Function(BuildContext context, dynamic data) goodsItemBuilder;

  const SearchPage({
    super.key,
    required super.title,
    required super.author,
    required this.categoryID,
    required this.goodsItemBuilder,
  });

  @override
  BasePageState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage> {
  int _pageNum = 1;
  final int _pageSize = 10;
  String _searchKeyword = '';

  final List<dynamic> _productList = [];
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController _controller = EasyRefreshController(controlFinishLoad: true);

  handleSearch(String value) {
    _searchKeyword = value;
    handleQueryProductList(1);
  }

  /// 获取产品列表
  Future<void> handleQueryProductList(int pageNum) async {
    final params = {
      'pageSize': 10,
      'pageNum': pageNum,
      'keyword': _searchKeyword,
      // 大类，大类用来区分不同的页面
      'parentServiceSubcategoryId': widget.categoryID,
    };

    try {
      final resp = await api.queryServiceProductList(params);
      final list = resp.data['list'] ?? [];
      final loadResult = list.length < _pageSize ? IndicatorResult.noMore : IndicatorResult.success;

      setState(() {
        _pageNum = pageNum;
        if (pageNum == 1) _productList.clear();
        _productList.addAll(list);
      });
      _controller.finishLoad(loadResult);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      _controller.finishLoad(IndicatorResult.fail);
    }
  }

  /// 加载更多数据
  handleLoad() async {
    await handleQueryProductList(_pageNum + 1);
  }

  renderDOM() {
    if (_productList.isEmpty) {
      return [
        const SliverPadding(padding: EdgeInsets.only(top: 105)),
        const SliverToBoxAdapter(child: Center(child: EmptyWidget(size: 60, text: '没有找到匹配的结果'))),
      ];
    } else {
      return [
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
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Text(widget.title),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(QmIcons.back, color: const Color(0xFF333333), size: 24.sp),
          ),
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
          controller: _controller,
          footer: EasyRefreshFooter(controller: _controller),
          child: CustomScrollView(controller: _scrollController, slivers: renderDOM()),
        ),
      ),
    );
  }
}
