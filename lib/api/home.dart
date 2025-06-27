import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 新闻列表
Future<ResponseData> queryNewsList(dynamic query) async {
  return request.post('/v1.0/policyInformation/page', data: query);
}

/// 新闻详情
Future<ResponseData> queryNewsDetail(String id) async {
  return request.post('/v1.0/policyInformation/detail', data: {'id': id});
}

/// banner列表
Future<ResponseData> queryBannerList() async {
  return request.post('/v1.0/banner/list', data: {});
}
