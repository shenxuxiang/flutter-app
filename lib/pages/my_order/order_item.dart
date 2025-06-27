import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/api/service.dart'
    show queryCancelUserOrder, queryConfirmEndUserOrder;

import '../../utils/event_bus.dart';

class OrderItem extends StatelessWidget {
  final int count;
  final int status;
  final double amount;
  final String price;
  final String picUrl;
  final String priceUnit;
  final String orderCode;
  final String serverName;
  final String statusName;
  final String productName;
  final String serviceOrderId;
  final String serviceSubcategoryName;

  const OrderItem({
    super.key,
    required this.count,
    required this.price,
    required this.amount,
    required this.picUrl,
    required this.status,
    required this.priceUnit,
    required this.orderCode,
    required this.statusName,
    required this.serverName,
    required this.productName,
    required this.serviceOrderId,
    required this.serviceSubcategoryName,
  });

  renderButtonText() {
    switch (status) {
      case 1:
        return '取消订单';
      case 2:
        return ''; // '确认服务';
      case 3:
        return '确认完结';
      case 4:
        return ''; // '已完结';
      case 5:
        return ''; // '已取消';
      default:
        return '';
    }
  }

  handleCancelOrder() {
    Alert.confirm(
      title: '确定要取消该条订单吗？',
      onConfirm: () async {
        final closeLoading = Loading.show(message: '取消订单···');
        try {
          await queryCancelUserOrder({'serviceOrderId': serviceOrderId});
          await closeLoading();
          Toast.success('取消成功');
          eventBus.emit('OrderUpdateQueue.canceled', serviceOrderId);
        } catch (error, stack) {
          closeLoading();
          printLog(error);
          printLog(stack);
        }
      },
    );
  }

  handleCompleted() {
    Alert.confirm(
      title: '确定要完结该条订单吗？',
      onConfirm: () async {
        final closeLoading = Loading.show(message: '完结订单···');
        try {
          await queryConfirmEndUserOrder({'serviceOrderId': serviceOrderId});
          await closeLoading();
          Toast.success('订单已完结');
          eventBus.emit('OrderUpdateQueue.completed', serviceOrderId);
        } catch (error, stack) {
          closeLoading();
          printLog(error);
          printLog(stack);
        }
      },
    );
  }

  handleOperation() {
    switch (status) {
      case 1:
        return handleCancelOrder();
      case 3:
        return handleCompleted();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 263.w,
      margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 0.5)),
            ),
            height: 46.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '订单编号：$orderCode',
                  style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF333333)),
                ),
                Text(
                  statusName,
                  style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF3AC786)),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: const Color(0xFFF0F0F0)),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: CachedNetworkImageProvider(getNetworkAssetURL(picUrl)),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      SizedBox(height: 9.w),
                      Text(
                        serviceSubcategoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1,
                          fontSize: 13.sp,
                          color: const Color(0xFF1890FF),
                        ),
                      ),
                      SizedBox(height: 9.w),
                      Text(
                        serverName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 1,
                          fontSize: 12.sp,
                          color: const Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 21.w),
                      Row(
                        children: [
                          Text(
                            '¥$price$priceUnit',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF4D4F),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            '共$count件',
                            style: TextStyle(
                              height: 1,
                              fontSize: 13.sp,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '总金额：',
                  style: TextStyle(height: 1, fontSize: 16.sp, color: const Color(0xFF333333)),
                ),
                Text(
                  '¥$amount',
                  style: TextStyle(
                    height: 1,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF4D4F),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 8.w, 12.w, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child:
                      renderButtonText().isEmpty
                          ? null
                          : ButtonWidget(
                            ghost: true,
                            width: 80.w,
                            height: 28.w,
                            radius: 14.w,
                            text: renderButtonText(),
                            type: 'default',
                            onTap: handleOperation,
                          ),
                ),
                ButtonWidget(
                  ghost: true,
                  width: 80.w,
                  height: 28.w,
                  radius: 14.w,
                  text: '查看详情',
                  type: 'default',
                  onTap: () {
                    Get.toNamed('/order_detail?id=$serviceOrderId');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
