import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/models/home.dart';

_handleTap() {
  Toast.show('功能暂未开放');
}

/// 跳转至农技 Tab
_handleToTechnology() {
  Get.find<HomeModel>().tabKey.value = 3;
}

const menus = [
  {'title': '测量宝', 'icon': 'assets/images/home/ic_home_measure.png', 'link': '/measure_land'},
  {
    'title': '农机作业',
    'icon': 'assets/images/home/ic_home_agricultural_machinery_operation.png',
    'link': _handleTap,
  },
  {'title': '病虫害识别', 'icon': 'assets/images/home/ic_home_plant_diseases.png', 'link': _handleTap},
  {'title': '我的农场', 'icon': 'assets/images/home/ic_home_farm.png', 'link': '/my_farm'},
  {
    'title': '找农资',
    'icon': 'assets/images/home/ic_home_agricultural_production.png',
    'link': '/service/agricultural_material',
  },
  {
    'title': '找农机',
    'icon': 'assets/images/home/ic_home_agricultural_machinery.png',
    'link': '/service/agricultural_machinery',
  },
  {
    'title': '找植保',
    'icon': 'assets/images/home/ic_home_plant_protection.png',
    'link': '/service/plant_production',
  },
  {
    'title': '找农技',
    'icon': 'assets/images/home/ic_home_agricultural_technology.png',
    'link': _handleToTechnology,
  },
  {'title': '找贷款', 'icon': 'assets/images/home/ic_home_credit.png', 'link': _handleTap},
  {'title': '找保险', 'icon': 'assets/images/home/ic_home_insurance.png', 'link': _handleTap},
  {'title': '找政策', 'icon': 'assets/images/home/ic_home_policy.png', 'link': '/policy_information'},
  {'title': '找专家', 'icon': 'assets/images/home/ic_home_expert.png', 'link': _handleTap},
];
