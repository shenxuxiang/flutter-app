import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/base_page.dart';
import 'package:qm_agricultural_machinery_services/components/header_nav_bar.dart';
import 'package:qm_agricultural_machinery_services/components/image.dart';
import 'package:qm_agricultural_machinery_services/components/page.dart';

class AboutUsPage extends BasePage {
  const AboutUsPage({super.key, required super.title, required super.author});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

const _aboutUsText =
    '安徽阡陌网络科技有限公司孵化自中国科学院，由芜湖市政府、中国科学院、中华供销总社联合出资成立。阡陌科技作为国家级科技型中小企业，依托北斗、无人机、遥感、物联网、大数据、云计算等技术，通过数据采集、分析、研究、应用等数据处理，积极赋能和推动中国空天大数据产业健康发展，构建空天大数据服务产业链，实现乡村资源和产业之间的优化配置，提供包括智慧农业在内的各类专业化社会服务。';

class _AboutUsPageState extends BasePageState<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return PageWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: HeaderNavBar(title: widget.title),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.w),
                Image.asset(
                  'assets/images/login_logo.png',
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 13.w),
                Text(
                  '阡陌·爱农田',
                  style: TextStyle(
                    height: 1,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 6.w),
                Text(
                  '从种到收，全程守护！',
                  style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF999999)),
                ),
                SizedBox(height: 16.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    _aboutUsText,
                    style: TextStyle(height: 1.6, fontSize: 13.sp, color: const Color(0xFF4B4B4B)),
                  ),
                ),
                SizedBox(height: 12.w),
                ImageWidget(
                  image: 'assets/images/qr_code.png',
                  width: 147.w,
                  height: 147.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 12.w),
                Text(
                  '关注微信公众号',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4A4A4A)),
                ),
                SizedBox(height: 33.w),
                Text(
                  '地址：芜湖市镜湖区滨江商务楼12层',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4A4A4A)),
                ),
                SizedBox(height: 12.w),
                Text(
                  '服务热线：0553-5010050',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4A4A4A)),
                ),
                SizedBox(height: 12.w),
                Text(
                  '邮箱：jishu@ahqianmo.com',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4A4A4A)),
                ),
                SizedBox(height: 33.w),
                Text(
                  '安徽阡陌网络科技有限公司',
                  style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF4B4B4B)),
                ),
                SizedBox(height: 6.w),
                Text(
                  'Copyright © www.ahqianmo.com, All Rights Reserved.',
                  style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF999999)),
                ),
                SizedBox(height: 33.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
