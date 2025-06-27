import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';

class DropdownMenuWidget extends StatefulWidget {
  final Widget child;
  final double maxWidth;
  final double maxHeight;

  /// 每个菜单项的高度不能小于 48
  final double menuItemHeight;
  final ListItemOption? value;
  final List<ListItemOption> dataSource;
  final void Function(bool opened)? onOpenChanged;
  final void Function(ListItemOption value) onChanged;

  const DropdownMenuWidget({
    super.key,
    this.value,
    this.onOpenChanged,
    required this.child,
    this.maxWidth = 260,
    this.maxHeight = 300,
    required this.onChanged,
    this.menuItemHeight = 48,
    required this.dataSource,
  });

  @override
  State<DropdownMenuWidget> createState() => _DropdownMenuWidgetState();
}

class _DropdownMenuWidgetState extends State<DropdownMenuWidget> {
  ListItemOption? _selectedValue;

  @override
  void didUpdateWidget(DropdownMenuWidget oldWidget) {
    if (oldWidget.value != widget.value && widget.value != _selectedValue) {
      _selectedValue = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _selectedValue = widget.value;
    super.initState();
  }

  /// 打开模态框
  handleOpenModal() async {
    if (widget.onOpenChanged is Function) widget.onOpenChanged!(true);
    final List<PopupMenuEntry<ListItemOption>> items = [];

    for (int i = 0; i < widget.dataSource.length; i++) {
      final menu = widget.dataSource[i];

      items.add(
        PopupMenuItem(
          value: menu,
          enabled: menu.enabled,
          onTap: () {
            setState(() {
              _selectedValue = menu;
              widget.onChanged(menu);
            });
          },
          padding: const EdgeInsets.all(0),
          child: Container(
            width: double.infinity,
            height: widget.menuItemHeight,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
            color:
                _selectedValue?.value == menu.value
                    ? Theme.of(context).primaryColor
                    : i % 2 == 0
                    ? const Color(0xFFF0F0F0)
                    : Colors.white,
            child: Text(
              menu.label,
              style: TextStyle(
                fontSize: 14.sp,
                color: _selectedValue?.value == menu.value ? Colors.white : const Color(0xFF666666),
              ),
            ),
          ),
        ),
      );
    }

    final box = context.findRenderObject() as RenderBox;
    final ancestor = Navigator.of(context).overlay?.context.findRenderObject() as RenderBox;

    final offset = box.localToGlobal(Offset.zero, ancestor: ancestor);

    RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(offset.dx, offset.dy + box.size.height + 2, box.size.width, box.size.height),
      Offset.zero & ancestor.size,
    );

    double dropdownHeight = math.min(
      widget.maxHeight,
      widget.dataSource.length * widget.menuItemHeight,
    );

    if (offset.dy + box.size.height + dropdownHeight + 20 > ancestor.size.height) {
      position = RelativeRect.fromLTRB(
        offset.dx,
        offset.dy - 10 - dropdownHeight,
        ancestor.size.width,
        offset.dy - 10,
      );
    }

    await showMenu(
      elevation: 3,
      items: items,
      context: context,
      position: position,
      color: Colors.white,
      initialValue: widget.value,
      clipBehavior: Clip.hardEdge,
      menuPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      constraints: BoxConstraints(
        minWidth: 130.w,
        maxHeight: widget.maxHeight,
        maxWidth: widget.maxWidth,
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeIn,
        reverseCurve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 150),
      ),
    );

    if (widget.onOpenChanged is Function) widget.onOpenChanged!(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleOpenModal,
      child: Container(color: Colors.transparent, child: IgnorePointer(child: widget.child)),
    );
  }
}
