import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextArea extends StatefulWidget {
  final String value;
  final int? maxLines;
  final bool disabled;
  final double? height;
  final int? maxLength;
  final String? hintText;
  final TextInputAction textInputAction;
  final void Function(String value)? onChanged;

  const TextArea({
    super.key,
    this.height,
    this.hintText,
    this.maxLines,
    this.maxLength,
    this.onChanged,
    required this.value,
    this.disabled = false,
    this.textInputAction = TextInputAction.done,
  });

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  late final TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextArea oldWidget) {
    if (widget.value != oldWidget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = TextEditingController(text: widget.value ?? '');
    super.initState();
  }

  handleInputChange(String value) {
    if (widget.onChanged is Function) widget.onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: widget.height ?? 120.w,
          child: TextField(
            cursorHeight: 18.w,
            controller: _controller,
            readOnly: widget.disabled,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            onChanged: handleInputChange,
            textInputAction: widget.textInputAction,
            cursorColor: Theme.of(context).primaryColor,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666), height: 1.5),
            decoration: InputDecoration(
              counterText: '',
              isCollapsed: true,
              border: InputBorder.none,
              hintText: widget.hintText,
              focusedBorder: InputBorder.none,
              hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999), height: 1.5),
            ),
          ),
        ),
        widget.maxLength == null
            ? const SizedBox()
            : Container(
              padding: EdgeInsets.only(top: 8.w),
              alignment: Alignment.centerRight,
              child: Text(
                '已输入${widget.value.length}/300',
                style: TextStyle(height: 1, fontSize: 11.sp, color: const Color(0xFF4B4B4B)),
              ),
            ),
      ],
    );
  }
}
