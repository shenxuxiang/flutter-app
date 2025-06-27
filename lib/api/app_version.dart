import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// APP 版本列表
Future<ResponseData> queryAppVersionList(dynamic query) async {
  return request.post('/v1.0/sysAppVersion/list', data: query);
}

/// 检测 APP 版本
Future<ResponseData> queryCheckAppVersion(dynamic query) async {
  return request.post('/v1.0/sysAppVersion/new', data: query);
}
