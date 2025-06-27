import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';

class ButtonGroupOption {
  final String value;
  final String label;

  const ButtonGroupOption({required this.value, required this.label});
}

class ButtonGroup extends StatefulWidget {
  final int? index;
  final List<ButtonGroupOption> options;
  final void Function(int key) onChanged;

  const ButtonGroup({super.key, required this.onChanged, required this.options, this.index});

  @override
  State<ButtonGroup> createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> with SingleTickerProviderStateMixin {
  late ButtonGroupOption _selectedValue;

  @override
  void didUpdateWidget(ButtonGroup oldWidget) {
    if (widget.index != null &&
        widget.index != oldWidget.index &&
        widget.index != widget.options.indexOf(_selectedValue)) {
      /// 当 index 变化时，更新被选中项
      setState(() => _selectedValue = widget.options[widget.index!]);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _selectedValue = widget.options[widget.index ?? 0];
    super.initState();
  }

  onChanged(ButtonGroupOption value) {
    if (_selectedValue == value) return;
    UserTapFeedback.selection();

    setState(() => _selectedValue = value);
    widget.onChanged(widget.options.indexOf(value));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(color: primaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        spacing: widget.options.length > 2 ? 1 : 0,
        children: [
          for (final item in widget.options)
            Flexible(
              child: GestureDetector(
                onTap: () => onChanged(item),
                child: AnimatedContainer(
                  width: double.infinity,
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _selectedValue == item ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft:
                          widget.options.first == item ? const Radius.circular(5) : Radius.zero,
                      bottomLeft:
                          widget.options.first == item ? const Radius.circular(5) : Radius.zero,
                      topRight:
                          widget.options.last == item ? const Radius.circular(5) : Radius.zero,
                      bottomRight:
                          widget.options.last == item ? const Radius.circular(5) : Radius.zero,
                    ),
                  ),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      height: 1,
                      fontSize: 14.sp,
                      color: _selectedValue == item ? Colors.white : primaryColor,
                    ),
                    child: Text(item.label, style: const TextStyle(height: 1.2)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
