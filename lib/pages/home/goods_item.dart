import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

class GoodsItem extends StatelessWidget {
  final String id;
  final String img;
  final String date;
  final String title;

  const GoodsItem({
    super.key,
    required this.id,
    required this.img,
    required this.date,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/policy_information/detail?id=$id');
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 97.w,
              height: 60.w,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6))),
              child: CachedNetworkImage(imageUrl: getNetworkAssetURL(img), fit: BoxFit.cover),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1.5),
                  ),
                  SizedBox(height: 7.w),
                  Text(
                    '发布时间：$date',
                    style: TextStyle(fontSize: 11.sp, height: 1, color: const Color(0xFF999999)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
