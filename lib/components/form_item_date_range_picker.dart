import 'form_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/date_picker.dart';

class FormItemDateRangePicker extends StatelessWidget {
  final String label;
  final bool bordered;
  final bool disabled;
  final String hintText;
  final DateTime? endTime;
  final DateTime? startTime;
  final void Function([DateTime? startTime, DateTime? endTime]) onChanged;

  const FormItemDateRangePicker({
    super.key,
    this.endTime,
    this.startTime,
    this.hintText = '',
    required this.label,
    this.bordered = true,
    this.disabled = false,
    required this.onChanged,
  });

  void handleOpenModal(BuildContext context) async {
    if (disabled) return;

    /// 隐藏软键盘
    FocusScope.of(context).unfocus();

    DatePicker.showDateRangePicker(
      endTime: endTime,
      startTime: startTime,
      onConfirm: (start, end) {
        onChanged(start, end);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      height: 48.5.w,
      bordered: bordered,
      onTap: () => handleOpenModal(context),
      suffix: disabled ? null : Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF999999)),
      child: Text(
        (startTime == null || endTime == null)
            ? hintText
            : '${startTime!.toString().substring(0, 10)} - ${endTime!.toString().substring(0, 10)}',
        maxLines: 1,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: 1,
          fontSize: 14.sp,
          color:
              (startTime == null || endTime == null)
                  ? const Color(0xFF999999)
                  : const Color(0xFF333333),
        ),
      ),
    );
  }
}
