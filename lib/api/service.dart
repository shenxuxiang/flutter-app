import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 提交订单
Future<ResponseData> querySubmitServiceOrder(dynamic query) async {
  return request.post('/v1.0/serviceOrder/submitOrder', data: query);
}

/// 获取订单列表
Future<ResponseData> queryUserOrderList(dynamic query) async {
  return request.post('/v1.0/serviceOrder/userPage', data: query);
}

/// 取消订单
Future<ResponseData> queryCancelUserOrder(dynamic query) async {
  return request.post('/v1.0/serviceOrder/cancel', data: query);
}

/// 订单完结
Future<ResponseData> queryConfirmEndUserOrder(dynamic query) async {
  return request.post('/v1.0/serviceOrder/confirmEnd', data: query);
}

/// 订单详情
Future<ResponseData> queryUserOrderDetail(dynamic query) async {
  return request.post('/v1.0/serviceOrder/detail', data: query);
}

/// 身份证背面识别
Future<ResponseData> queryUploadIDCardBack(dynamic query) async {
  return request.post('/v1.0/cardOcr/idCardBack', data: query);
}

/// 身份证人面识别
Future<ResponseData> queryUploadIDCardFace(dynamic query) async {
  return request.post('/v1.0/cardOcr/idCardFace', data: query);
}

/// 农户提交认证
Future<ResponseData> querySubmitFarmerCheck(dynamic query) async {
  return request.post('/v1.0/farmerCheck/submit', data: query);
}
