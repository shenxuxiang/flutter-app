import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qm_agricultural_machinery_services/api/publish.dart';
import 'package:qm_agricultural_machinery_services/utils/call_phone_sheet_dialog.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/image.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';

class ServiceDemandDetail extends BasePage {
  const ServiceDemandDetail({super.key, required super.author, required super.title});

  @override
  State<ServiceDemandDetail> createState() => _ServiceDemandDetailState();
}

class _ServiceDemandDetailState extends BasePageState<ServiceDemandDetail> {
  Map<String, dynamic> detail = {};

  @override
  void onMounted() async {
    CloseLoading closeLoading = Loading.show();
    try {
      final resp = await queryHallDemandDetail(Get.parameters['id']!);
      setState(() {
        detail = resp.data;
      });
    } finally {
      closeLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child:
              detail.isEmpty
                  ? const SkeletonScreen()
                  : Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 12.w),
                        padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 16.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child:
                                      detail['farmerAvatar']?.isEmpty ?? true
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
                                            imageUrl: getNetworkAssetURL(detail['farmerAvatar']),
                                          ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail['farmerName'],
                                        style: TextStyle(
                                          height: 1,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF333333),
                                        ),
                                      ),
                                      SizedBox(height: 6.w),
                                      Row(
                                        children: [
                                          Icon(
                                            QmIcons.confirm,
                                            size: 22.sp,
                                            color:
                                                detail['serverUserType'] == '农户'
                                                    ? primaryColor
                                                    : const Color(0xFF333333),
                                          ),
                                          Text(
                                            detail['serverUserType'] ?? '',
                                            style: TextStyle(
                                              height: 1,
                                              fontSize: 16.sp,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ButtonWidget(
                                  ghost: true,
                                  width: 80.w,
                                  height: 28.w,
                                  radius: 14.w,
                                  text: '立即联系',
                                  disabled: detail['contactPersonPhone']?.isEmpty ?? true,
                                  onTap: () {
                                    showCallPhoneSheetDialog(phone: detail['contactPersonPhone']);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.w),
                            Text(
                              '联系人信息',
                              style: TextStyle(
                                height: 1,
                                fontSize: 16.sp,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
                            SizedBox(height: 16.w),
                            Row(
                              children: [
                                Icon(QmIcons.location, size: 21.sp, color: const Color(0xFF4A4A4A)),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            detail['farmerName'],
                                            style: TextStyle(
                                              height: 1,
                                              fontSize: 16.sp,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            detail['contactPersonPhone'],
                                            style: TextStyle(
                                              height: 1,
                                              fontSize: 13.sp,
                                              color: const Color(0xFF4A4A4A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.w),
                                      Text(
                                        '${detail['regionName']}${detail['contactPersonAddress']}',
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.w),
                        padding: EdgeInsets.fromLTRB(12.w, 14.w, 12.w, 16.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '需求信息',
                              style: TextStyle(
                                height: 1,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            SizedBox(height: 16.5.w),
                            InfoItem(
                              maxLines: 2,
                              label: '需求标题',
                              lineHeight: 1.5,
                              fontWeight: FontWeight.bold,
                              content: '${detail['serviceTitle']}',
                            ),
                            SizedBox(height: 8.5.w),
                            InfoItem(
                              label: '需求类型',
                              contentColor: const Color(0xFF1890FF),
                              content:
                                  '# ${detail['demandCategoryName']} | ${detail['demandSubcategoryName']}',
                            ),
                            SizedBox(height: 12.w),
                            InfoItem(
                              label: '服务时间',
                              content:
                                  '${detail['serviceStartTime'].substring(0, 10)} 至 ${detail['serviceEndTime'].substring(0, 10)}',
                            ),
                            SizedBox(height: 12.w),
                            InfoItem(label: '发布时间', content: detail['updateTime']),
                          ],
                        ),
                      ),
                      detail['remark']?.isEmpty ?? true
                          ? const SizedBox.shrink()
                          : Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 12.w),
                            padding: EdgeInsets.fromLTRB(12.w, 14.w, 12.w, 16.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '需求信息',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 22.5.w),
                                Text(
                                  detail['remark'],
                                  maxLines: 999,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      detail['picList']?.isEmpty ?? true
                          ? const SizedBox.shrink()
                          : Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 12.w),
                            padding: EdgeInsets.fromLTRB(12.w, 14.w, 12.w, 12.w),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '相关图片',
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF333333),
                                  ),
                                ),
                                SizedBox(height: 22.5.w),
                                Wrap(
                                  spacing: 12.w,
                                  runSpacing: 12.w,
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    for (final img in detail['picList'])
                                      Container(
                                        width: 96.w,
                                        height: 96.w,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                          border: Border.fromBorderSide(
                                            BorderSide(width: 0.5, color: Color(0xFFE0E0E0)),
                                          ),
                                        ),
                                        child: ImageWidget(image: img, fit: BoxFit.cover),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String content;
  final Color contentColor;
  final int maxLines;
  final double lineHeight;
  final FontWeight? fontWeight;

  const InfoItem({
    super.key,
    this.maxLines = 1,
    this.lineHeight = 1,
    required this.label,
    required this.content,
    this.fontWeight = FontWeight.normal,
    this.contentColor = const Color(0xFF333333),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label：',
          style: TextStyle(height: lineHeight, fontSize: 14.sp, color: const Color(0xFF333333)),
        ),
        Expanded(
          child: Text(
            content,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              height: lineHeight,
              color: contentColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ],
    );
  }
}
