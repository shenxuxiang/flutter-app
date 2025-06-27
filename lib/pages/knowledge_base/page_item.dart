import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/pages/knowledge_base/knowledge_item.dart';
import 'package:qm_agricultural_machinery_services/api/technology.dart' show queryKnowledgeList;

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
      final params = {'pageNum': pageNum, 'type': widget.type, 'pageSize': _pageSize};
      final resp = await queryKnowledgeList(params);
      final data = resp.data;

      if (!mounted) return;

      setState(() {
        if (pageNum == 1) _resourceList.clear();

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

  onLoad() {
    handleQueryKnowledgeList(_pageNum + 1);
  }

  onRefresh() {
    handleQueryKnowledgeList(1);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onLoad: onLoad,
      canLoadAfterNoMore: false,
      canRefreshAfterNoMore: true,
      header: const CupertinoHeader(),
      controller: _easyRefreshController,
      onRefresh: _isLoading ? null : onRefresh,
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
                      return KnowledgeItem(info: item);
                    },
                  ),
                  const FooterLocator.sliver(),
                ],
      ),
    );
  }
}
