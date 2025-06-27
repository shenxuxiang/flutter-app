import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/upload_image.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/pages/submit_order/remark.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_address.dart';
import 'package:qm_agricultural_machinery_services/components/fort_item_time_picker.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUserAddressList;
import 'package:qm_agricultural_machinery_services/components/form_item_input_multiple_lines.dart';

import '../../components/form_item.dart';

/// 该页面可当作需求的【重新发布】、【详情】使用
class RepublishPage extends BasePage {
  const RepublishPage({super.key, required super.author, required super.title});

  @override
  State<RepublishPage> createState() => _RepublishPageState();
}

class _RepublishPageState extends BasePageState<RepublishPage> {
  final mainModel = Get.find<MainModel>();
  int status = 1;
  String code = '';
  String title = '';
  String remark = '';
  bool readonly = true;
  String serviceId = '';
  String statusName = '';

  DateTime? endTime;
  DateTime? startTime;
  ReceivingAddress? address;
  List<ImageData> imageList = [];
  String demandSubcategoryId = '';

  @override
  void onLoad() async {
    serviceId = Get.arguments?['id'] ?? '';
    readonly = Get.arguments?['readonly'] ?? false;

    debugPrint("${Get.arguments}");
    debugPrint("${Get.arguments['readonly'] is bool}");
    try {
      final resp = await queryDemandDetail(serviceId);
      final data = resp.data;

      remark = data['remark'];
      status = data['status'];
      code = data['serviceCode'];
      title = data['serviceTitle'];
      statusName = data['statusName'];
      endTime = DateTime.parse(data['serviceEndTime']);
      demandSubcategoryId = data['demandSubcategoryId'];
      startTime = DateTime.parse(data['serviceStartTime']);

      /// 更新地址
      if (mainModel.userReceivingAddressList.value.isEmpty) {
        try {
          final resp = await queryUserAddressList({'pageNum': 1, 'pageSize': 999});
          mainModel.setUserReceivingAddressList(resp.data['list'] ?? []);
        } catch (error, stack) {
          printLog(error);
          printLog(stack);
        }
      }

      final addressList = mainModel.userReceivingAddressList.value.where(
        (ReceivingAddress item) => item.addressId == data['addressId'],
      );

      if (addressList.isNotEmpty) address = addressList.first;

      /// 更新图像
      for (String item in data['picList'] ?? []) {
        imageList.add(ImageData(url: item, id: generateUniqueString()));
      }

      setState(() {});
    } finally {}
  }

  get submitDisabled => title.isEmpty || address == null || endTime == null || startTime == null;

  /// 标题
  handleInputChangeTitle(String input) {
    setState(() {
      title = input;
    });
  }

  /// 地址
  handleInputChangeAddress(ReceivingAddress? input) {
    setState(() {
      address = input;
    });
  }

  /// 开始时间
  handleInputChangeStartTime(DateTime time) {
    setState(() {
      startTime = time;
    });
  }

  /// 结束时间
  handleInputChangeEndTime(DateTime time) {
    setState(() {
      endTime = time;
    });
  }

  /// 修改备注信息
  handleChangeRemark(String value) {
    setState(() => remark = value);
  }

  /// 上传图像
  handleInputChangeImageList(List<ImageData> list) {
    setState(() {
      imageList = list;
    });
  }

  /// 重新发布
  handleRepublish() async {
    CloseLoading closeLoading = Loading.show();
    try {
      final params = {
        'remark': remark,
        'serviceTitle': title,
        'serviceId': serviceId,
        'addressId': address!.addressId,
        'demandSubcategoryId': demandSubcategoryId,
        'serviceEndTime': endTime.toString().substring(0, 19),
        'serviceStartTime': startTime.toString().substring(0, 19),
        'picList':
            imageList
                .map((ImageData image) => image.url)
                .where((String? item) => item != null)
                .toList(),
      };

      /// 重新发布
      await queryRepublishDemand(params);

      /// 再次获取需求详情，通过事件总线向上级页面发送事件通知，
      /// 上级页面在接受到通知后会自动更新列表。
      final resp = await queryDemandDetail(serviceId);
      final data = resp.data;
      eventBus.emit('MyDemandUpdateQueue.republish', data);

      await closeLoading();
      Toast.success('重新发布完成', duration: const Duration(milliseconds: 1000));
      await Future.delayed(const Duration(milliseconds: 1000));
      Get.back();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      closeLoading();
    }
  }

