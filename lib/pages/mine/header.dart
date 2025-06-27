import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show getNetworkAssetURL;

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        GetX<MainModel>(
          builder: (controller) {
            final userInfo = controller.userInfo.value;
            return Container(
              height: 62.w,
              margin: EdgeInsets.fromLTRB(20.w, 48.w, 20.w, 0),
              child: Row(
                children: [
                  ClipOval(
                    child:
                        userInfo?.avatar.isEmpty ?? true
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
                              imageUrl: getNetworkAssetURL(userInfo!.avatar),
                            ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo?.username ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 1,
                            color: const Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 7.w),
                        Row(
                          children: [
                            Icon(QmIcons.phone, size: 16.sp, color: const Color(0xFF4A4A4A)),
                            SizedBox(width: 5.w),
                            Text(
                              userInfo?.phone ?? '',
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7.w),
                        Row(
                          children: [
                            Icon(QmIcons.location, size: 16.sp, color: const Color(0xFF4A4A4A)),
                            SizedBox(width: 5.w),
                            Text(
                              userInfo?.regionName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                height: 1,
                                fontSize: 13.sp,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          top: 28.w,
          right: 8.w,
          child: Icon(QmIcons.systemSetting, size: 24.sp, color: const Color(0xFF333333)),
        ),
      ],
    );
  }
}
