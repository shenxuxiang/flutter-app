import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/entity/user_info.dart';
import 'package:qm_agricultural_machinery_services/entity/breeding_type.dart';
import 'package:qm_agricultural_machinery_services/entity/receiving_address.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;

class MainModel extends GetxController {
  final userInfo = Rx<UserInfo?>(null);

  void setUserInfo(Map<String, dynamic>? newValue) {
    userInfo.value = newValue != null ? UserInfo.fromJson(newValue) : null;
  }

  final regionSourceTree = Rx<List<dynamic>>([]);

  void setRegionSourceTree(List<dynamic> newValue) {
    regionSourceTree.value = newValue;
  }

  /// 服务子类树列表
  final serviceSubCategory = Rx<List<dynamic>>([]);

  void setServiceSubCategory(List<dynamic> newValue) {
    serviceSubCategory.value = newValue;
  }

  /// 获取服务大类
  Future<void> queryServiceSubCategory() async {
    try {
      final resp = await api.queryServiceSubCategory({});
      setServiceSubCategory(resp.data);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 用户当前默认的收获地址
  final defaultReceivingAddress = Rx<ReceivingAddress?>(null);

  /// 用户收获地址列表
  final userReceivingAddressList = Rx<List<ReceivingAddress>>([]);

  /// 获取收货地址列表
  void setUserReceivingAddressList(List<dynamic> newValue) {
    final List<ReceivingAddress> result = [];
    for (final item in newValue) {
      final address = ReceivingAddress.fromJson(item);
      if (address.defaultFlag) defaultReceivingAddress.value = address;
      result.add(address);
    }

    userReceivingAddressList.value = result;
  }

  /// 获取收货地址列表
  Future<void> queryReceivingAddressList() async {
    try {
      final resp = await queryUserAddressList({'pageNum': 1, 'pageSize': 999});
      setUserReceivingAddressList(resp.data['list'] ?? []);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 种养殖业
  final breadingTypeTreeList = Rx<List<BreedingType>>([]);

  void setBreadingTypeTreeList(List<dynamic> newValue) {
    List<BreedingType> result = [];
    for (final item in newValue) {
      result.add(BreedingType.fromJson(item));
    }

    breadingTypeTreeList.value = result;
  }

  /// 清除缓存
  clearCache() {
    setUserInfo(null);
    setServiceSubCategory([]);
    setBreadingTypeTreeList([]);
    setUserReceivingAddressList([]);
  }
}
