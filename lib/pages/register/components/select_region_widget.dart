import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/models/main.dart';
import 'package:qm_agricultural_machinery_services/utils/loading.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/api/main.dart' as api;
import 'package:qm_agricultural_machinery_services/utils/bottom_sheet.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';
import 'package:qm_agricultural_machinery_services/components/cascader/cascader.dart';

class SelectRegionWidget extends StatefulWidget {
  final String label;
  final String hintText;
  final List<SelectedTreeNode> value;
  final void Function(List<SelectedTreeNode> input) onChanged;

  const SelectRegionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<SelectRegionWidget> createState() => _SelectRegionWidgetState();
}

class _SelectRegionWidgetState extends State<SelectRegionWidget> {
  void handleOpenModal() async {
    /// 隐藏软键盘
    FocusScope.of(context).unfocus();
    final mainModel = Get.find<MainModel>();

    if (mainModel.regionSourceTree.value.isEmpty) {
      final closeLoading = Loading.show(message: '数据加载中');
      mainModel.setRegionSourceTree(await getRegionTreeList());
      closeLoading();
    }

    QmBottomSheet.show(
      builder: (BuildContext context, VoidCallback onClose) {
        return Obx(() {
          return CasCader(
            value: widget.value,
            hintText: '请选择所在地区',
            onConfirm: (List<SelectedTreeNode> input) {
              onClose();
              widget.onChanged(input);
            },
            sourceList: mainModel.regionSourceTree.value,
          );
        });
      },
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.w,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: TextStyle(height: 1, fontSize: 14.sp, color: const Color(0xFF4A4A4A)),
          ),
          GestureDetector(
            onTap: handleOpenModal,
            child: Container(
              height: 39.w,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFCCCCCC))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child:
                        widget.value.isNotEmpty
                            ? Text(
                              widget.value.last.fullName ?? '',
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                color: const Color(0xFF333333),
                              ),
                            )
                            : Text(
                              widget.hintText,
                              style: TextStyle(
                                height: 1,
                                fontSize: 14.sp,
                                color: const Color(0xFF999999),
                              ),
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(size: 24.sp, QmIcons.forward, color: const Color(0xFF333333)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
