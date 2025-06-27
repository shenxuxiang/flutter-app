import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 获取省市区
Future<ResponseData> queryRegionSourceTree(int level) async {
  return request.post('/v1.0/chinaProvince/region', data: {'level': level});
}

/// 获取用户验证码
Future<ResponseData> queryUserVerificationCode(dynamic query) async {
  return request.post('/v1.0/auth/sms/send', data: query);
}

/// 获取用户信息
Future<ResponseData> queryUserInfo() async {
  return request.post('/v1.0/sysUser/info');
}

/// 更新用户信息
Future<ResponseData> queryUpdateUserInfo(dynamic query) async {
  return request.post('/v1.0/sysUser/updateSelfInfo', data: query);
}

/// 获取用户信息
Future<ResponseData> queryServiceSubCategory(dynamic query) async {
  return request.post('/v1.0/serviceSubcategory/treeList', data: query);
}

/// 服务产品分页列表
Future<ResponseData> queryServiceProductList(dynamic query) async {
  return request.post('/v1.0/serviceProduct/userPage', data: query);
}

/// 服务产品详情
Future<ResponseData> queryServiceProductDetail(dynamic query) async {
  return request.post('/v1.0/serviceProduct/detail', data: query);
}

/// 图片上传
Future<ResponseData> queryUploadImage({dynamic query, SendProgress? onSendProgress}) async {
  return request.post('/v1.0/file/upload', data: query, onSendProgress: onSendProgress);
}

/// 获取用户的收货地址列表
Future<ResponseData> queryUserAddressList(dynamic query) async {
  return request.post('/v1.0/userAddress/page', data: query);
}

/// 根据经纬度获取周边地址
Future<ResponseData> queryPlaceAroundList(dynamic query) async {
  if (query.containsKey('keywords') && query['keywords'].isNotEmpty) {
    return request.post('/v1.0/chinaStreet/queryPlaceText', data: query);
  } else {
    return request.post('/v1.0/chinaStreet/queryPlaceAround', data: query);
  }
}

/// 新增地址
Future<ResponseData> addUserAddress(dynamic query) async {
  return request.post('/v1.0/userAddress/add', data: query);
}

/// 修改地址
Future<ResponseData> updateUserAddress(dynamic query) async {
  return request.post('/v1.0/userAddress/update', data: query);
}

/// 地址详情
Future<ResponseData> queryUserAddressDetail(dynamic query) async {
  return request.post('/v1.0/userAddress/detail', data: query);
}

/// 设置为默认地址
Future<ResponseData> queryUserAddressSetDefault(dynamic query) async {
  return request.post('/v1.0/userAddress/setDefault', data: query);
}

/// 删除地址
Future<ResponseData> queryUserAddressDelete(dynamic query) async {
  return request.post('/v1.0/userAddress/delete', data: query);
}

/// 更新手机号
Future<ResponseData> queryUpdateUserPhone(dynamic query) async {
  return request.post('/v1.0/sysUser/codeChangePhone', data: query);
}

/// 更新密码
Future<ResponseData> queryUpdateUserPassword(dynamic query) async {
  return request.post('/v1.0/sysUser/codeChangePwd', data: query);
}

/// 获取树形列表
Future<ResponseData> queryBreedingTypeTreeList() async {
  return request.post('/v1.0/breedingType/treeList', data: {});
}
