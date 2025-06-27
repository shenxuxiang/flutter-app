import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

typedef InputSubmit = void Function(String);
typedef InputChanged = void Function(String input);

class InputBox extends StatefulWidget {
  final String value;
  final int maxLength;
  final Widget suffix;
  final bool autofocus;
  final bool allowClear;
  final String? hintText;
  final bool obscureText;
  final InputSubmit? onSubmit;
  final InputChanged onChanged;
  final VoidCallback? onComplete;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final MaxLengthEnforcement maxLengthEnforcement;

  const InputBox({
    super.key,
    this.hintText,
    this.onSubmit,
    this.onComplete,
    required this.value,
    this.maxLength = 9999,
    this.autofocus = false,
    this.allowClear = true,
    required this.onChanged,
    this.obscureText = false,
    this.suffix = const SizedBox(),
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLengthEnforcement = MaxLengthEnforcement.truncateAfterCompositionEnds,
  });

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  bool _isHidden = false;
  bool _hasFocus = false;
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller = TextEditingController(text: widget.value ?? '');

  @override
  void initState() {
    _hasFocus = widget.autofocus;
    _isHidden = widget.obscureText;
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(InputBox oldWidget) {
    if (widget.value != _controller.text) _controller.text = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  /// 清除文本
  void handleClear() {
    _controller.text = '';
    widget.onChanged('');
  }

  void triggerVisibleOrHidden() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 266.w,
      height: 36.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.w),
        color: Theme.of(context).primaryColorLight,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorHeight: 18.w,
              focusNode: _focusNode,
              obscureText: _isHidden,
              controller: _controller,
              autofocus: widget.autofocus,
              maxLength: widget.maxLength,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmit,
              keyboardType: widget.textInputType,
              onEditingComplete: widget.onComplete,
              textInputAction: widget.textInputAction,
              cursorColor: Theme.of(context).primaryColor,
              maxLengthEnforcement: widget.maxLengthEnforcement,
              style: TextStyle(
                height: 1,
                fontSize: 14.sp,
                color: const Color(0xFF333333),
                letterSpacing: widget.obscureText ? 3 : 1,
              ),
              decoration: InputDecoration(
                hintMaxLines: 1,
                counterText: '',
                isCollapsed: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  height: 1,
                  fontSize: 14.sp,
                  letterSpacing: 1,
                  color: Theme.of(context).hintColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),

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

          /// 密码可视按钮
          widget.obscureText && _hasFocus && widget.value.isNotEmpty
              ? GestureDetector(
                onTap: triggerVisibleOrHidden,
                child: Icon(
                  size: 24,
                  color: const Color(0xFFCCCCCC),
                  _isHidden ? QmIcons.eye : QmIcons.notEye,
                ),
              )
              : const SizedBox(),

          /// 支持自定义后缀
          widget.suffix,
        ],
      ),
    );
  }
}
