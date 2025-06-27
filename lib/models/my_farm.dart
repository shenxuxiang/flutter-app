import 'dart:core';
import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/entity/farm_info.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';

class MyFarmModel extends GetxController {
  final farmInfo = Rx<FarmInfo?>(null);

  setFarmInfo(dynamic newValue) {
    farmInfo.value = FarmInfo.fromJson(newValue);
  }

  /// 当前选中的农场 ID
  final farmId = ''.obs;

  /// 我的农场列表
  final farmList = Rx<List<ListItemOption>>([]);

  final selectedFarm = Rx<ListItemOption?>(null);
}
