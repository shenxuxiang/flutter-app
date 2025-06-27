import 'form_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class FormItemInput extends StatefulWidget {
  final String label;
  final String value;
  final Widget suffix;
  final bool disabled;
  final bool bordered;
  final int? maxLength;
  final bool isRequired;
  final bool allowClear;
  final String? hintText;
  final bool obscureText;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String input)? onChanged;

  const FormItemInput({
    super.key,
    this.hintText,
    this.maxLength,
    this.onChanged,
    required this.value,
    required this.label,
    this.bordered = true,
    this.disabled = false,
    this.allowClear = true,
    this.isRequired = false,
    this.obscureText = false,
    this.textAlign = TextAlign.end,
    this.suffix = const SizedBox(),
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<FormItemInput> createState() => _FormItemInputState();
}

class _FormItemInputState extends State<FormItemInput> {
  bool _hasFocus = false;
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  @override
  void didUpdateWidget(FormItemInput oldWidget) {
    final newValue = widget.value;
    if (newValue != _controller.text) {
      _controller.text = newValue;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      /// 每次获取焦点时，焦点都落在文本的末尾。
      if (_focusNode.hasFocus) {
        final length = _controller.text.length;

        _controller.selection = TextSelection(baseOffset: length, extentOffset: length);
      }
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
    _controller = TextEditingController(text: widget.value ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// 清除文本
  void handleClear() {
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return FormItem(
      label: widget.label,
      bordered: widget.bordered,
      isRequired: widget.isRequired,
      suffix: Row(
        children: [
          /// 清除按钮
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: handleClear,
              child: Container(
                height: 30.w,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(color: Colors.transparent),
                width: widget.allowClear && _hasFocus && widget.value.isNotEmpty ? 24.w : 0,
                child: Icon(QmIcons.closeRound, size: 20, color: const Color(0xFFCCCCCC)),
              ),
            ),
          ),
          widget.suffix,
        ],
      ),
      child: TextField(
        maxLines: 1,
        cursorHeight: 18.sp,
        focusNode: _focusNode,
        controller: _controller,
        enabled: !widget.disabled,
        cursorColor: primaryColor,
        textAlign: widget.textAlign,
        onChanged: widget.onChanged,
        maxLength: widget.maxLength,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: TextStyle(fontSize: 14.sp, color: const Color(0xFF333333), height: 1.5),
        decoration: InputDecoration(
          hintMaxLines: 1,
          counterText: '',
          isCollapsed: true,
          border: InputBorder.none,
          hintText: widget.hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 13.5.w),
          hintStyle: TextStyle(height: 1.5, fontSize: 14.sp, color: const Color(0xFF999999)),
        ),
      ),
    );
  }
}
