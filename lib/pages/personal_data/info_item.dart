import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class InfoItem extends StatelessWidget {
  final String label;
  final String? value;
  final bool bordered;
  final VoidCallback? onChange;

  const InfoItem({super.key, required this.label, this.value, this.bordered = true, this.onChange});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChange,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          border:
              bordered
                  ? const Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5))
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
            ),
            Expanded(
              child: Text(
                value ?? '',
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF333333)),
              ),
            ),
            onChange == null
                ? SizedBox(height: 24.w)
                : Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                  child: Icon(QmIcons.forward, size: 24.sp, color: const Color(0xFF4A4A4A)),
                ),
          ],
        ),
      ),
    );
  }
}
