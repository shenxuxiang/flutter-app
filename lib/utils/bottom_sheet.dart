import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

typedef QmBottomSheetBuilder = Widget Function(BuildContext context, QmBottomSheetClose onClose);
typedef QmBottomSheetClose = Future<void> Function();

class QmBottomSheet {
  static show({
    radius = 16.0,
    double? height,
    BuildContext? context,
    barrierDismissible = true,
    padding = const EdgeInsets.all(12),
    required QmBottomSheetBuilder builder,
  }) {
    final ctx = context ?? GlobalVars.context!;
    late _BottomSheetDialogState bottomSheetDialogState;
    showDialog(
      context: ctx,
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, _) {
            if (!canPop) bottomSheetDialogState.closeSheetModal();
          },
          child: _BottomSheetDialog(
            radius: radius,
            height: height,
            builder: builder,
            padding: padding,
            onClosed: () {
              Navigator.of(context).pop();
            },
            barrierDismissible: barrierDismissible,
            onMounted: (instance) => bottomSheetDialogState = instance,
          ),
        );
      },
    );
  }

  static showSimpleSheet({required QmBottomSheetBuilder builder, BuildContext? context}) {
    final ctx = GlobalVars.context!;

    void closeBottomSheet() {
      Navigator.of(ctx).pop();
    }

    showDialog(
      context: ctx,
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        _BottomSimpleSheetDialog bottomSimpleSheetDialog = _BottomSimpleSheetDialog(
          onClose: closeBottomSheet,
          builder: builder,
        );
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, _) {
            if (!canPop) bottomSimpleSheetDialog.handleClose();
          },
          child: bottomSimpleSheetDialog,
        );
      },
    );
  }
}

class _BottomSheetDialog extends StatefulWidget {
  final double radius;
  final double? height;
  final EdgeInsets padding;
  final bool barrierDismissible;
  final void Function() onClosed;
  final QmBottomSheetBuilder builder;
  final void Function(_BottomSheetDialogState instance) onMounted;

  const _BottomSheetDialog({
    super.key,
    this.height,
    this.radius = 10,
    required this.builder,
    required this.padding,
    required this.onClosed,
    required this.onMounted,
    this.barrierDismissible = true,
  });

  @override
  State<_BottomSheetDialog> createState() => _BottomSheetDialogState();
}

class _BottomSheetDialogState extends State<_BottomSheetDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    widget.onMounted(this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.ease);
    _animationController.forward();
    super.initState();
  }

  Future<void> closeSheetModal() async {
    _animationController.reverseDuration = const Duration(milliseconds: 200);
    await _animationController.reverse();
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.barrierDismissible) closeSheetModal();
            },
            child: FadeTransition(opacity: _animation, child: Container(color: Colors.black54)),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            width: 360.w,
            height: widget.height ?? size.height * 0.7,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return FractionalTranslation(
                  translation: Tween(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                  ).evaluate(_animation),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.radius),
                        topRight: Radius.circular(widget.radius),
                      ),
                    ),
                    child: Opacity(
                      opacity: Tween<double>(begin: 0, end: 1).evaluate(_animation),
                      child: child,
                    ),
                  ),
                );
              },
              child: widget.builder(context, closeSheetModal),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSimpleSheetDialog extends StatelessWidget {
  final VoidCallback onClose;
  final QmBottomSheetBuilder builder;
  final _show = Rx<bool>(false);

  _BottomSimpleSheetDialog({super.key, required this.onClose, required this.builder});

  @override
  StatelessElement createElement() {
    Future.delayed(const Duration(milliseconds: 20), () => _show.value = true);
    return super.createElement();
  }

  Future<void> handleClose() async {
    _show.value = false;
    await Future.delayed(const Duration(milliseconds: 200));
    onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          GestureDetector(
            onTap: handleClose,
            child: Obx(
              () => AnimatedOpacity(
                curve: Curves.ease,
                opacity: _show.value ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000).withAlpha(opacity2Alpha(0.3)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Obx(
              () => AnimatedSlide(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                offset: _show.value ? const Offset(0, 0) : const Offset(0, 1),
                child: builder(context, handleClose),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
