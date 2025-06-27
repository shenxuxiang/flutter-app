import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 需求子类树列表
Future<ResponseData> queryDemandSubcategoryTreeList() async {
  return request.post('/v1.0/demandSubcategory/treeList', data: {});
}

/// 发布需求
Future<ResponseData> queryPublishDemand(dynamic query) async {
  return request.post('/v1.0/farmerService/add', data: query);
}

/// 重新发布需求
Future<ResponseData> queryRepublishDemand(dynamic query) async {
  return request.post('/v1.0/farmerService/update', data: query);
}

/// 需求发布管理/需求大厅/我的需求 分页列表
Future<ResponseData> queryMyDemandList(dynamic query) async {
  return request.post('/v1.0/farmerService/page', data: query);
}

/// 取消发布
Future<ResponseData> queryCancelPublish(String id) async {
  return request.post('/v1.0/farmerService/statusUpdate', data: {'serviceId': id});
}

/// 删除发布
Future<ResponseData> queryDeletePublish(String id) async {
  return request.post('/v1.0/farmerService/delete', data: {'id': id});
}

/// 需求详情
Future<ResponseData> queryDemandDetail(String id) async {
  return request.post('/v1.0/farmerService/appDetail', data: {'id': id});
}

/// 服务->需求 分页列表/需求大厅[APP端]
Future<ResponseData> queryHallDemandList(dynamic query) async {
  return request.post('/v1.0/farmerService/hallPage', data: query);
}

/// 服务->需求 分页列表/需求大厅[APP端]详情
Future<ResponseData> queryHallDemandDetail(String id) async {
  return request.post('/v1.0/farmerService/detail', data: {'id': id});
}
