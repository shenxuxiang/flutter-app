import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class InputWidget extends StatefulWidget {
  final String label;
  final String value;
  final int maxLength;
  final Widget suffix;
  final bool autofocus;
  final bool allowClear;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String input) onChanged;

  const InputWidget({
    super.key,
    this.hintText,
    required this.label,
    required this.value,
    this.maxLength = 999,
    this.autofocus = false,
    this.allowClear = true,
    required this.onChanged,
    this.obscureText = false,
    this.suffix = const SizedBox(),
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool _isHidden = false;
  bool _hasFocus = false;
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  @override
  void initState() {
    _hasFocus = widget.autofocus;
    _isHidden = widget.obscureText;
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(InputWidget oldWidget) {
    if (widget.value != _controller.text) _controller.text = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  /// 清除文本
  void handleClear() {
    widget.onChanged('');
  }

  void triggerVisibleOrHidden() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return SizedBox(
      height: 60.w,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
          ),
          Container(
            height: 39.w,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFCCCCCC))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorHeight: 18.w,
                    focusNode: _focusNode,
                    obscureText: _isHidden,
                    controller: _controller,
                    cursorColor: primaryColor,
                    autofocus: widget.autofocus,
                    onChanged: widget.onChanged,
                    maxLength: widget.maxLength,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    style: TextStyle(fontSize: 14.sp, height: 1, color: const Color(0xFF333333)),
                    decoration: InputDecoration(
                      counterText: '',
                      hintMaxLines: 1,
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintStyle: TextStyle(
                        height: 1,
                        fontSize: 14.sp,
                        color: const Color(0xFF999999),
                      ),
                      isCollapsed: true,
                    ),
                  ),
                ),

                /// 清除按钮
                widget.allowClear && _hasFocus && widget.value.isNotEmpty
                    ? GestureDetector(
                      onTap: handleClear,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(QmIcons.closeRound, size: 24, color: const Color(0xFFCCCCCC)),
                      ),
                    )
                    : const SizedBox(),

                /// 密码可视按钮
                widget.obscureText && _hasFocus && widget.value.isNotEmpty
                    ? GestureDetector(
                      onTap: triggerVisibleOrHidden,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          size: 24.sp,
                          color: const Color(0xFFCCCCCC),
                          _isHidden ? QmIcons.eye : QmIcons.notEye,
                        ),
                      ),
                    )
                    : const SizedBox(),

                widget.suffix,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
