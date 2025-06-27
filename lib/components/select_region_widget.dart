import 'form_item.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/sheet_dialog.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/cascader/cascader.dart';

/// 根据当前的 regionCode 向上查找上级 region
Future<List<SelectedTreeNode>> getParentRegions(String regionCode) async {
  final mainModel = Get.find<MainModel>();

  try {
    final List<SelectedTreeNode> regions = [];
    final regionSourceTree = mainModel.regionSourceTree;
    if (regionSourceTree.value.isEmpty) mainModel.setRegionSourceTree(await getRegionTreeList());
    final nodes = findParentNodes(regionSourceTree.value, 'value', regionCode);

    for (final node in nodes) {
      regions.add(
        SelectedTreeNode(
          value: node['value'],
          label: node['label'],
          children: node['children'],
          fullName: node['fullName'],
        ),
      );
    }

    return regions;
  } catch (error, stack) {
    printLog(error);
    printLog(stack);
    return [];
  }
}

class SelectRegionWidget extends StatefulWidget {
  final String label;
  final bool disabled;
  final bool bordered;
  final Widget? prefix;
  final String hintText;
  final List<SelectedTreeNode> value;
  final void Function(List<SelectedTreeNode> input) onChanged;

  const SelectRegionWidget({
    super.key,
    this.prefix,
    this.hintText = '',
    required this.label,
    required this.value,
    this.bordered = true,
    this.disabled = false,
    required this.onChanged,
  });

  @override
  State<SelectRegionWidget> createState() => _SelectRegionWidgetState();
}

class _SelectRegionWidgetState extends State<SelectRegionWidget> {
  void handleOpenModal() async {
    if (widget.disabled) return;
    FocusScope.of(context).unfocus();

    final mainModel = Get.find<MainModel>();

    if (mainModel.regionSourceTree.value.isEmpty) {
      final closeLoading = Loading.show(message: '数据加载中');
      final regions = await getRegionTreeList();
      mainModel.setRegionSourceTree(regions);
      closeLoading();
    }

    if (!context.mounted) return;

    final result = await showSheetDialog(
      radius: 12,
      height: 500.w,
      transitionDuration: const Duration(milliseconds: 250),
      builder: (BuildContext context) {
        return CasCader(
          hintText: '请选择所在地区',
          value: List.of(widget.value),
          sourceList: mainModel.regionSourceTree.value,
          onConfirm: (List<SelectedTreeNode> input) => Navigator.of(context).pop(input),
        );
      },
    );

    if (result != null) {
      await Future.delayed(const Duration(milliseconds: 250));
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      height: 48.5.w,
      label: widget.label,
      prefix: widget.prefix,
      bordered: widget.bordered,
      onTap: () => handleOpenModal(),
      suffix:
          widget.disabled
              ? null
              : Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF333333)),
      child: Text(
        maxLines: 1,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        widget.value.isEmpty ? widget.hintText : widget.value.last.fullName!,
        style: TextStyle(
          height: 1.5,
          fontSize: 14.sp,
          color: widget.value.isEmpty ? const Color(0xFF999999) : const Color(0xFF333333),
        ),
      ),
    );
  }
}
