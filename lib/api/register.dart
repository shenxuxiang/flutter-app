import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 注册
Future<ResponseData> queryUserRegister(dynamic query) async {
  return request.post('/v1.0/auth/register', data: query);
}
