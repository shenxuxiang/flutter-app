import 'menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/components/module_title.dart';

final _menusOfGenerate = [
  {
    'title': '农资服务',
    'img': 'assets/images/home/ic_home_agricultural_production.png',
    'link': '/service/agricultural_material',
  },
  {
    'title': '农机服务',
    'img': 'assets/images/home/ic_home_agricultural_machinery.png',
    'link': '/service/agricultural_machinery',
  },
  {
    'title': '植保服务',
    'img': 'assets/images/home/ic_home_plant_protection.png',
    'link': '/service/plant_production',
  },
  {
    'title': '劳务服务',
    'img': 'assets/images/service/labor_services.png',
    'link': _handleTap, //'/service/labor_services',
  },
  {
    'title': '土地流转',
    'img': 'assets/images/service/landtransfer.png',
    'link': _handleTap, // '/service/land_transfer',
  },
];

_handleTap() {
  Toast.show('功能暂未开放');
}

final _menusOfSupplyAndMarketing = [
  {'title': '烘干服务', 'img': 'assets/images/service/drying.png', 'link': _handleTap},
  {'title': '收购服务', 'img': 'assets/images/service/acquisition.png', 'link': _handleTap},
  {'title': '物流服务', 'img': 'assets/images/service/logistics.png', 'link': _handleTap},
  {'title': '仓储服务', 'img': 'assets/images/service/storage.png', 'link': _handleTap},
];

final _menusOfFinance = [
  {'title': '贷款服务', 'img': 'assets/images/home/ic_home_credit.png', 'link': _handleTap},
  {'title': '保险服务', 'img': 'assets/images/home/ic_home_insurance.png', 'link': _handleTap},
];

final _menusOfPolicy = [
  {'title': '政策资讯', 'img': 'assets/images/home/ic_home_policy.png', 'link': '/policy_information'},
  {'title': '政策申报', 'img': 'assets/images/service/policy_declaration.png', 'link': _handleTap},
  {'title': '政策咨询', 'img': 'assets/images/service/policy_advice.png', 'link': _handleTap},
];

class ServicePanel extends StatelessWidget {
  const ServicePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModuleTitle(title: '生产服务', spacing: 0),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              for (final menu in _menusOfGenerate)
                MenuItem(
                  height: 84.w,
                  width: 106.6.w,
                  link: menu['link'],
                  img: menu['img'] as String,
                  title: menu['title'] as String,
                ),
            ],
          ),
          const ModuleTitle(title: '供销服务', spacing: 0),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              for (final menu in _menusOfSupplyAndMarketing)
                MenuItem(
                  height: 84.w,
                  width: 164.w,
                  link: menu['link'],
                  img: menu['img'] as String,
                  title: menu['title'] as String,
                ),
            ],
          ),
          const ModuleTitle(title: '金融服务', spacing: 0),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              for (final menu in _menusOfFinance)
                MenuItem(
                  height: 84.w,
                  width: 164.w,
                  link: menu['link'],
                  img: menu['img'] as String,
                  title: menu['title'] as String,
                ),
            ],
          ),
          const ModuleTitle(title: '政策服务', spacing: 0),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.w,
            children: [
              for (final menu in _menusOfPolicy)
                MenuItem(
                  height: 84.w,
                  width: 106.6.w,
                  link: menu['link'],
                  img: menu['img'] as String,
                  title: menu['title'] as String,
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
