import 'dart:async';
import 'dart:math' as math;
import '../input_box.dart';
import '../button_widget.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart' as utils;
import 'package:qm_agricultural_machinery_services/components/empty_widget.dart';
import 'package:qm_agricultural_machinery_services/components/sticky_header.dart';
import 'package:qm_agricultural_machinery_services/entity/selected_tree_node.dart';

part 'render_display_node.g.dart';

part 'render_selected_node.g.dart';

part 'render_sticky_positioned_node.g.dart';

/// 根据拼音首字符排序
void sortByFirstLetterOfPinYin(List<dynamic> list, String keyName) {
  list.sort((prev, next) {
    String c1 = PinyinHelper.getFirstWordPinyin(prev[keyName]);
    String c2 = PinyinHelper.getFirstWordPinyin(next[keyName]);
    return c1.compareTo(c2);
  });
}

class CasCader extends StatefulWidget {
  final String labelKey;
  final String valueKey;
  final String hintText;
  final String childrenKey;
  final List<dynamic> sourceList;
  final List<SelectedTreeNode> value;
  final void Function(List<SelectedTreeNode> value) onConfirm;

  const CasCader({
    super.key,
    required this.value,
    this.labelKey = 'label',
    this.valueKey = 'value',
    this.hintText = '请选择',
    required this.onConfirm,
    required this.sourceList,
    this.childrenKey = 'children',
  });

  @override
  State<CasCader> createState() => _CasCaderState();
}

class _CasCaderState extends State<CasCader> {
  /// 定时器
  Timer? _timer;

  /// 搜索条件
  String _searchCondition = '';

  /// 当前展示高亮的首字母
  String _activeFirstLetter = '';

  /// 搜索结果列表
  List<dynamic> _searchResultList = [];

  /// 选中项
  List<SelectedTreeNode> _selectedList = [];

  /// 表示当前是用户点击首字母
  bool _isUserClickFirstLetter = false;

  /// 展示列表
  Map<String, List<dynamic>> _displayList = {};

  late final ScrollController _scrollController;

  /// 收集每个 displayListItem 在滚动容器中的初始偏移量
  final Map<String, double> _displayListItemInitialOffsets = {};

  /// 修改展示列表
  void handleChangeDisplayList(List<dynamic> list) {
    list = List.of(list);

    /// 根据名称的首字母进行升序排列
    sortByFirstLetterOfPinYin(list, widget.labelKey);

    /// 展示列表的数据结构 { 'A': [...], 'B': [...] },
    Map<String, List<dynamic>> maps = {};

    String firstLetter = '';
    for (final item in list) {
      firstLetter = PinyinHelper.getFirstWordPinyin(item[widget.labelKey]).substring(0, 1);
      maps[firstLetter] ??= [];
      maps[firstLetter]!.add(item);
    }

    /// 每次更新展示列表时，都需要重新滚动到顶部为止
    if (_scrollController.positions.isNotEmpty) _scrollController.position.jumpTo(0);

    setState(() {
      _displayList = maps;
      _activeFirstLetter = maps.isNotEmpty ? maps.keys.first : '';
      _displayListItemInitialOffsets.clear();
    });
  }

  /// 删除选中项
  void deleteSelectedEntry(SelectedTreeNode deleteItem) {
    int start = _selectedList.indexOf(deleteItem);
    if (start < 0) return;

    List<SelectedTreeNode> newList = List.of(_selectedList);

    /// 如果 organization.children 为空，则说明该选项是一个叶子节点。
    /// 所以该选项就是最后一个选项，删除该选项不需要更新展示列表（disPlayList）。
    /// 否则，就需要更新展示列表。
    if (_selectedList.length - 1 == start && (deleteItem.children?.isEmpty ?? true)) {
      newList.removeLast();
    } else {
      newList.removeRange(start, newList.length);

      /// 每次修改展示列表时都需要将滚动到顶部，否则粘性定位可能会出现异常。
      // _scrollController.position.jumpTo(0);

      /// 更新展示列表
      /// disPlayList 始终取它的父级的 children。如果 selectedList 为空，则展示内容为初始化时的列表。
      handleChangeDisplayList(newList.isEmpty ? widget.sourceList : newList.last.children!);
    }

    setState(() => _selectedList = newList);
  }

