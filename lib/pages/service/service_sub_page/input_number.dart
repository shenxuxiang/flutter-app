import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputNumber extends StatefulWidget {
  final String? value;
  final String? hintText;
  final TextAlign textAlign;
  final void Function(String input)? onChanged;

  const InputNumber({
    super.key,
    this.value,
    this.hintText,
    this.onChanged,
    this.textAlign = TextAlign.left,
  });

  @override
  State<InputNumber> createState() => _InputNumberState();
}

class _InputNumberState extends State<InputNumber> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value ?? '');
    super.initState();
  }

  @override
  void didUpdateWidget(InputNumber oldWidget) {
    if (oldWidget.value != widget.value) _controller.text = widget.value ?? '';
    super.didUpdateWidget(oldWidget);
  }

  handleInputChange(String value) {
    if (widget.onChanged is Function) widget.onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFCCCCCC)));
    return TextField(
      cursorHeight: 16.sp,
      controller: _controller,
      textAlign: widget.textAlign,
      onChanged: handleInputChange,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      cursorColor: Theme.of(context).primaryColor,
      style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF333333)),
      decoration: InputDecoration(
        hintMaxLines: 1,
        border: border,
        isCollapsed: true,
        errorBorder: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: widget.hintText,
        focusedErrorBorder: border,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 7.w),
        hintStyle: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF999999)),
      ),
    );
  }
}
