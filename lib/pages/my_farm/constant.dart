import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/models/my_farm.dart';

import '../../utils/toast.dart';

const weatherIcons = {
  '100': 'assets/images/weather/qing.png',
  '101': 'assets/images/weather/duoyun.png',
  '102': 'assets/images/weather/qing.png',
  '103': 'assets/images/weather/duoyun.png',
  '104': 'assets/images/weather/yin.png',
  '150': 'assets/images/weather/night.png',
  '151': 'assets/images/weather/night.png',
  '152': 'assets/images/weather/night.png',
  '153': 'assets/images/weather/night.png',
  '300': 'assets/images/weather/dayu.png',
  '301': 'assets/images/weather/baoyu.png',
  '302': 'assets/images/weather/leizhengyu.png',
  '303': 'assets/images/weather/leizhengyu.png',
  '304': 'assets/images/weather/leizhengyu.png',
  '305': 'assets/images/weather/xiaoyu.png',
  '306': 'assets/images/weather/zhongyu.png',
  '307': 'assets/images/weather/dayu.png',
  '308': 'assets/images/weather/dabaoyu.png',
  '309': 'assets/images/weather/xiaoyu.png',
  '310': 'assets/images/weather/baoyu.png',
  '311': 'assets/images/weather/dabaoyu.png',
  '312': 'assets/images/weather/dabaoyu.png',
  '313': 'assets/images/weather/dayu.png',
  '314': 'assets/images/weather/xiaoyu.png',
  '315': 'assets/images/weather/zhongyu.png',
  '316': 'assets/images/weather/dayu.png',
  '317': 'assets/images/weather/baoyu.png',
  '318': 'assets/images/weather/dabaoyu.png',
  '350': 'assets/images/weather/baoyu.png',
  '351': 'assets/images/weather/dabaoyu.png',
  '399': 'assets/images/weather/zhongyu.png',
  '400': 'assets/images/weather/xiaoxue.png',
  '401': 'assets/images/weather/zhongxue.png',
  '402': 'assets/images/weather/daxue.png',
  '403': 'assets/images/weather/baoxue.png',
  '404': 'assets/images/weather/yujiaxue.png',
  '405': 'assets/images/weather/yujiaxue.png',
  '406': 'assets/images/weather/yujiaxue.png',
  '407': 'assets/images/weather/daxue.png',
  '408': 'assets/images/weather/xiaoxue.png',
  '409': 'assets/images/weather/zhongxue.png',
  '410': 'assets/images/weather/daxue.png',
  '456': 'assets/images/weather/zhongxue.png',
  '457': 'assets/images/weather/daxue.png',
  '499': 'assets/images/weather/zhongxue.png',
  '500': 'assets/images/weather/wu.png',
  '501': 'assets/images/weather/wu.png',
  '502': 'assets/images/weather/wu.png',
  '503': 'assets/images/weather/yangsha.png',
  '504': 'assets/images/weather/shachen.png',
  '507': 'assets/images/weather/shachen.png',
  '508': 'assets/images/weather/shachen.png',
  '509': 'assets/images/weather/wu.png',
  '510': 'assets/images/weather/wu.png',
  '511': 'assets/images/weather/wu.png',
  '512': 'assets/images/weather/wu.png',
  '513': 'assets/images/weather/wu.png',
  '514': 'assets/images/weather/wu.png',
  '900': 'assets/images/weather/qing.png',
  '901': 'assets/images/weather/qing.png',
  '999': 'assets/images/weather/qing.png',
};

_handleTap() {
  Toast.show('功能暂未开放');
}

final menus = [
  {'title': '量地块', 'icon': 'assets/images/my_farm/menus/measure_land.png', 'link': _handleTap},
  {
    'title': '农场设置',
    'icon': 'assets/images/my_farm/menus/farm_setup.png',
    'link': () {
      Get.toNamed('/my_farm/add_farm?id=${Get.find<MyFarmModel>().selectedFarm.value!.value}');
    },
  },
  {
    'title': '巡田记录',
    'icon': 'assets/images/my_farm/menus/field_patrol_records.png',
    'link': _handleTap,
  },
  {
    'title': '农事记录',
    'icon': 'assets/images/my_farm/menus/agricultural_records.png',
    'link': _handleTap,
  },
  {
    'title': '遥感监测',
    'icon': 'assets/images/my_farm/menus/remote_sensing_monitoring.png',
    'link': _handleTap,
  },
  {'title': '物联设备', 'icon': 'assets/images/my_farm/menus/iot_devices.png', 'link': _handleTap},
  {
    'title': '产品溯源',
    'icon': 'assets/images/my_farm/menus/product_traceability.png',
    'link': _handleTap,
  },
  {'title': '农场天气', 'icon': 'assets/images/my_farm/menus/farm_weather.png', 'link': _handleTap},
];
