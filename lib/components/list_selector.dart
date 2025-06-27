import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/sheet_dialog.dart';
import 'package:qm_agricultural_machinery_services/components/tapped_box.dart';
import 'package:qm_agricultural_machinery_services/entity/list_item_option.dart';

typedef ListSelectorBuilder = Widget Function(BuildContext context);

class ListSelector extends StatefulWidget {
  final ListItemOption? value;
  final ListSelectorBuilder builder;
  final List<ListItemOption> options;
  final void Function(bool open)? onOpenChanged;
  final void Function(ListItemOption value)? onChanged;

  const ListSelector({
    super.key,
    this.value,
    this.onChanged,
    this.onOpenChanged,
    required this.builder,
    required this.options,
  });

  @override
  State<ListSelector> createState() => _ListSelectorState();
}

class _ListSelectorState extends State<ListSelector> {
  FixedExtentScrollController? scrollController;
  ListItemOption? _selectedItem;

  @override
  void initState() {
    super.initState();

    _selectedItem = widget.value;
  }

  @override
  void didUpdateWidget(ListSelector oldWidget) {
    if (oldWidget.value?.value != widget.value?.value) {
      _selectedItem = widget.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  handleOpenDialog(BuildContext context) async {
    widget.onOpenChanged?.call(true);

    /// 关闭弹出的软键盘
    FocusScope.of(context).unfocus();

    /// 初始化选择器的滚动位置
    scrollController = FixedExtentScrollController(
      initialItem:
          _selectedItem == null
              ? 0
              : widget.options.indexWhere((item) => item.value == _selectedItem!.value),
    );

    /// 选中项
    int? selectedIndex;

    void handleCancel() {
      Navigator.of(context).pop();
    }

    void handleOk() {
      Navigator.of(context).pop(selectedIndex);
    }

    final duration = const Duration(milliseconds: 250);
    final result = await showSheetDialog(
      height: 360.w,
      context: context,
      transitionDuration: duration,
      builder: (BuildContext context) {
        final primaryColor = Theme.of(context).primaryColor;
        return Column(
          children: [
            Container(
              width: 360.w,
              height: 48.w,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TappedBox(
                    onTap: handleCancel,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    child: Text(
                      '取消',
                      style: TextStyle(fontSize: 16.sp, height: 1, color: const Color(0xFF999999)),
                    ),
                  ),
                  TappedBox(
                    onTap: handleOk,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w),
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 16.sp, height: 1, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 0.5, thickness: 0.5, color: Color(0xFFE0E0E0)),
            Expanded(
              child: CupertinoPicker.builder(
                itemExtent: 50.w,
                childCount: widget.options.length,
                scrollController: scrollController,
                onSelectedItemChanged: (int index) => selectedIndex = index,
                itemBuilder: (BuildContext context, int index) {
                  final label = widget.options[index].label;
                  return Container(
                    height: 50.w,
                    width: 360.w,
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16.sp, height: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
    widget.onOpenChanged?.call(false);
    if (result != null) {
      await Future.delayed(duration);
      widget.onChanged?.call(widget.options[result]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleOpenDialog(context),
      child: AbsorbPointer(child: widget.builder(context)),
    );
  }
}
