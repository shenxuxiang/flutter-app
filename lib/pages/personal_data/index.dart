import 'avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/api/login.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/pages/personal_data/info_item.dart';
import 'package:qm_agricultural_machinery_services/components/select_region_widget.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart'
    show printLog, setStorageUserInfo;
import '../../entity/selected_tree_node.dart';
import '../../utils/picker_image.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart'
    show queryUpdateUserInfo, queryUploadImage, queryUserInfo;

class PersonalDataPage extends BasePage {
  const PersonalDataPage({super.key, required super.author, required super.title});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends BasePageState<PersonalDataPage> {
  final mainModel = Get.find<MainModel>();
  List<SelectedTreeNode> region = [];

  @override
  void onLoad() async {
    final regions = await getParentRegions(mainModel.userInfo.value!.regionCode);
    setState(() {
      region = regions;
    });
  }

  handleChangeAvatar() async {
    final image = await pickerImage();
    if (image == null) return;

    final closeLoading = Loading.show(message: '正在上传头像···');
    var params = FormData.fromMap({'file': await MultipartFile.fromFile(image.path)});

    try {
      final resp = await queryUploadImage(query: params);
      final query = mainModel.userInfo.value!.toJson();
      final path = resp.data['path'];
      query['avatar'] = path;
      await handleSubmit(query);
      closeLoading();
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  handleChangeRegion(List<SelectedTreeNode> input) async {
    setState(() => region = input);
    CloseLoading closeLoading = Loading.show();
    final query = mainModel.userInfo.value!.toJson();
    query['regionCode'] = input.last.value;
    query['regionName'] = region.last.label;
    await handleSubmit(query);
    closeLoading();
  }

  handleChangePhone() async {
    Get.toNamed('/modify_personal_data');
  }

  handleChangePassword() {
    Get.toNamed('/modify_personal_data?phone=${mainModel.userInfo.value!.phone}');
  }

  Future<void> handleSubmit(dynamic query) async {
    try {
      await queryUpdateUserInfo(query);
      final resp = await queryUserInfo();
      mainModel.setUserInfo(resp.data);
      await setStorageUserInfo(resp.data);
    } catch (error, stack) {
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
        body: Obx(() {
          final userInfo = mainModel.userInfo.value;
          return Column(
            children: [
              Container(
                // height: 218.w,
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Avatar(avatar: userInfo?.avatar, onChange: handleChangeAvatar),
                    InfoItem(label: '用户名', value: userInfo?.username),
                    InfoItem(label: '手机号码', value: userInfo?.phone, onChange: handleChangePhone),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SelectRegionWidget(
                        value: region,
                        bordered: false,
                        label: '所在地区',
                        hintText: '请选择所在地区',
                        onChanged: handleChangeRegion,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    InfoItem(label: '账号', value: userInfo?.phone),
                    InfoItem(
                      label: '密码',
                      value: '',
                      bordered: false,
                      onChange: handleChangePassword,
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
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
              text: '退出登录',
              onTap: () {
                Alert.confirm(
                  title: '确定要退出登录吗？',
                  onConfirm: () async {
                    var closeLoading = Loading.show();
                    try {
                      await queryLogOut({});
                      await closeLoading();
                      Get.offAllNamed('/login?logout=true');
                    } catch (error, stack) {
                      closeLoading();
                      printLog(error);
                      printLog(stack);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
