import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class KnowledgeItem extends StatelessWidget {
  final dynamic info;
  final EdgeInsets? margin;

  const KnowledgeItem({super.key, required this.info, this.margin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/knowledge_base/detail?id=${info['knowledgeId']}');
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        margin: margin ?? EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                height: 1,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF333333),
              ),
            ),
            SizedBox(height: 5.w),
            Text(
              info['summary'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(height: 1.5, fontSize: 13.sp, color: const Color(0xFF666666)),
            ),
            SizedBox(height: 13.w),
            Row(
              children: [
                Icon(QmIcons.eye, size: 16.sp, color: const Color(0xFF999999)),
                SizedBox(width: 5.w),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    '${info['viewCount']}',
                    style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF999999)),
                  ),
                ),
                Text(
                  '发布时间：${info['updateTime']}',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF999999)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
