import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/pages/home/goods_item.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;
import 'package:qm_agricultural_machinery_services/api/home.dart' show queryNewsList;
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';

class PageItem extends StatefulWidget {
  final String type;

  const PageItem({super.key, required this.type});

  @override
  State<PageItem> createState() => _PageItemState();
}

class _PageItemState extends State<PageItem> {
  late final EasyRefreshController _easyRefreshController;
  final List<dynamic> _resourceList = [];
  final int _pageSize = 20;
  bool _isLoading = true;
  int _pageNum = 0;

  @override
  void initState() {
    _easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    handleQueryKnowledgeList(1);
    super.initState();
  }

  handleQueryKnowledgeList(int pageNum) async {
    try {
      final resp = await queryNewsList({
        'pageNum': pageNum,
        'type': widget.type,
        'pageSize': _pageSize,
      });

      if (!mounted) return;

      final data = resp.data;
      if (pageNum == 1) _resourceList.clear();
      setState(() {
        _pageNum = pageNum;
        _resourceList.addAll(data['list']);
      });

      IndicatorResult indicatorResult =
          _resourceList.length >= int.parse(data['total'])
              ? IndicatorResult.noMore
              : IndicatorResult.success;

      _easyRefreshController.finishLoad(indicatorResult);
      if (pageNum == 1) _easyRefreshController.finishRefresh(indicatorResult);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      _easyRefreshController.finishLoad(IndicatorResult.fail);
      if (pageNum == 1) _easyRefreshController.finishRefresh(IndicatorResult.fail);
    } finally {
      if (_isLoading && mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> handleRefresh() async {
    handleQueryKnowledgeList(1);
  }

  Future<void> handleLoad() async {
    handleQueryKnowledgeList(_pageNum + 1);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onLoad: handleLoad,
      onRefresh: handleRefresh,
      canLoadAfterNoMore: false,
      canRefreshAfterNoMore: true,
      header: const CupertinoHeader(),
      controller: _easyRefreshController,
      footer: EasyRefreshFooter(controller: _easyRefreshController),
      child: CustomScrollView(
        slivers:
            _isLoading
                ? [const SliverToBoxAdapter(child: SkeletonScreen())]
                : [
                  SliverPadding(padding: EdgeInsets.only(top: 12.w)),
                  SliverList.builder(
                    itemCount: _resourceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _resourceList[index];
                      return GoodsItem(
                        title: item['title'],
                        img: item['primaryUrl'],
                        date: item['updateTime'],
                        id: '${item['policyInformationId']}',
                      );
                    },
                  ),
                  const FooterLocator.sliver(),
                ],
      ),
    );
  }
}
