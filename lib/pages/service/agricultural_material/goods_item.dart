import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getNetworkAssetURL;

class GoodsItem extends StatelessWidget {
  final String serverName;
  final String goodsId;
  final String avatar;
  final String title;
  final double price;
  final String unit;

  const GoodsItem({
    super.key,
    required this.unit,
    required this.price,
    required this.title,
    required this.avatar,
    required this.goodsId,
    required this.serverName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/product_detail?id=$goodsId');
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              child: CachedNetworkImage(
                imageUrl: getNetworkAssetURL(avatar),
                height: 166.w,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            SizedBox(height: 8.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                serverName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1, fontSize: 12.sp, color: const Color(0xFF666666)),
              ),
            ),
            SizedBox(height: 12.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                '¥$price$unit',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  height: 1,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF4D4F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
