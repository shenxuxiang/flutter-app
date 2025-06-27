import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../components/form_item_input.dart';
import '../../utils/permissions.dart';
import 'module_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/mine.dart';
import 'package:qm_agricultural_machinery_services/models/mine.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/utils/picker_image.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' show queryUploadImage;
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show compressImage, printLog;
import 'package:qm_agricultural_machinery_services/pages/modify_personal_data.dart' show InputItem;
import 'package:qm_agricultural_machinery_services/api/service.dart'
    show queryUploadIDCardBack, queryUploadIDCardFace, querySubmitFarmerCheck;

class FarmerAuthPage extends BasePage {
  const FarmerAuthPage({super.key, required super.title, required super.author});

  @override
  State<FarmerAuthPage> createState() => _FarmerAuthPageState();
}

class _FarmerAuthPageState extends BasePageState<FarmerAuthPage> {
  File? _pic1;
  File? _pic2;
  File? _pic3;
  dynamic _resp1 = {};
  dynamic _resp2 = {};
  bool _disabled = true;
  String _handHeldUrl = '';
  final mineModel = Get.find<MineModel>();

  computedDisabled() {
    return _pic1 == null ||
        _pic2 == null ||
        _pic3 == null ||
        _handHeldUrl.isEmpty ||
        (_resp1['validDate']?.isEmpty ?? true) ||
        (_resp2['name']?.isEmpty ?? true) ||
        (_resp2['idCardNum']?.isEmpty ?? true);
  }

  Future<File?> handlePicker() async {
    final type = await showPickImageSheet();
    if (type == 'camera') {
      if (await Permissions.requestCamera()) {
        final arguments = await Get.toNamed('/identity_auth/camera_page');
        if (arguments == null) return null;

        return compressImage(arguments, quality: 50, rotate: -90);
      }
    } else if (type == 'gallery') {
      return pickerImageHandle(ImageSource.gallery);
    }
    return null;
  }

