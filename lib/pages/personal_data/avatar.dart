import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getNetworkAssetURL;

class Avatar extends StatelessWidget {
  final String? avatar;
  final VoidCallback? onChange;

  const Avatar({super.key, this.avatar, this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '头像',
                style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
              ),
            ),
            ClipOval(
              child:
                  (avatar ?? '').isEmpty
                      ? Image.asset(
                        'assets/images/default_avatar.png',
                        width: 53.w,
                        height: 53.w,
                        fit: BoxFit.cover,
                      )
                      : CachedNetworkImage(
                        width: 53.w,
                        height: 53.w,
                        fit: BoxFit.cover,
                        imageUrl: getNetworkAssetURL(avatar!),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
              child: Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF4A4A4A)),
            ),
          ],
        ),
      ),
    );
  }
}
