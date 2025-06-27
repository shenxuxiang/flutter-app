import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/components/counter.dart';

class SelectCount extends StatelessWidget {
  final void Function(int count)? onChanged;
  final String productName;
  final String serverName;
  final String avatar;
  final String price;
  final String flag;
  final String unit;
  final int count;

  const SelectCount({
    super.key,
    this.onChanged,
    required this.flag,
    required this.unit,
    required this.count,
    required this.price,
    required this.avatar,
    required this.serverName,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122.w,
      margin: EdgeInsets.only(top: 12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF0F0F0)),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: CachedNetworkImageProvider(getNetworkAssetURL(avatar)),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 1,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 8.w),
                Text(
                  '# $flag',
                  style: TextStyle(height: 1, fontSize: 12.sp, color: const Color(0xFF1890FF)),
                ),
                SizedBox(height: 8.w),
                Text(
                  serverName,
                  style: TextStyle(height: 1, fontSize: 12.sp, color: const Color(0xFF666666)),
                ),
                SizedBox(height: 14.w),
                SizedBox(
                  height: 28.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '¥$price$unit',
                        style: TextStyle(
                          height: 1,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFF4D4F),
                        ),
                      ),
                      Counter(value: count, onChanged: onChanged),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
