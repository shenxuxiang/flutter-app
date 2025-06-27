import 'search_page.dart';
import 'demand_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_category.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/entity/demand_sub_category.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';
import 'package:qm_agricultural_machinery_services/utils/filter_demand_drawer_modal.dart';

class MyDemandPage extends BasePage {
  const MyDemandPage({super.key, required super.author, required super.title});

  @override
  State<MyDemandPage> createState() => _MyDemandPageState();
}

class _MyDemandPageState extends BasePageState<MyDemandPage> {
  late final EasyRefreshController easyRefreshController;
  final List<dynamic> resourceList = [];
  final int pageSize = 20;

  int pageNum = 0;
  bool isLoading = true;
  ListItemOption? publishStatus;
  DemandCategory? demandCategory;
  DemandSubCategory? demandSubCategory;

  bool get computedSearchConditionIsEmpty =>
      (publishStatus?.value.isEmpty ?? true) &&
      (demandCategory?.demandCategoryId.isEmpty ?? true) &&
      (demandSubCategory?.demandSubcategoryId.isEmpty ?? true);

  @override
  void onLoad() {
    easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
      controlFinishRefresh: true,
    );
    handleQueryMyDemandList(1);
    eventBus.add('MyDemandUpdateQueue.republish', handleRepublish);
    eventBus.add('MyDemandUpdateQueue.deleted', handleDeletePublish);
    eventBus.add('MyDemandUpdateQueue.canceled', handleCancelPublish);
  }

  @override
  onUnload() {
    eventBus.off('MyDemandUpdateQueue.republish', handleRepublish);
    eventBus.off('MyDemandUpdateQueue.deleted', handleDeletePublish);
    eventBus.off('MyDemandUpdateQueue.canceled', handleCancelPublish);
  }

  handleRepublish([dynamic detail]) {
    final serviceId = detail['serviceId'];
    final filterResult = resourceList.where((item) => item['serviceId'] == serviceId).toList();

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
  handleCancelPublish([dynamic serviceId]) {
    final target = resourceList.where((it) => it['serviceId'] == serviceId);
    if (target.isEmpty) return;

    target.first['status'] = 2;
    target.first['statusName'] = '已下架';
    setState(() {});
  }

  /// 删除需求发布
  handleDeletePublish([dynamic serviceId]) {
    resourceList.removeWhere((it) => it['serviceId'] == serviceId);

    setState(() {});
  }

  handleQueryMyDemandList(int num) async {
    final params = {
      'pageNum': num,
      'pageSize': pageSize,
      'status': publishStatus?.value,
      'demandCategoryId': demandCategory?.demandCategoryId,
      'demandSubcategoryId': demandSubCategory?.demandSubcategoryId,
    };

    try {
      final resp = await queryMyDemandList(params);

      if (!mounted) return;
      if (num == 1) resourceList.clear();

      final data = resp.data;
      final total = int.parse(data['total']);

      pageNum = num;
      isLoading = false;
      resourceList.addAll(data['list']);
      easyRefreshController.finishLoad(
        resourceList.length >= total ? IndicatorResult.noMore : IndicatorResult.success,
      );
      setState(() {});
    } catch (error, stack) {
      easyRefreshController.finishLoad(IndicatorResult.fail);
      printLog(error);
      printLog(stack);
    }
  }

  handleLoadResource() async {
    await handleQueryMyDemandList(pageNum + 1);
  }

  handleOpenFilterModal() {
    FilterDemandDrawerModal.show(
      publishStatus: publishStatus,
      demandCategory: demandCategory,
      demandSubCategory: demandSubCategory,
      onChanged: (Map<String, dynamic> data) {
        publishStatus = data['status'];
        demandCategory = data['demandCategory'];
        demandSubCategory = data['demandSubCategory'];
        handleQueryMyDemandList(1);
        setState(() {});
      },
    );
  }

  handleSearch() {
    Get.to(fullscreenDialog: true, const SearchPage(title: '我的需求', author: true));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(
          title: widget.title,
          actions: [
            GestureDetector(
              onTap: handleOpenFilterModal,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 6.w),
                child: Row(
                  children: [
                    Text(
                      '筛选',
                      style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4A4A4A), height: 1),
                    ),
                    Icon(
                      QmIcons.filter,
                      size: 16.sp,
                      color:
                          computedSearchConditionIsEmpty ? const Color(0xFF4A4A4A) : primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: handleSearch,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 8.w),
                child: Icon(QmIcons.search, size: 24.sp, color: const Color(0xFF333333)),
              ),
            ),
          ],
        ),
        body: EasyRefresh(
          controller: easyRefreshController,
          onLoad: handleLoadResource,
          footer: EasyRefreshFooter(controller: easyRefreshController),
          child: CustomScrollView(
            slivers:
                isLoading
                    ? [const SliverToBoxAdapter(child: SkeletonScreen())]
                    : resourceList.isEmpty
                    ? [
                      SliverPadding(padding: EdgeInsets.only(top: 100.w)),
                      const SliverToBoxAdapter(child: EmptyWidget(size: 60)),
                    ]
                    : [
                      SliverList.builder(
                        itemCount: resourceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DemandItem(dataSource: resourceList[index]);
                        },
                      ),
                      const FooterLocator.sliver(),
                    ],
          ),
        ),
      ),
    );
  }
}
