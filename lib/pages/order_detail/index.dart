import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_address.dart';
import 'package:qm_agricultural_machinery_services/components/image.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/api/service.dart'
    show queryUserOrderDetail, queryCancelUserOrder, queryConfirmEndUserOrder;

import '../../entity/receiving_address.dart';

class OrderDetailPage extends BasePage {
  const OrderDetailPage({super.key, required super.title, required super.author});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends BasePageState<OrderDetailPage> {
  Map<String, dynamic> _orderDetail = {};
  ReceivingAddress? _address;

  @override
  void initState() {
    queryUserOrderDetail({'id': Get.parameters['id']}).then((resp) {
      debugPrint('${resp.data}');
      setState(() {
        _orderDetail = resp.data;
        _address = ReceivingAddress(
          phone: _orderDetail['contactPhone'],
          address: _orderDetail['contactAddress'],
          username: _orderDetail['contactName'],
          addressId: '',
          regionName: '',
          regionCode: '',
          defaultFlag: false,
        );
      });
    });
    super.initState();
  }

  renderButtonText() {
    switch (_orderDetail['status']) {
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
          final serviceOrderId = _orderDetail['serviceOrderId'];
          await queryCancelUserOrder({'serviceOrderId': serviceOrderId});
          await closeLoading();
          Toast.success('取消成功');
          setState(() {
            _orderDetail['status'] = 5;
            _orderDetail['statusName'] = '已取消';
          });
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
          final serviceOrderId = _orderDetail['serviceOrderId'];
          await queryConfirmEndUserOrder({'serviceOrderId': serviceOrderId});
          await closeLoading();
          Toast.success('订单已完结');
          setState(() {
            _orderDetail['status'] = 4;
            _orderDetail['statusName'] = '已完结';
          });
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
    switch (_orderDetail['status']) {
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
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 260.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 0.5)),
                      ),
                      height: 46.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '订单编号：${_orderDetail['orderCode'] ?? ''}',
                            style: TextStyle(
                              height: 1,
                              fontSize: 13.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Text(
                            _orderDetail['statusName'] ?? '',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF3AC786),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 96.w,
                            height: 96.w,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5, color: const Color(0xFFF0F0F0)),
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              image:
                                  _orderDetail['picUrl'] != null
                                      ? DecorationImage(
                                        fit: BoxFit.contain,
                                        image: CachedNetworkImageProvider(
                                          getNetworkAssetURL(_orderDetail['picUrl']!),
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _orderDetail['productName'] ?? '',
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
                                  _orderDetail['serviceSubcategoryName'] ?? '',
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
                                  _orderDetail['serverName'] ?? '',
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
                                      '¥${_orderDetail['price']}${_orderDetail['priceUnit']}',
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFFF4D4F),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      '共${_orderDetail['count']}件',
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
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '下单时间',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Text(
                            _orderDetail['createTime'] ?? '',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '期望服务时间',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          Text(
                            _orderDetail['expectedServiceTime'] ?? '',
                            style: TextStyle(
                              height: 1,
                              fontSize: 14.sp,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                // height: 106.w,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: FormItemAddress(
                  disabled: true,
                  bordered: false,
                  address: _address,
                  onChanged: (_) {},
                ),
              ),
              _orderDetail['remark']?.isEmpty ?? false
                  ? const SizedBox()
                  : Container(
                    padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                    margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 44.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '备注信息',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        SizedBox(height: 9.w),
                        Text(
                          _orderDetail['remark'] ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            height: 1.5,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
              _orderDetail['fileUrlList']?.isEmpty ?? false
                  ? const SizedBox()
                  : Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 44.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '相关图片',
                            style: TextStyle(
                              height: 1,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.w),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          spacing: 12.w,
                          runSpacing: 12.w,
                          children: [
                            for (String img in _orderDetail['fileUrlList'] ?? [])
                              Container(
                                width: 96.w,
                                height: 96.w,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Color(0xFFCCCCCC), width: 0.5),
                                  ),
                                ),
                                child: ImageWidget(image: img),
                              ),
                          ],
                        ),
                        SizedBox(height: 12.w),
                      ],
                    ),
                  ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '总金额：',
                          style: TextStyle(
                            height: 1,
                            fontSize: 16.sp,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '¥${_orderDetail['amount'] ?? 0}',
                          style: TextStyle(
                            height: 1,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF4D4F),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.w),
                    Text(
                      '（注：仅供参考，具体金额请以线下实际交易',
                      style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            _orderDetail['status'] == 1 || _orderDetail['status'] == 3
                ? Container(
                  height: 48.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3), blurRadius: 2),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonWidget(
                        ghost: true,
                        height: 36.w,
                        width: 120.w,
                        radius: 18.w,
                        text: renderButtonText(),
                        onTap: handleOperation,
                      ),
                    ],
                  ),
                )
                : null,
      ),
    );
  }
}
