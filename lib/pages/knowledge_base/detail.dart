import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/rich_text_editor.dart';
import 'package:qm_agricultural_machinery_services/api/technology.dart' show queryKnowledgeDetail;
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';

class KnowledgeBaseDetailPage extends BasePage {
  const KnowledgeBaseDetailPage({super.key, required super.title, required super.author});

  @override
  State<KnowledgeBaseDetailPage> createState() => _KnowledgeBaseDetailPageState();
}

class _KnowledgeBaseDetailPageState extends BasePageState<KnowledgeBaseDetailPage> {
  String title = '';
  String source = '';
  String content = '';
  String updateTime = '';
  bool _isLoading = true;

  @override
  void initState() {
    handleLoad();
    super.initState();
  }

  handleLoad() async {
    try {
      final resp = await queryKnowledgeDetail(Get.parameters['id']!);
      final data = resp.data;
      setState(() {
        title = data['title'];
        source = data['source'];
        content = data['content'];
        updateTime = data['updateTime'];
        _isLoading = false;
      });
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const HeaderNavBar(title: '详情'),
        body:
            _isLoading
                ? const SkeletonScreen()
                : Container(
                  margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            height: 1,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 20.w),
                        Row(
                          children: [
                            Text(
                              '时间：$updateTime',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF666666),
                                height: 1,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '来源：$source',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xFF666666),
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.w),
                        RichTextEditor(value: content),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