  handleTap1() async {
    CloseLoading? closeLoading;
    try {
      FocusScope.of(context).unfocus();
      File? image = await handlePicker();
      if (image == null) return;

      closeLoading = Loading.show(message: '正在分析···');
      setState(() => _pic1 = image);
      final params = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});
      final resp = await queryUploadIDCardBack(params);
      setState(() {
        _resp1 = resp.data;
        _disabled = computedDisabled();
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
    closeLoading?.call();
  }

  handleTap2() async {
    FocusScope.of(context).unfocus();
    File? image = await handlePicker();
    if (image == null) return;

    final closeLoading = Loading.show(message: '正在分析···');
    try {
      setState(() => _pic2 = image);
      final params = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});
      final resp = await queryUploadIDCardFace(params);
      setState(() {
        _resp2 = resp.data;
        _disabled = computedDisabled();
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
    closeLoading();
  }

  handleTap3() async {
    FocusScope.of(context).unfocus();
    File? image = await pickerImage();
    if (image == null) return;

    final closeLoading = Loading.show(message: '正在上传···');
    try {
      setState(() => _pic3 = image);
      final params = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});
      final resp = await queryUploadImage(query: params);
      setState(() {
        _handHeldUrl = resp.data['path'];
        _disabled = computedDisabled();
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
    closeLoading();
  }

  handleChangeName(String input) {
    setState(() {
      _resp2['name'] = input;
      _disabled = computedDisabled();
    });
  }

  handleChangeIdNumber(String input) {
    setState(() {
      _resp2['idCardNum'] = input;
      _disabled = computedDisabled();
    });
  }

  handleChangeValidDate(String input) {
    setState(() {
      _resp1['validDate'] = input;
      _disabled = computedDisabled();
    });
  }

  handleSubmit() async {
    if (_disabled) return;
    final closeLoading = Loading.show(message: '正在提交');
    try {
      final params = {
        'realName': _resp2['name'],
        'handHeldUrl': _handHeldUrl,
        'portraitUrl': _resp2['url'],
        'idCardNum': _resp2['idCardNum'],
        'validDate': _resp1['validDate'],
        'nationalEmblemUrl': _resp1['url'],
      };

      /// 提交认证
      await querySubmitFarmerCheck(params);

      /// 更新认证状态
      final userCheckStatus = await queryUserStatus();
      mineModel.setUserCheckStatus(userCheckStatus.data);
      await closeLoading();
      Toast.success('提交成功', duration: const Duration(seconds: 1));
      await Future.delayed(const Duration(seconds: 1));
      Get.until((Route route) => RegExp(r'^/home').hasMatch(route.settings.name!));
    } catch (error, stack) {
      closeLoading();
      printLog(error);
      printLog(stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ModuleTitle(title: '认证信息'),
              SizedBox(height: 16.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 17.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Text(
                      '身份类型',
                      style: TextStyle(
                        height: 1,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '农户',
                      style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              const ModuleTitle(title: '证件照片上传'),
              SizedBox(height: 16.w),
              PictureItem(
                bg: 'assets/images/identity_auth/pic_id1.png',
                subtitle: '请上传身份证国徽面',
                onTap: handleTap1,
                title: '国徽面',
                avatar: _pic1,
              ),
              SizedBox(height: 16.w),
              PictureItem(
                bg: 'assets/images/identity_auth/pic_id2.png',
                subtitle: '请上传身份证人像面',
                onTap: handleTap2,
                title: '人像面',
                avatar: _pic2,
              ),
              SizedBox(height: 16.w),
              PictureItem(
                bg: 'assets/images/identity_auth/pic_id3.png',
                subtitle: '手持身份证正面',
                onTap: handleTap3,
                title: '手持照片',
                avatar: _pic3,
              ),
              SizedBox(height: 16.w),
              const ModuleTitle(title: '认证信息'),
              SizedBox(height: 16.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 17.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormItemInput(
                      hintText: '',
                      label: '个人姓名',
                      textAlign: TextAlign.start,
                      onChanged: handleChangeName,
                      value: _resp2['name'] ?? '',
                    ),
                    FormItemInput(
                      hintText: '',
                      label: '身份证号',
                      textAlign: TextAlign.start,
                      onChanged: handleChangeIdNumber,
                      value: _resp2['idCardNum'] ?? '',
                      keyboardType: TextInputType.phone,
                    ),
                    FormItemInput(
                      hintText: '',
                      bordered: false,
                      label: '有效期限',
                      textAlign: TextAlign.start,
                      onChanged: handleChangeValidDate,
                      value: _resp1['validDate'] ?? '',
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              Text(
                '注意事项：',
                style: TextStyle(
                  height: 1,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(height: 5.w),
              Text(
                '1、同一个身份证号只能认证一个账号；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '2、国徽面与正面信息应为同一身份证的信息且在有效期内；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '3、所有上传照片需清晰且未遮挡，请勿进行美化和修改；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '4. 上传本人手持身份证信息面照片中应含有本人头部或上半身；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '5、手持身份证照中本人形象需为免冠且并未化妆，五官清晰；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '6、拍照手持身份证照时对焦点请置于身份证上，保证身份证信息清晰且未遮挡；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              Text(
                '7、所有上传信息均会被妥善保管，不会用于其他商业用途或传输给其他第三方；',
                style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1.7),
              ),
              SizedBox(height: 12.w),
            ],
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
          child: Center(
            child: ButtonWidget(
              height: 36.w,
              width: 266.w,
              radius: 18.w,
              text: '提交',
              disabled: _disabled,
              onTap: handleSubmit,
            ),
          ),
        ),
      ),
    );
  }
}

class PictureItem extends StatelessWidget {
  final String bg;
  final String title;
  final File? avatar;
  final String subtitle;
  final VoidCallback onTap;

  const PictureItem({
    super.key,
    this.avatar,
    required this.bg,
    required this.onTap,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.w,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(
          image: AssetImage(bg),
          fit: BoxFit.contain,
          alignment: Alignment.centerRight,
        ),
      ),
      // padding: EdgeInsets.fromLTRB(12.w, 20.w, 0, 0),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 20.w, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    height: 1,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  subtitle,
                  style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF666666)),
                ),
              ],
            ),
          ),
          Positioned(
            top: 22.w,
            right: 82.w,
            child: GestureDetector(
              onTap: onTap,
              child: Icon(QmIcons.plusFill, size: 46.sp, color: const Color(0xFF3AC786)),
            ),
          ),

          avatar == null
              ? const SizedBox()
              : Positioned.fill(
                child: GestureDetector(onTap: onTap, child: Image.file(avatar!, fit: BoxFit.cover)),
              ),
        ],
      ),
    );
  }
}
