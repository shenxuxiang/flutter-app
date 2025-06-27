import 'package:flutter/material.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

typedef DrawerBuilder = Widget Function(BuildContext context, void Function() close);

class QmDrawer {
  static show({BuildContext? context, required DrawerBuilder builder, double? width}) {
    _DrawerWidgetState? drawerInstance;
    final ctx = context ?? GlobalVars.context!;
    final size = MediaQuery.sizeOf(ctx);

    showDialog(
      context: ctx,
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        /// PopScope.canPop = false 只能阻止用户点击物理返回键时关闭 showDialog
        /// PopScope Widget 无法阻止通过代码的形式关闭 showDialog
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, _) async {
            /// 该方法可以用来监听 Navigator.pop 行为，第一个参数表示 pop() 是否可以返回。
            /// 当 canPop 为 true 时，说明弹框正常关闭了。
            /// 当 canPop 为 false 时，将会阻止默认行为关闭showDialog。
            /// 此时通过代码调用 _DrawerWidgetState.handleClose() 来主动关闭。
            /// 这样关闭的过程就会有动画的过渡效果，默认关闭行为太生硬。
            if (!canPop) drawerInstance?.handleClose();
          },
          child: _DrawerWidget(
            onClosed: () {
              if (context.mounted) Navigator.of(context).pop();
            },
            onMounted: (_DrawerWidgetState instance) {
              drawerInstance = instance;
            },
            builder: builder,
            width: width ?? size.width * 0.75,
          ),
        );
      },
    );
  }
}

class _DrawerWidget extends StatefulWidget {
  final double width;
  final VoidCallback onClosed;
  final DrawerBuilder builder;
  final Function(_DrawerWidgetState instance) onMounted;

  const _DrawerWidget({
    super.key,
    required this.width,
    required this.builder,
    required this.onClosed,
    required this.onMounted,
  });

  @override
  State<_DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<_DrawerWidget> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  late final Animation<Offset> animation2;

  @override
  void initState() {
    widget.onMounted(this);

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    animation2 = Tween(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).chain(CurveTween(curve: Curves.ease)).animate(controller);

    controller.forward();
    super.initState();
  }

  handleClose() async {
    controller.reverseDuration = const Duration(milliseconds: 150);
    await controller.reverse();
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onTap: handleClose,
            child: FadeTransition(opacity: animation, child: Container(color: Colors.black26)),
          ),
          Positioned(
            top: viewPadding.top + kToolbarHeight,
            right: 0,
            child: SlideTransition(
              position: animation2,
              child: Container(
                width: widget.width,
                color: Colors.white,
                height: size.height - viewPadding.top - kToolbarHeight,
                child: widget.builder(context, handleClose),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
