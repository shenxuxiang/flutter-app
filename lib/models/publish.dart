import 'package:get/get.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart' as api;
import 'package:qm_agricultural_machinery_services/entity/demand_category.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;

class PublishModel extends GetxController {
  final demandCategoryList = Rx<List<DemandCategory>>([]);

  setDemandCategoryList(List<dynamic> newValue) {
    List<DemandCategory> list = [];
    for (final item in newValue) {
      list.add(DemandCategory.fromJson(item));
    }

    demandCategoryList.value = list;
  }

  /// 获取需求大类
  Future<void> queryDemandSubcategoryTreeList() async {
    try {
      final resp = await api.queryDemandSubcategoryTreeList();
      setDemandCategoryList(resp.data);
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 清除缓存
  clearCache() {
    setDemandCategoryList([]);
  }
}
