import 'form_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/date_picker.dart';

class FormItemTimePicker extends StatelessWidget {
  final String label;
  final bool bordered;
  final bool disabled;
  final String hintText;
  final bool isRequired;
  final DateTime? dateTime;
  final void Function(DateTime time) onChanged;

  const FormItemTimePicker({
    super.key,
    this.dateTime,
    this.hintText = '',
    required this.label,
    this.bordered = true,
    this.disabled = false,
    this.isRequired = false,
    required this.onChanged,
  });

  void handleOpenModal(BuildContext context) async {
    if (disabled) return;

    /// 隐藏软键盘
    FocusScope.of(context).unfocus();
    DatePicker.showDateTimePicker(
      context: context,
      dateTime: dateTime,
      onConfirm: (DateTime time) {
        onChanged(time);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      height: 48.5.w,
      bordered: bordered,
      isRequired: isRequired,
      onTap: () => handleOpenModal(context),
      suffix: disabled ? null : Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF999999)),
      child: Text(
        dateTime == null ? hintText : dateTime!.toString().substring(0, 19),
        maxLines: 1,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          height: 1,
          fontSize: 14.sp,
          color: dateTime == null ? const Color(0xFF999999) : const Color(0xFF333333),
        ),
      ),
    );
  }
}
