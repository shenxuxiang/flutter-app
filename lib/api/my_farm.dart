import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 农场详情[APP端]
Future<ResponseData> queryMyFarmDetail(String id) async {
  return request.post('/v1.0/farm/detail', data: {'id': id});
}

/// 农场列表
Future<ResponseData> queryMyFarmList() async {
  return request.post('/v1.0/farm/currentUserFarms', data: {});
}

/// 获取天气
Future<ResponseData> queryWeather(dynamic query) async {
  return request.post('/v1.0/Qweather/getWeatherByRegion', data: query);
}

/// 当前登录用户的农场地块统计
Future<ResponseData> queryFarmFieldStatics(String farmId) async {
  return request.post('/v1.0/farmField/currentUserFarmFieldStatics', data: {'farmId': farmId});
}

/// 当前登录用户的农场地块统计
Future<ResponseData> queryFarmFieldList(dynamic query) async {
  return request.post('/v1.0/farmField/currentUserFarmFields', data: query);
}

/// 添加农场[APP端]
Future<ResponseData> queryAddFarm(dynamic query) async {
  return request.post('/v1.0/farm/add', data: query);
}

/// 更新农场[APP端]
Future<ResponseData> queryUpdateFarm(dynamic query) async {
  return request.post('/v1.0/farm/update', data: query);
}

/// 删除农场[APP端]
Future<ResponseData> queryDeleteFarm(String id) async {
  return request.post('/v1.0/farm/delete', data: {'id': id});
}

/// 地块详情
Future<ResponseData> queryFarmFieldDetail(String id) async {
  return request.post('/v1.0/farmField/detail', data: {'id': id});
}

/// 更新地块详情
Future<ResponseData> queryUpdateFarmFieldDetail(dynamic query) async {
  return request.post('/v1.0/farmField/update', data: query);
}
