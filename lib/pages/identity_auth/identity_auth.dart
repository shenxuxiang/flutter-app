import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/pages/identity_auth/module_title.dart';

class IdentityAuthPage extends BasePage {
  const IdentityAuthPage({super.key, required super.title, required super.author});

  @override
  State<IdentityAuthPage> createState() => _IdentityAuthPageState();
}

class _IdentityAuthPageState extends BasePageState<IdentityAuthPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              const ModuleTitle(title: '请选择认证身份'),
              SizedBox(height: 16.w),
              const RenderItem(
                label: '农户',
                avatar: 'assets/images/identity_auth/pic_farmer.png',
                link: '/identity_auth/farmer_auth',
              ),
              SizedBox(height: 16.w),
              const RenderItem(
                label: '农机手',
                avatar: 'assets/images/identity_auth/pic_agricultural_machinery_operator.png',
                link: '/identity_auth/agricultural_machinery_driver_auth',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RenderItem extends StatelessWidget {
  final String label;
  final String avatar;
  final String link;

  const RenderItem({super.key, required this.label, required this.avatar, required this.link});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(link);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            Image.asset(avatar, width: 67.w, height: 67.w, fit: BoxFit.cover),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      height: 1,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    '需提供身份证进行认证',
                    style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF4A4A4A)),
                  ),
                ],
              ),
            ),
            Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF666666)),
          ],
        ),
      ),
    );
  }
}
