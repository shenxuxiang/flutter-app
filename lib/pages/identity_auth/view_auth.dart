import 'module_title.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/components/image.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/form_item.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/api/mine.dart' show queryUserStatusInfo;

class ViewAuthPage extends BasePage {
  const ViewAuthPage({super.key, required super.title, required super.author});

  @override
  State<ViewAuthPage> createState() => _ViewAuthPageState();
}

class _ViewAuthPageState extends BasePageState<ViewAuthPage> {
  dynamic _farmerCheckInfo = {};

  @override
  void initState() {
    queryUserStatusInfo().then((resp) {
      setState(() {
        _farmerCheckInfo = resp.data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("${_farmerCheckInfo['status'] is String}; ${_farmerCheckInfo['status']}");
    debugPrint("${_farmerCheckInfo['status'] is int}");
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
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    FormItem(
                      height: 48.5.w,
                      label: '身份类型',
                      value: _farmerCheckInfo['userTypeName'] ?? '',
                    ),
                    FormItem(
                      height: 48.5.w,
                      label: '认证状态',
                      value: _farmerCheckInfo['checkStatusName'] ?? '',
                    ),
                    FormItem(
                      bordered: false,
                      label: '审核备注',
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.5.w),
                        child: Text(
                          _farmerCheckInfo['checkRemark'] ?? '',
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 14.sp,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.w),
              const ModuleTitle(title: '证件照片'),
              SizedBox(height: 16.w),
              RenderPicture(title: '国徽面', picURL: _farmerCheckInfo['nationalEmblemUrl'] ?? ''),
              SizedBox(height: 12.w),
              RenderPicture(title: '人像面', picURL: _farmerCheckInfo['portraitUrl'] ?? ''),
              SizedBox(height: 12.w),
              RenderPicture(title: '手持照片', picURL: _farmerCheckInfo['handHeldUrl'] ?? ''),
              SizedBox(height: 16.w),
              const ModuleTitle(title: '身份信息'),
              SizedBox(height: 16.w),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    FormItem(
                      height: 48.5.w,
                      label: '个人姓名',
                      value: _farmerCheckInfo['realName'] ?? '',
                    ),
                    FormItem(
                      height: 48.5.w,
                      label: '身份证号',
                      value: _farmerCheckInfo['idCardNum'] ?? '',
                    ),
                    FormItem(
                      height: 48.w,
                      bordered: false,
                      label: '有效期限',
                      value: _farmerCheckInfo['validDate'] ?? '',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.w),
            ],
          ),
        ),
        bottomNavigationBar:
            _farmerCheckInfo['status'] == 2
                ? Container(
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
                      text: '重新认证',
                      onTap: () {
                        Get.toNamed('/identity_auth/farmer_auth');
                      },
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}

class RenderPicture extends StatelessWidget {
  final String title;
  final String? picURL;

  const RenderPicture({super.key, required this.title, this.picURL});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 20.w, 16.w, 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
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
          SizedBox(height: 12.w),
          ImageWidget(image: picURL ?? '', width: 312.w, height: 186.w),
        ],
      ),
    );
  }
}
