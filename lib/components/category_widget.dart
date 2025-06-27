import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category {
  final String value;
  final String dictName;

  const Category({required this.value, required this.dictName});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(value: json['value'], dictName: json['dictName']);
}

class CategoryWidget extends StatefulWidget {
  final int? index;
  final List<Category> categoryList;
  final void Function(int index)? onChanged;

  const CategoryWidget({super.key, required this.categoryList, this.onChanged, this.index});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int _count = 0;
  int _minIdx = 0;
  int _maxIdx = 99;
  double _boxWidth = 0;
  Category? _selectedItem;
  double _maxScrollExtent = 0;
  double _indicatorOffsetLeft = 0;
  Duration _animationDuration = const Duration(milliseconds: 10);

  final double _itemWidth = 80.w;
  final List<Size> _sizeList = [];
  final double _indicatorWidth = 20.w;
  final List<Offset> _offsetList = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(CategoryWidget oldWidget) {
    if (widget.index != null &&
        widget.index != oldWidget.index &&
        widget.index !=
            (_selectedItem == null ? null : widget.categoryList.indexOf(_selectedItem!))) {
      _selectedItem = widget.categoryList[widget.index!];
      slideAnimation(widget.index!);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _indicatorOffsetLeft = (_itemWidth - _indicatorWidth) / 2;
    super.initState();
  }

  onMounted() {
    /// 计算容器的宽度
    final renderBox = context.findRenderObject() as RenderBox;
    _boxWidth = renderBox.size.width;

    /// 计算阈值下限值，当 index 小于等于该值时，设置滚动偏移量为 0；
    for (int i = 0; i < _offsetList.length; i++) {
      final size = _sizeList[i];
      final offset = _offsetList[i];
      if (offset.dx + size.width / 2 > _boxWidth / 2) {
        _minIdx = i;
        break;
      }
    }

    /// 计算阈值上限值，当 index 大于等于该值时，设置滚动偏移量为 scrollController.position.maxScrollExtent；
    double dist = 0;
    int j = _offsetList.length;
    while (j-- > 0) {
      final width = _sizeList[j].width;
      if (dist + width / 2 <= _boxWidth / 2) {
        _maxIdx = j;
      } else {
        break;
      }
      dist += width;
    }

    /// 滚动最大偏移量
    _maxScrollExtent = _scrollController.position.maxScrollExtent;

    /// 阈值上限值不能小于下限值
    if (_minIdx > _maxIdx) _maxIdx = _minIdx;

    _selectedItem = widget.categoryList[widget.index ?? 0];

    if ((widget.index ?? 0) > 0) {
      slideAnimation(widget.index!, duration: const Duration(milliseconds: 10));
    } else {
      setState(() {});
    }
  }

  onCategoryItemMounted(Offset offset, Size size) {
    _count++;
    _sizeList.add(size);
    _offsetList.add(offset);
    if (_count >= widget.categoryList.length) {
      _count = 0;
      onMounted();
    }
  }

  handleTap(Category category) {
    final index = widget.categoryList.indexOf(category);
    setState(() => _selectedItem = category);
    if (widget.onChanged is Function) widget.onChanged!(index);
    if (_maxIdx == _minIdx) return;

    slideAnimation(index);
  }

  slideAnimation(int index, {Duration duration = const Duration(milliseconds: 300)}) {
    double offsetLeft = 0;
    double indicatorOffsetLeft = 0;

    if (index < _minIdx) {
      offsetLeft = 0;
      indicatorOffsetLeft = _offsetList[index].dx + (_sizeList[index].width - _indicatorWidth) / 2;
    } else if (index >= _maxIdx) {
      offsetLeft = _maxScrollExtent;
      double dist = 0;
      for (int i = index; i < _sizeList.length; i++) {
        dist += _sizeList[i].width;
      }
      indicatorOffsetLeft = _boxWidth - dist + (_itemWidth - _indicatorWidth) / 2;
    } else {
      offsetLeft = _offsetList[index].dx + _sizeList[index].width / 2 - _boxWidth / 2;
      indicatorOffsetLeft = (_boxWidth - 20.w) / 2;
    }

    setState(() {
      _animationDuration = duration;
      _indicatorOffsetLeft = indicatorOffsetLeft;
    });
    _scrollController.position.animateTo(offsetLeft, curve: Curves.ease, duration: duration);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 36.w,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    mainAxisAlignment:
                        _minIdx == _maxIdx
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                    children: [
                      for (final item in widget.categoryList)
                        _CategoryItem(
                          value: item,
                          onTap: handleTap,
                          width: _itemWidth,
                          selected: _selectedItem == item,
                          onMounted: onCategoryItemMounted,
                        ),
                    ],
                  ),
                ),
              ),

              /// 指针指示器
              Positioned(
                bottom: 2.w,
                left: 0,
                child: TweenAnimationBuilder(
                  curve: Curves.ease,
                  duration: _animationDuration,
                  tween: Tween(end: _indicatorOffsetLeft),
                  builder: (BuildContext context, double dist, Widget? child) {
                    return Transform.translate(offset: Offset(dist, 0), child: child);
                  },
                  child: Container(
                    height: 2.w,
                    width: _indicatorWidth,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3AC786),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final double? width;
  final bool selected;
  final Category value;
  final void Function(Category value) onTap;
  final void Function(Offset offset, Size size)? onMounted;

  const _CategoryItem({
    super.key,
    this.width,
    this.onMounted,
    required this.value,
    required this.onTap,
    required this.selected,
  });

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox;
      final ancestor = Scrollable.of(context).notificationContext?.findRenderObject() as RenderBox?;
      if (ancestor == null) return;

      final offset = box.localToGlobal(Offset.zero, ancestor: ancestor);
      if (widget.onMounted is Function) widget.onMounted!(offset, box.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.value),
      child: Container(
        width: widget.width,
        color: Colors.transparent,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 11.5.w),
        child: Text(
          widget.value.dictName,
          style: TextStyle(
            height: 1,
            fontSize: 13.sp,
            color: const Color(0xFF333333),
            fontWeight: widget.selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
