import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 账号登录
Future<ResponseData> queryAccountLogin(dynamic query) async {
  return request.post('/v1.0/auth/login', data: query);
}

/// 手机验证码登录
Future<ResponseData> queryPhoneCode(dynamic query) async {
  return request.post('/v1.0/auth/login/phoneCode', data: query);
}

/// 退出登录
Future<ResponseData> queryLogOut(dynamic query) async {
  return request.post('/v1.0/auth/logout', data: query);
}
