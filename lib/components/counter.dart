import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';

class Counter extends StatefulWidget {
  final int min;
  final int max;
  final int value;
  final void Function(int count)? onChanged;

  const Counter({super.key, this.min = 0, this.onChanged, this.max = 9999, required this.value});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  final _focusNode = FocusNode();
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: '${widget.value}');

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(Counter oldWidget) {
    if ('${widget.value}' != _controller.text) _controller.text = '${widget.value}';
    super.didUpdateWidget(oldWidget);
  }

  handleInputChange(String value) {
    value = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (value.isEmpty) value = '0';
    int num = int.parse(value.replaceAll(RegExp(r'[^0-9]'), ''));

    if (num < widget.min) {
      num = widget.min;
    } else if (num > widget.max) {
      num = widget.max;
    }
    _controller.text = '$num';
    if (widget.onChanged is Function) widget.onChanged!(num);
  }

  handleMinus() {
    int count = int.parse(_controller.text);

    if (count <= widget.min) {
      count = widget.min;
    } else if (count > widget.max) {
      count = widget.max;
    } else {
      count--;
    }
    _controller.text = '$count';
    widget.onChanged?.call(count);
  }

  handlePlus() {
    int count = int.parse(_controller.text);

    if (count >= widget.max) {
      count = widget.max;
    } else if (count < widget.min) {
      count = widget.min;
    } else {
      count++;
    }
    _controller.text = '$count';
    widget.onChanged?.call(count);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105.w,
      height: 28.w,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCCCCCC), width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: handleMinus,
            child: Container(
              width: 27.w,
              height: 26.w,
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFFCCCCCC), width: 0.5)),
              ),
              child: Icon(QmIcons.minus, color: const Color(0xFFCCCCCC), size: 24.sp),
            ),
          ),
          Expanded(
            child: TextField(
              cursorHeight: 16.sp,
              focusNode: _focusNode,
              controller: _controller,
              onChanged: handleInputChange,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B4B4B), height: 1),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
              ),
            ),
          ),
          GestureDetector(
            onTap: handlePlus,
            child: Container(
              width: 27.w,
              height: 26.w,
              decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0xFFCCCCCC), width: 0.5)),
              ),
              child: Icon(QmIcons.plus, color: const Color(0xFFCCCCCC), size: 24.sp),
            ),
          ),
        ],
      ),
    );
  }
}
