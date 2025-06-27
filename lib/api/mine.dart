import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 获取用户认证状态
Future<ResponseData> queryUserStatus() async {
  return request.post('/v1.0/sysUser/getCheckStatus', data: {});
}

/// 获取用户认证状态信息
Future<ResponseData> queryUserStatusInfo() async {
  return request.post('/v1.0/farmerCheck/app/farmerCheckInfo', data: {});
}
