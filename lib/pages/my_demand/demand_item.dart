import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class DemandItem extends StatelessWidget {
  final dynamic dataSource;

  const DemandItem({super.key, required this.dataSource});

  handleCancelPublish() {
    Alert.confirm(
      title: '确定要取消该条需求吗？',
      onConfirm: () async {
        CloseLoading closeLoading = Loading.show();
        try {
          await queryCancelPublish(dataSource['serviceId']);
          await closeLoading();
          eventBus.emit('MyDemandUpdateQueue.canceled', dataSource['serviceId']);
          Toast.success('取消成功');
        } finally {}
      },
    );
  }

  handleDeletePublish() {
    Alert.confirm(
      title: '确定要删除该条需求吗？',
      onConfirm: () async {
        CloseLoading closeLoading = Loading.show();
        try {
          await queryDeletePublish(dataSource['serviceId']);
          await closeLoading();
          eventBus.emit('MyDemandUpdateQueue.deleted', dataSource['serviceId']);
          Toast.success('删除成功');
        } finally {}
      },
    );
  }

  /// 查看详情
  handleViewDetail() {
    Get.toNamed('/republish', arguments: {'id': dataSource['serviceId'], 'readonly': true});
  }

  /// 重新发布
  handleRepublish() {
    Get.toNamed('/republish', arguments: {'id': dataSource['serviceId'], 'readonly': false});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: 336.w,
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Container(
            height: 46.5.w,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFE0E0E0))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '需求编号：${dataSource['serviceCode'] ?? ''}',
                  style: TextStyle(fontSize: 13.sp, color: const Color(0xFF333333), height: 1),
                ),
                Text(
                  dataSource['statusName'],
                  style: TextStyle(fontSize: 13.sp, color: primaryColor, height: 1),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.5.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '需求标题：',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1.5),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    dataSource['serviceTitle'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.5,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.5.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  '需求类型：',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    '${dataSource['demandCategoryName'] ?? ''} | ${dataSource['demandSubcategoryName'] ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF1890FF)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  '服务时间：',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    '${(dataSource['serviceStartTime'] ?? '').substring(0, 10)} - ${(dataSource['serviceEndTime'] ?? '').substring(0, 10)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Text(
                  '发布时间：',
                  style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    dataSource['updateTime'] ?? '',
                    style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Icon(QmIcons.location, size: 22.sp, color: const Color(0xFF4A4A4A)),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    '${dataSource['regionName'] ?? ''}${dataSource['contactPersonAddress']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
          Container(
            height: 60.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dataSource['status'] == 2
                    ? ButtonWidget(
                      ghost: true,
                      width: 80.w,
                      text: '删除',
                      height: 28.w,
                      radius: 14.w,
                      type: 'default',
                      onTap: handleDeletePublish,
                    )
                    : const SizedBox(),
                dataSource['status'] == 2
                    ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonWidget(
                            ghost: true,
                            width: 80.w,
                            height: 28.w,
                            radius: 14.w,
                            type: 'default',
                            text: '重新发布',
                            onTap: handleRepublish,
                          ),
                          SizedBox(width: 12.w),
                          ButtonWidget(
                            ghost: true,
                            width: 80.w,
                            height: 28.w,
                            radius: 14.w,
                            text: '查看详情',
                            type: 'default',
                            onTap: handleViewDetail,
                          ),
                        ],
                      ),
                    )
                    : Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonWidget(
                            ghost: true,
                            width: 80.w,
                            height: 28.w,
                            radius: 14.w,
                            text: '取消发布',
                            type: 'default',
                            onTap: handleCancelPublish,
                          ),
                          SizedBox(width: 12.w),
                          ButtonWidget(
                            ghost: true,
                            width: 80.w,
                            radius: 14.w,
                            height: 28.w,
                            text: '查看详情',
                            type: 'default',
                            onTap: handleViewDetail,
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
