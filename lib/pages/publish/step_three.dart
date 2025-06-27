import '../../models/home.dart';
import 'time_line.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

class StepThree extends BasePage {
  const StepThree({super.key, required super.author, required super.title});

  @override
  State<StepThree> createState() => _StepThreeState();
}

class _StepThreeState extends BasePageState<StepThree> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TimeLine(step: 3),
              SizedBox(height: 20.w),
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
                      '需求发布成功',
                      style: TextStyle(fontSize: 19.sp, color: const Color(0xFF333333), height: 1),
                    ),
                    SizedBox(height: 12.w),
                    Text(
                      '您可以在”我的-我的需求“查看需求信息',
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
                text: '查看我的需求',
                onTap: () {
                  Get.offNamedUntil('/my_demand', (Route route) {
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
                  // Get.offAllNamed('/home?tab=0');
                  final homeModel = Get.find<HomeModel>();
                  homeModel.tabKey.value = 0;
                  Get.until((Route route) => RegExp(r'^\/home').hasMatch(route.settings.name!));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
