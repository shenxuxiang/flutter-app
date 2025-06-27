import 'package:qm_agricultural_machinery_services/utils/http_request.dart';
import 'package:qm_agricultural_machinery_services/entity/response_data.dart';

/// 知识库
Future<ResponseData> queryKnowledgeList(dynamic query) async {
  return request.post('/v1.0/knowledge/page', data: query);
}

/// 知识库类目
Future<ResponseData> queryCategoryList() async {
  return request.post('/v1.0/sysDict/list', data: {'dictTypeCode': 'knowledge_type'});
}

/// 知识库详情
Future<ResponseData> queryKnowledgeDetail(String id) async {
  return request.post('/v1.0/knowledge/detail', data: {'id': id});
}
