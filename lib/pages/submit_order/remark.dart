import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/components/text_area.dart';

class Remark extends StatelessWidget {
  final String value;
  final bool disabled;
  final void Function(String value)? onChanged;

  const Remark({super.key, required this.value, this.onChanged, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.w),
        Text(
          '备注信息',
          style: TextStyle(
            height: 1,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: 10.w),
        TextArea(
          value: value,
          maxLength: 300,
          disabled: disabled,
          onChanged: onChanged,
          hintText: '请补充您的需求或特殊情况',
        ),
      ],
    );
  }
}
