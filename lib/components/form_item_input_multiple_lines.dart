import 'form_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class FormItemInputMultipleLines extends StatefulWidget {
  final String label;
  final String? value;
  final Widget suffix;
  final bool disabled;
  final bool bordered;
  final int? maxLength;
  final bool? isRequired;
  final bool allowClear;
  final String? hintText;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String input)? onChanged;

  const FormItemInputMultipleLines({
    super.key,
    this.value,
    this.hintText,
    this.maxLength,
    this.onChanged,
    this.isRequired,
    required this.label,
    this.bordered = true,
    this.disabled = false,
    this.allowClear = true,
    this.textAlign = TextAlign.end,
    this.suffix = const SizedBox(),
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<FormItemInputMultipleLines> createState() => _FormItemInputMultipleLinesState();
}

class _FormItemInputMultipleLinesState extends State<FormItemInputMultipleLines> {
  bool _hasFocus = false;
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  @override
  void didUpdateWidget(FormItemInputMultipleLines oldWidget) {
    final newValue = widget.value;
    if (newValue != null && newValue != oldWidget.value && newValue != _controller.text) {
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

    /// 添加一个高度变化的过渡效果
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 200),
      child: FormItem(
        label: widget.label,
        bordered: widget.bordered,
        isRequired: widget.isRequired ?? false,
        suffix: Row(
          children: [
            /// 清除按钮
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
                onTap: handleClear,
                child: Container(
                  height: 30.w,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(color: Colors.transparent),
                  width:
                      widget.allowClear && _hasFocus && (widget.value?.isNotEmpty ?? false)
                          ? 24.w
                          : 0,
                  child: Icon(QmIcons.closeRound, size: 24, color: const Color(0xFFCCCCCC)),
                ),
              ),
            ),
            widget.suffix,
          ],
        ),
        child: TextField(
          /// maxLines 必须设置为 null，如果显示的设置为数值，则高度 TextField 高度将固定，
          /// 此时就无法实现高度根据内容自适应了。
          maxLines: null,
          cursorHeight: 18.sp,
          focusNode: _focusNode,
          controller: _controller,
          enabled: !widget.disabled,
          cursorColor: primaryColor,
          textAlign: widget.textAlign,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
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
      ),
    );
  }
}