  /// 修改选中项
  handleSelectedItem(Map<String, dynamic> selectedItem) {
    final json = Map.of(selectedItem);
    json['value'] = json[widget.valueKey];
    json['label'] = json[widget.labelKey];
    json['children'] = json[widget.childrenKey];

    // SelectedTreeNode node = SelectedTreeNode(
    //   value: selectedItem[widget.valueKey],
    //   label: selectedItem[widget.labelKey],
    //   children: selectedItem[widget.childrenKey],
    // );

    SelectedTreeNode node = SelectedTreeNode.fromJson(json);

    setState(() {
      if (_selectedList.isEmpty || (_selectedList.last.children?.isNotEmpty ?? false)) {
        _selectedList.add(node);
      } else {
        _selectedList.last = node;
      }
    });

    if (node.children?.isNotEmpty ?? false) handleChangeDisplayList(node.children!);
  }

  /// StickyPositionedItem（粘性定位） 挂载成功的回调
  void handleStickyHeaderItemMounted(String firstLetter, double offset) {
    _displayListItemInitialOffsets.addEntries([MapEntry(firstLetter, offset)]);
  }

  /// 修改搜索条件索出结果，并展示。
  void handleChangeSearchCondition(String value) {
    List<dynamic> resultList = [];
    if (value.isNotEmpty) {
      for (final nodeList in _displayList.values) {
        for (final node in nodeList) {
          if (node[widget.labelKey].contains(value)) {
            resultList.add(node);
          }
        }
      }
    }

    setState(() {
      _searchCondition = value;
      _searchResultList = resultList;
    });
  }

  /// 点击确认按钮
  void handleConfirm() {
    if (_selectedList.isEmpty) {
      Toast.show(widget.hintText);
      return;
    }
    widget.onConfirm(_selectedList);
  }

  /// 用户点击右侧竖排的首字符，展示列表将滚动到对应的位置。
  handleTapFirstLetter(String firstLetter) {
    _timer?.cancel();
    _isUserClickFirstLetter = true;
    setState(() => _activeFirstLetter = firstLetter);
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(
      _displayListItemInitialOffsets[firstLetter]!.clamp(0, maxScrollExtent),
    );

    /// 添加一个定时任务， 100ms 后执行
    _timer = Timer(const Duration(milliseconds: 100), () => _isUserClickFirstLetter = false);
  }

