import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class InputSearch extends StatefulWidget {
  final String hintText;
  final TextAlign textAlign;
  final String? value;
  final void Function(String input) onSearch;
  final void Function(String input)? onChanged;

  const InputSearch({
    super.key,
    this.value,
    this.onChanged,
    required this.onSearch,
    this.hintText = '请输入搜索内容',
    this.textAlign = TextAlign.left,
  });

  @override
  State<InputSearch> createState() => _InputSearchState();
}

class _InputSearchState extends State<InputSearch> {
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  bool _hasFocus = false;
  String _inputValue = '';

  @override
  void didUpdateWidget(InputSearch oldWidget) {
    final newValue = widget.value;
    if (newValue != null && newValue != oldWidget.value && newValue != _controller.text) {
      _inputValue = newValue;
      _controller.text = newValue;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _inputValue = widget.value ?? '';
    _controller = TextEditingController(text: _inputValue);
    _focusNode.addListener(handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 焦点变化
  handleFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  handleInputChange(String value) {
    setState(() => _inputValue = value);
    widget.onChanged?.call(value);
  }

  handleClear() {
    handleInputChange('');
    _controller.text = '';
  }

  handleSearch() {
    _focusNode.unfocus();
    widget.onSearch(_inputValue);
  }

  handleSubmit(String input) {
    widget.onSearch(input);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        children: [
          SizedBox(width: 8.w),
          Icon(QmIcons.search, size: 24.w, color: const Color(0xFF666666)),
          Expanded(
            child: TextField(
              cursorHeight: 18.w,
              focusNode: _focusNode,
              controller: _controller,
              onSubmitted: handleSubmit,
              textAlign: widget.textAlign,
              onChanged: handleInputChange,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              cursorColor: Theme.of(context).primaryColor,
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF333333)),
              decoration: InputDecoration(
                hintMaxLines: 1,
                isCollapsed: true,
                border: InputBorder.none,
                hintText: widget.hintText,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                hintStyle: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF999999)),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _hasFocus && _inputValue.isNotEmpty ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: GestureDetector(
              onTap: handleClear,
              child: Icon(QmIcons.closeRound, size: 24.sp, color: const Color(0xFF999999)),
            ),
          ),
          GestureDetector(
            onTap: handleSearch,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 5.w, 12.w, 5.w),
              child: Text(
                '搜索',
                style: TextStyle(color: const Color(0xFF3AC786), fontSize: 14.sp, height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
