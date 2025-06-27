/// 渲染选中项节点
part of 'cascader.dart';

class _RenderSelectedNode extends StatelessWidget {
  final SelectedTreeNode value;
  final void Function(SelectedTreeNode value) onPressed;

  const _RenderSelectedNode({super.key, required this.value, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.w,
      child: ElevatedButton.icon(
        onPressed: () => onPressed(value),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.close, color: Colors.white),
        label: Text(
          value.label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 14.sp, height: 1),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(0, 32.w),
          maximumSize: Size(double.infinity, 32.w),
          backgroundColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
      ),
    );
  }
}
