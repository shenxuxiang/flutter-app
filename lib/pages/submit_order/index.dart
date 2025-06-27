import 'footer.dart';
import 'remark.dart';
import 'select_count.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/api/service.dart' as api;
import 'package:qm_agricultural_machinery_services/components/upload_image.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;
import 'package:qm_agricultural_machinery_services/components/form_item_address.dart';
import 'package:qm_agricultural_machinery_services/components/fort_item_time_picker.dart';

class SubmitOrderPage extends BasePage {
  const SubmitOrderPage({super.key, required super.author, required super.title});

  @override
  State<SubmitOrderPage> createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends BasePageState<SubmitOrderPage> {
  final mainModel = Get.find<MainModel>();

  int _count = 1;
  String _remark = '';
  DateTime? _serverTime;
  List<ImageData> _imageList = [];
  Map<String, dynamic> _productDetail = {};

  String? _addressId;

  bool _submitSucceed = false;

  @override
  void onLoad() async {
    _count = 1;
    _productDetail = Get.arguments;
    final userReceivingAddressList = mainModel.userReceivingAddressList;
    if (userReceivingAddressList.value.isEmpty) await mainModel.queryReceivingAddressList();
    setState(() => _addressId = mainModel.defaultReceivingAddress.value?.addressId);
  }

  navigateBack() {
    Get.back();
  }

  handleReceivingAddressChange(ReceivingAddress? address) {
    setState(() => _addressId = address?.addressId);
  }

  /// 修改服务时间
  handleChangeServerTime(DateTime? value) {
    setState(() {
      _serverTime = value;
    });
  }

  /// 修改购买数量
  handleChangeCount(int count) {
    setState(() => _count = count);
  }

  /// 修改备注信息
  handleChangeRemark(String value) {
    setState(() => _remark = value);
  }

  /// 上传图像
  handleChangeImageList(List<ImageData> imageList) {
    setState(() {
      _imageList = imageList;
    });
  }

  /// 提交订单
  handleSubmit() async {
    if (_addressId == null) {
      Toast.warning('请选择收获地址');
      return;
    }
    if (_serverTime == null) {
      Toast.warning('请选择服务时间');
      return;
    }
    if (_count <= 0) {
      Toast.warning('数量不可为0');
      return;
    }
    final closeLoading = Loading.show(message: '正在提交订单~');
    final List<String> fileUrlList = [];
    for (final item in _imageList) {
      if (item.url != null) fileUrlList.add(item.url!);
    }

    try {
      await api.querySubmitServiceOrder({
        'count': _count,
        'remark': _remark,
        'addressId': _addressId,
        'fileUrlList': fileUrlList,
        'serviceProductId': _productDetail['serviceProductId'],
        'expectedServiceTime': _serverTime.toString().substring(0, 19),
      });
      closeLoading();
      setState(() => _submitSucceed = true);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      closeLoading();
    }
  }

  /// 订单提交成功后展示的界面
  renderSubmitSucceedUI() {
    return Column(
      children: [
        Container(
          width: 336.w,
          height: 203.w,
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: [
              SizedBox(height: 44.w),
              Icon(QmIcons.checked, size: 48.sp, color: Theme.of(context).primaryColor),
              SizedBox(height: 33.w),
              Text(
                '订单提交成功',
                style: TextStyle(fontSize: 19.sp, color: const Color(0xFF333333), height: 1),
              ),
              SizedBox(height: 12.w),
              Text(
                '您可以在”我的-我的订单“中跟踪订单信息',
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF666666), height: 1),
              ),
            ],
          ),
        ),
        SizedBox(height: 54.w),
        ButtonWidget(
          width: 266.w,
          height: 36.w,
          radius: 18.w,
          text: '查看我的订单',
          onTap: () {
            Get.offNamedUntil('/my_order', (Route route) {
              return RegExp(r'^/home').hasMatch(route.settings.name!);
            });
          },
        ),
        SizedBox(height: 20.w),
        ButtonWidget(
          width: 266.w,
          height: 36.w,
          radius: 18.w,
          ghost: true,
          text: '返回首页',
          type: 'default',
          onTap: () {
            Get.offAllNamed('/home?tab=0');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body:
            _submitSucceed
                ? renderSubmitSucceedUI()
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: FocusScope(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Builder(
                            builder: (BuildContext context) {
                              List<ReceivingAddress> filterResult = [];
                              if (_addressId != null) {
                                filterResult =
                                    mainModel.userReceivingAddressList.value
                                        .where((address) => address.addressId == _addressId)
                                        .toList();
                              }

                              return FormItemAddress(
                                bordered: false,
                                onChanged: handleReceivingAddressChange,
                                address: filterResult.isEmpty ? null : filterResult.first,
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 49.w,
                          margin: EdgeInsets.only(top: 12.w),
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FormItemTimePicker(
                            bordered: false,
                            label: '期望服务时间',
                            dateTime: _serverTime,
                            hintText: '请选择期望服务时间',
                            onChanged: handleChangeServerTime,
                          ),
                        ),
                        SelectCount(
                          count: _count,
                          onChanged: handleChangeCount,
                          avatar: _productDetail['picUrl'],
                          unit: _productDetail['priceUnit'],
                          price: '${_productDetail['price']}',
                          serverName: _productDetail['serverName'],
                          productName: _productDetail['productName'],
                          flag: _productDetail['serviceCategoryNameSecond'],
                        ),
                        const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Remark(onChanged: handleChangeRemark, value: _remark),
                              SizedBox(height: 20.w),
                              Text(
                                '上传照片',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                              SizedBox(height: 20.w),
                              UploadImage(
                                maxFiles: 5,
                                imageList: _imageList,
                                onChanged: handleChangeImageList,
                              ),
                              SizedBox(height: 16.w),
                              Text(
                                '提示：上传图片可以很好的描述您的需求，最多上传5张！',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 11.sp,
                                  color: const Color(0xFF4B4B4B),
                                ),
                              ),
                              SizedBox(height: 20.w),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.w),
                      ],
                    ),
                  ),
                ),
        bottomNavigationBar:
            _submitSucceed
                ? const SizedBox()
                : Footer(count: _count, onSubmit: handleSubmit, price: _productDetail['price']),
      ),
    );
  }
}