  /// 监听用户的滚动行为
  void handleScroll() {
    /// _isUserClickFirstLetter == true 表示该滚动行为是用户点击了首字符后触发的滚动。
    /// 不应该对此行为进行监听。
    if (_isUserClickFirstLetter) return;
    final pixels = _scrollController.position.pixels;
    String firstLetter = '';
    for (final entry in _displayListItemInitialOffsets.entries) {
      if (pixels >= entry.value) {
        firstLetter = entry.key;
      } else {
        break;
      }
    }

    setState(() => _activeFirstLetter = firstLetter);
  }

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0);
    final onScroll = utils.throttle<VoidCallback>(handleScroll, delay: Duration(milliseconds: 100));
    _scrollController.addListener(onScroll);

    if (widget.value.isNotEmpty) {
      _selectedList = widget.value;

      /// 如果 _selectedList 有且只有一个元素时，该元素上肯定有 children
      if (_selectedList.last.children?.isNotEmpty ?? false) {
        handleChangeDisplayList(_selectedList.last.children!);
      } else {
        handleChangeDisplayList(_selectedList[_selectedList.length - 2].children ?? []);
      }
    } else {
      /// 组件在初始化时，应该初始化展示列表，根据传入的 sourceList 对其按照搜字母进行排序，
      /// 并找出所有的首字母，将其排列在右侧。
      handleChangeDisplayList(widget.sourceList);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(CasCader oldWidget) {
    if (widget.sourceList != oldWidget.sourceList) handleChangeDisplayList(widget.sourceList);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.removeListener(handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final slideBarH = math.max(_displayList.length * 30 + 10, constraints.maxHeight * 0.2).w;
        return Stack(
          children: [
            Container(
              color: const Color(0xFFF9F9F9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  /// 搜索框
                  Container(
                    height: 52.w,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InputBox(
                            allowClear: false,
                            value: _searchCondition,
                            hintText: '请输入您要搜索的内容',
                            textInputAction: TextInputAction.done,
                            onChanged: handleChangeSearchCondition,
                            suffix: Icon(QmIcons.search, size: 24.sp, color: Colors.black38),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ButtonWidget(radius: 6, text: '确定', width: 60.sp, onTap: handleConfirm),
                      ],
                    ),
                  ),

                  /// 展示选中的内容
                  Container(
                    padding: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.w),
                    constraints: const BoxConstraints(minHeight: 40, minWidth: double.infinity),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.w,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children:
                          _selectedList.isEmpty
                              ? [
                                Container(
                                  height: 32.w,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.hintText,
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 15.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ]
                              : [
                                for (final item in _selectedList)
                                  _RenderSelectedNode(value: item, onPressed: deleteSelectedEntry),
                              ],
                    ),
                  ),

                  /// 展示列表
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child:
                          _displayList.isNotEmpty
                              ? Column(
                                children: [
                                  for (final entry in _displayList.entries)
                                    _StickyPositionedItem(
                                      list: entry.value,
                                      firstLetter: entry.key,
                                      labelKey: widget.labelKey,
                                      valueKey: widget.valueKey,
                                      onSelected: handleSelectedItem,
                                      selected:
                                          _selectedList.isNotEmpty ? _selectedList.last.value : '',
                                      onMounted: handleStickyHeaderItemMounted,
                                      key: ValueKey(entry.key + entry.value.toString()),
                                    ),
                                ],
                              )
                              : const SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: EmptyWidget(),
                              ),
                    ),
                  ),
                ],
              ),
            ),

            /// 右侧边缘展示首字母
            Positioned(
              // top: 100.w,
              top: math.max((constraints.maxHeight - slideBarH) / 2, 56.w),
              right: 10.w,
              height: slideBarH,
              child: Container(
                width: 24.w,
                padding: const EdgeInsets.symmetric(vertical: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12.w),
                  boxShadow: [
                    const BoxShadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 5),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (final firstLetter in _displayList.keys)
                      GestureDetector(
                        onTap: () => handleTapFirstLetter(firstLetter),
                        child: Container(
                          width: 18.w,
                          height: 18.w,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                            color:
                                _activeFirstLetter == firstLetter
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                          ),
                          child: Text(
                            firstLetter.toUpperCase(),
                            style: TextStyle(
                              height: 1,
                              fontSize: 12.sp,
                              color:
                                  _activeFirstLetter == firstLetter ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// 展示搜索结果
            _searchCondition.isNotEmpty
                ? Positioned(
                  left: 0,
                  top: 52,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight - 52,
                  child: Container(
                    color: const Color(0xFFF9F9F9),
                    constraints: const BoxConstraints.expand(),
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            _searchResultList.isEmpty
                                ? [
                                  const Padding(padding: EdgeInsets.only(top: 10)),
                                  const Text(
                                    '没有搜索到结果～',
                                    style: TextStyle(
                                      height: 2,
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ]
                                : [
                                  for (final item in _searchResultList)
                                    _RenderDisplayNode(
                                      value: item,
                                      label: item[widget.labelKey],
                                      onTap: (Map<String, dynamic> value) {
                                        handleSelectedItem(value);
                                        setState(() => _searchCondition = '');
                                      },
                                    ),
                                ],
                      ),
                    ),
                  ),
                )
                : const Padding(padding: EdgeInsets.zero),
          ],
        );
      },
    );
  }
}
