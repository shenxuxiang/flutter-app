import 'search_input_box.dart';
import 'easy_refresh_footer.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

/// 这是一个搜索的公共页面组件
class SearchPage extends BasePage {
  /// 默认水平方向的内边距为 12.w
  final EdgeInsets? sliverPadding;

  /// 当传入的 gridDelegate 不是 null 时，将使用 SliverGrid 来构建列表，
  /// 当 gridDelegate 为 null 时，则使用 SliverList 来构建列表，
  final SliverGridDelegate? gridDelegate;

  /// 可以通过 query 来修改参数
  final Future<ResponseData> Function(dynamic query) queryResourceList;

  /// 构建列表项
  final Widget Function(BuildContext context, dynamic data) itemBuilder;

  /// initState 回调
  final VoidCallback? onInitState;

  /// dispose 回调
  final VoidCallback? onDispose;

  const SearchPage({
    super.key,
    this.onDispose,
    this.onInitState,
    this.gridDelegate,
    this.sliverPadding,
    required super.title,
    required super.author,
    required this.itemBuilder,
    required this.queryResourceList,
  });

  @override
  BasePageState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends BasePageState<SearchPage> {
  int _pageNum = 1;
  String _keywords = '';
  final int _pageSize = 10;

  final List<dynamic> _resourceList = [];
  final ScrollController _scrollController = ScrollController();
  final EasyRefreshController _controller = EasyRefreshController(controlFinishLoad: true);

  @override
  onLoad() {
    widget.onInitState?.call();
  }

  @override
  onUnload() {
    widget.onDispose?.call();
  }

  handleSearch(String value) async {
    CloseLoading closeLoading = Loading.show();
    _keywords = value;
    await handleQueryProductList(1);
    closeLoading();
  }

  /// 获取产品列表
  Future<void> handleQueryProductList(int pageNum) async {
    final params = {'pageNum': pageNum, 'keyword': _keywords, 'pageSize': _pageSize};

    try {
      final resp = await widget.queryResourceList(params);
      final list = resp.data['list'] ?? [];
      final loadResult = list.length < _pageSize ? IndicatorResult.noMore : IndicatorResult.success;

      setState(() {
        _pageNum = pageNum;
        if (pageNum == 1) _resourceList.clear();
        _resourceList.addAll(list);
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

  Widget itemBuilder(BuildContext context, int idx) {
    final p = _resourceList[idx];
    return widget.itemBuilder(context, p);
  }

  renderDOM() {
    if (_resourceList.isEmpty) {
      return [
        const SliverPadding(padding: EdgeInsets.only(top: 105)),
        const SliverToBoxAdapter(child: Center(child: EmptyWidget(size: 60, text: '没有找到匹配的结果'))),
      ];
    } else {
      return [
        SliverPadding(
          padding: widget.sliverPadding ?? EdgeInsets.symmetric(horizontal: 12.w),
          sliver:
              widget.gridDelegate == null
                  ? SliverList.builder(itemBuilder: itemBuilder, itemCount: _resourceList.length)
                  : SliverGrid.builder(
                    itemBuilder: itemBuilder,
                    itemCount: _resourceList.length,
                    gridDelegate: widget.gridDelegate!,
                  ),
        ),
        SliverPadding(padding: EdgeInsets.only(top: 12.w)),
        const FooterLocator.sliver(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52.w),
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.w),
              child: SearchInputBox(onSearch: handleSearch),
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
