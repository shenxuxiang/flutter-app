import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

import 'module_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

class AgriculturalMachineryDriver extends BasePage {
  const AgriculturalMachineryDriver({super.key, required super.title, required super.author});

  @override
  State<AgriculturalMachineryDriver> createState() => _AgriculturalMachineryDriverState();
}

class _AgriculturalMachineryDriverState extends BasePageState<AgriculturalMachineryDriver> {
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
                      '农机手',
                      style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60.w),
              Center(child: Icon(QmIcons.shalou, size: 60.w, color: const Color(0xFFCCCCCC))),
              Center(
                child: Text(
                  '敬请期待',
                  style: TextStyle(height: 4, fontSize: 16.sp, color: const Color(0xFF999999)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
