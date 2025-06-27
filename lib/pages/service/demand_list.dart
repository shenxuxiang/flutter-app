import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/easy_refresh_footer.dart';

import '../../components/badge.dart';

class DemandList extends StatefulWidget {
  final String categoryId;

  const DemandList({super.key, required this.categoryId});

  @override
  State<DemandList> createState() => _DemandListState();
}

class _DemandListState extends State<DemandList> {
  late final EasyRefreshController controller;
  final List<dynamic> resourceList = [];
  final pageSize = 20;

  String categoryId = '';
  int pageNum = 0;

  @override
  void initState() {
    categoryId = Get.parameters['id'] ?? '';
    controller = EasyRefreshController(controlFinishLoad: true, controlFinishRefresh: true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final closeLoading = Loading.show();
      await handleQueryMyDemandList(1);
      closeLoading();
    });
    super.initState();
  }

  /// 获取订单列表
  Future<void> handleQueryMyDemandList(int pageNum) async {
    try {
      final params = {
        'pageNum': pageNum,
        'pageSize': pageSize,
        'demandCategoryId': widget.categoryId,
      };
      final resp = await queryHallDemandList(params);
      if (!mounted) return;

      final data = resp.data;

      setState(() {
        if (pageNum == 1) resourceList.clear();

        pageNum = pageNum;
        resourceList.addAll(data['list']);
      });

      IndicatorResult indicatorResult =
          resourceList.length >= int.parse(data['total'])
              ? IndicatorResult.noMore
              : IndicatorResult.success;

      controller.finishLoad(indicatorResult);
      if (pageNum == 1) controller.finishRefresh(indicatorResult);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      controller.finishLoad(IndicatorResult.fail);
      controller.finishRefresh(IndicatorResult.fail);
    }
  }

  /// 加载更多数据
  handleLoad() async {
    await handleQueryMyDemandList(pageNum + 1);
  }

  /// 刷新数据
  handleRefresh() async {
    await handleQueryMyDemandList(1);
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      onLoad: handleLoad,
      controller: controller,
      onRefresh: handleRefresh,
      canLoadAfterNoMore: false,
      canRefreshAfterNoMore: true,
      header: const CupertinoHeader(),
      footer: EasyRefreshFooter(controller: controller),
      child: CustomScrollView(
        slivers:
            resourceList.isEmpty
                ? [
                  const SliverPadding(padding: EdgeInsets.only(top: 50)),
                  const SliverToBoxAdapter(child: EmptyWidget()),
                ]
                : [
                  SliverList.builder(
                    itemCount: resourceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return DemandItem(data: resourceList[index]);
                    },
                  ),
                  const FooterLocator.sliver(),
                ],
      ),
    );
  }
}

class DemandItem extends StatelessWidget {
  final dynamic data;

  const DemandItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        Get.toNamed('/service/demand_detail?id=${data['serviceId']}');
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 12.w),
        padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 12.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child:
                      data['farmerAvatar']?.isEmpty ?? false
                          ? Image.asset(
                            'assets/images/default_avatar.png',
                            width: 53.w,
                            height: 53.w,
                            fit: BoxFit.cover,
                          )
                          : CachedNetworkImage(
                            width: 53.w,
                            height: 53.w,
                            fit: BoxFit.cover,
                            imageUrl: getNetworkAssetURL(data['farmerAvatar']),
                          ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['farmerName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 6.w),
                      Row(
                        children: [
                          Icon(
                            QmIcons.confirm,
                            size: 22.sp,
                            color:
                                data['serverUserType'] == '农户'
                                    ? primaryColor
                                    : const Color(0xFF333333),
                          ),
                          Expanded(
                            child: Text(
                              data['serverUserType'],
                              style: TextStyle(
                                height: 1,
                                fontSize: 16.sp,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                          BadgeWidget(radius: 14.w, title: data['demandSubcategoryName']),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.w),
            const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
            SizedBox(height: 12.w),
            Text(
              data['serviceTitle'],
              style: TextStyle(
                height: 1.5,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 12.w),
            Row(
              children: [
                Text(
                  '服务时间：',
                  style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
                ),
                Expanded(
                  child: Text(
                    '${(data['serviceStartTime'] ?? '').substring(0, 10)} 至 ${(data['serviceEndTime'] ?? '').substring(0, 10)}',
                    style: TextStyle(height: 1.2, fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.w),
            Text(
              '发布时间：${data['updateTime']}',
              style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
            ),
            SizedBox(height: 12.w),
            Row(
              children: [
                Icon(QmIcons.location, size: 21.sp, color: const Color(0xFF4A4A4A)),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${data['regionName']}${data['contactPersonAddress']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1.5, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
