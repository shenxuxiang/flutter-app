/// 渲染展示列表节点
part of 'cascader.dart';

class _RenderDisplayNode extends StatelessWidget {
  final String label;
  final bool selected;
  final Map<String, dynamic> value;
  final void Function(Map<String, dynamic> value) onTap;

  const _RenderDisplayNode({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColorLight = Theme.of(context).primaryColorLight;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        alignment: Alignment.centerLeft,
        shape: const RoundedRectangleBorder(),
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.only(left: 10),
        maximumSize: Size(double.infinity, 50.w),
        minimumSize: Size(double.infinity, 50.w),
        backgroundColor: selected ? primaryColorLight : const Color(0xFFF9F9F9),
      ),
      onPressed: () => onTap(value),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16.sp, color: const Color(0xFF333333)),
      ),
    );
  }
}
