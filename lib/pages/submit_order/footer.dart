import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class Footer extends StatelessWidget {
  final int? count;
  final num? price;
  final VoidCallback onSubmit;

  const Footer({super.key, this.count, this.price, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.w,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0xFFEFEFEF), offset: Offset(0, -0.3), blurRadius: 2)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '预估费用:',
                style: TextStyle(
                  height: 1,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '¥ ${(count ?? 0) * (price ?? 0)}',
                style: TextStyle(
                  height: 1,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF4D4F),
                ),
              ),
            ],
          ),
          ButtonWidget(height: 36.w, width: 120.w, radius: 18.w, text: '立即提交', onTap: onSubmit),
        ],
      ),
    );
  }
}