  /// 取消发布
  handleCancelPublish() {
    Alert.confirm(
      title: '确定要取消该条需求吗？',
      onConfirm: () async {
        CloseLoading closeLoading = Loading.show();
        try {
          await queryCancelPublish(serviceId);
          await closeLoading();
          eventBus.emit('MyDemandUpdateQueue.canceled', serviceId);
          Toast.success('取消成功', duration: const Duration(seconds: 1));
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
        } finally {}
      },
    );
  }

  /// 删除需求
  handleDeletePublish() {
    Alert.confirm(
      title: '确定要删除该条需求吗？',
      onConfirm: () async {
        CloseLoading closeLoading = Loading.show();
        try {
          await queryDeletePublish(serviceId);
          await closeLoading();
          eventBus.emit('MyDemandUpdateQueue.deleted', serviceId);
          Toast.success('删除成功', duration: const Duration(seconds: 1));
          await Future.delayed(const Duration(seconds: 1));
          Get.back();
        } finally {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PageWidget(
      child: Scaffold(
        appBar: HeaderNavBar(title: readonly ? '查看详情' : '重新发布'),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: FocusScope(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      FormItem(
                        value: code,
                        height: 48.5.w,
                        label: '需求编号：',
                        suffix:
                            readonly
                                ? Text(
                                  statusName,
                                  style: TextStyle(fontSize: 14.sp, color: primaryColor, height: 1),
                                )
                                : const SizedBox.shrink(),
                      ),

                      FormItemInputMultipleLines(
                        value: title,
                        maxLength: 26,
                        label: '需求标题',
                        disabled: readonly,
                        hintText: '请输入需求标题',
                        onChanged: handleInputChangeTitle,
                        textInputAction: TextInputAction.done,
                      ),
                      FormItemAddress(
                        onChanged: handleInputChangeAddress,
                        address: address,
                        disabled: readonly,
                      ),
                      FormItemTimePicker(
                        disabled: readonly,
                        dateTime: startTime,
                        label: '服务开始时间',
                        hintText: '请选择开始时间',
                        onChanged: handleInputChangeStartTime,
                      ),
                      FormItemTimePicker(
                        bordered: false,
                        dateTime: endTime,
                        disabled: readonly,
                        label: '服务截止时间',
                        hintText: '请选择截止时间',
                        onChanged: handleInputChangeEndTime,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.w),
                Container(
                  width: 336.w,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Remark(onChanged: handleChangeRemark, value: remark, disabled: readonly),
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
                        disabled: readonly,
                        imageList: imageList,
                        onChanged: handleInputChangeImageList,
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
        bottomNavigationBar: Container(
          height: 48.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3), blurRadius: 2),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Center(
            child:
                !readonly
                    ? ButtonWidget(
                      height: 36.w,
                      width: 266.w,
                      radius: 18.w,
                      text: '确认发布',
                      onTap: handleRepublish,
                      disabled: submitDisabled,
                    )
                    : status == 1
                    ? ButtonWidget(
                      ghost: true,
                      height: 36.w,
                      width: 266.w,
                      radius: 18.w,
                      text: '取消发布',
                      disabled: submitDisabled,
                      onTap: handleCancelPublish,
                    )
                    : ButtonWidget(
                      text: '删除',
                      ghost: true,
                      height: 36.w,
                      width: 266.w,
                      radius: 18.w,
                      disabled: submitDisabled,
                      onTap: handleDeletePublish,
                    ),
          ),
        ),
      ),
    );
  }
}
