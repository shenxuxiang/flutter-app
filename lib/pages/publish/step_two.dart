import 'time_line.dart';
import 'step_three.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/upload_image.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/pages/submit_order/remark.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_address.dart';
import 'package:qm_agricultural_machinery_services/components/fort_item_time_picker.dart';
import 'package:qm_agricultural_machinery_services/components/form_item_input_multiple_lines.dart';

class StepTwo extends BasePage {
  const StepTwo({super.key, required super.author, required super.title});

  @override
  State<StepTwo> createState() => _StepTwoState();
}

class _StepTwoState extends BasePageState<StepTwo> {
  final mainModel = Get.find<MainModel>();

  String id = '';
  String title = '';
  DateTime? endTime;
  String? _addressId;
  String remark = '';
  DateTime? startTime;
  List<ImageData> imageList = [];

  @override
  void onLoad() async {
    id = Get.arguments!;
    final mainModel = Get.find<MainModel>();
    final userReceivingAddressList = mainModel.userReceivingAddressList;
    if (userReceivingAddressList.value.isEmpty) await mainModel.queryReceivingAddressList();
    setState(() => _addressId = mainModel.defaultReceivingAddress.value?.addressId);
  }

  get submitDisabled => title.isEmpty || endTime == null || startTime == null;

  /// 标题
  handleInputChangeTitle(String input) {
    setState(() {
      title = input;
    });
  }

  /// 地址
  handleInputChangeAddress(ReceivingAddress? input) {
    setState(() {
      _addressId = input?.addressId;
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

  handleSubmit() async {
    if (_addressId == null) {
      Toast.warning('地址不能为空');
      return;
    }

    CloseLoading closeLoading = Loading.show();
    try {
      final params = {
        'remark': remark,
        'serviceTitle': title,
        'addressId': _addressId,
        'demandSubcategoryId': id,
        'serviceEndTime': endTime.toString().substring(0, 19),
        'picList': imageList.map((image) => image.url).toList(),
        'serviceStartTime': startTime.toString().substring(0, 19),
      };

      await queryPublishDemand(params);
      await closeLoading();
      Get.off(const StepThree(title: '完成发布', author: true), fullscreenDialog: true);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
      closeLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: FocusScope(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TimeLine(step: 2),
                SizedBox(height: 20.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      FormItemInputMultipleLines(
                        value: title,
                        maxLength: 50,
                        label: '需求标题',
                        isRequired: true,
                        hintText: '请输入需求标题',
                        onChanged: handleInputChangeTitle,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          List<ReceivingAddress> filterResult = [];
                          if (_addressId != null) {
                            filterResult =
                                mainModel.userReceivingAddressList.value
                                    .where((address) => address.addressId == _addressId)
                                    .toList();
                          }
                          return FormItemAddress(
                            onChanged: handleInputChangeAddress,
                            address: filterResult.isEmpty ? null : filterResult.first,
                          );
                        },
                      ),
                      FormItemTimePicker(
                        isRequired: true,
                        dateTime: startTime,
                        label: '服务开始时间',
                        hintText: '请选择开始时间',
                        onChanged: handleInputChangeStartTime,
                      ),
                      FormItemTimePicker(
                        bordered: false,
                        isRequired: true,
                        dateTime: endTime,
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
                      Remark(onChanged: handleChangeRemark, value: remark),
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
            child: ButtonWidget(
              height: 36.w,
              width: 266.w,
              radius: 18.w,
              text: '确认发布',
              onTap: handleSubmit,
              disabled: submitDisabled,
            ),
          ),
        ),
      ),
    );
  }
}
