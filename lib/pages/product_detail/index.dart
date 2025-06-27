import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/components/page.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/pages/home/banner.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' show printLog;
import 'package:qm_agricultural_machinery_services/components/rich_text_editor.dart';
import 'package:qm_agricultural_machinery_services/utils/call_phone_sheet_dialog.dart';

class ProductDetailPage extends BasePage {
  const ProductDetailPage({super.key, required super.title, required super.author});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends BasePageState<ProductDetailPage> {
  String _unit = '';
  String _title = '';
  String _price = '';
  String _phone = '';
  bool _loading = true;
  String _introduce = '';
  String _serverName = '';
  List<dynamic> _bannerList = [];
  Map<String, dynamic> _productDetail = {};

  @override
  void onLoad() {
    handleQueryProductionDetail();
  }

  /// 获取订单详情
  handleQueryProductionDetail() async {
    try {
      final resp = await api.queryServiceProductDetail({'id': Get.parameters['id'] ?? ''});
      _productDetail = resp.data;
      setState(() {
        _loading = false;
        _phone = _productDetail['phone'];
        _unit = _productDetail['priceUnit'];
        _price = '${_productDetail['price']}';
        _title = _productDetail['productName'];
        _introduce = _productDetail['introduce'];
        _serverName = _productDetail['serverName'];
        _bannerList = _productDetail['fileUrlList'];
      });
    } catch (error, stack) {
      printLog(error);
      printLog(stack);
    }
  }

  /// 拨打电话
  handleTapPhoneButton() {
    showCallPhoneSheetDialog(phone: _phone);
  }

  /// 立即下单
  handlePlaceOrder() {
    Get.toNamed('/submit_order', arguments: _productDetail);
  }

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body:
            _loading
                ? const SkeletonScreen()
                : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200.w,
                              width: double.infinity,
                              child: BannerWidget(index: 0, bannerList: _bannerList),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
                              child: Text(
                                _title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  height: 1.125,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF333333),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
                              child: Text(
                                '¥$_price$_unit',
                                style: TextStyle(
                                  height: 1.45,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFFF4D4F),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.w),
                              child: Row(
                                children: [
                                  Icon(
                                    QmIcons.company,
                                    size: 22.sp,
                                    color: const Color(0xFF666666),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _serverName,
                                      style: TextStyle(
                                        height: 1,
                                        fontSize: 14.sp,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                  ),
                                  ButtonWidget(
                                    width: 80.w,
                                    ghost: true,
                                    height: 28.w,
                                    radius: 14.w,
                                    text: '进店逛逛',
                                    type: 'primary',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(12.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '产品/服务介绍',
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _introduce.isNotEmpty
                                ? RichTextEditor(value: _introduce)
                                : const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        bottomNavigationBar: Container(
          height: 48.w,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0xFFEfEfEF), offset: Offset(0, -0.3), blurRadius: 2),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: handleTapPhoneButton,
                child: Container(
                  color: Colors.transparent,
                  width: 51.w,
                  height: 37.w,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Icon(QmIcons.phone, color: const Color(0xFF4A4A4A), size: 22.sp),
                      Positioned(
                        top: 24.w,
                        child: Text(
                          '电话咨询',
                          style: TextStyle(
                            color: const Color(0xFF4A4A4A),
                            fontSize: 13.sp,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ButtonWidget(
                height: 36.w,
                width: 266.w,
                radius: 18.w,
                text: '立即下单',
                disabled: _loading,
                onTap: handlePlaceOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
