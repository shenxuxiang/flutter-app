import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RenderText extends StatelessWidget {
  final String text;

  const RenderText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 11.sp, color: Colors.black26, height: 1));
  }
}

class EasyRefreshFooter extends Footer {
  final EasyRefreshController controller;

  const EasyRefreshFooter({
    super.clamping = false,
    required this.controller,
    super.triggerOffset = 40,
    super.position = IndicatorPosition.locator,
  });

  renderContext(IndicatorResult result, IndicatorMode mode) {
    if (result == IndicatorResult.noMore) {
      return const RenderText(text: '没有更多数据了');
    } else {
      if (mode == IndicatorMode.processing) {
        return const _DotAnimation(text: '加载中');
      } else {
        return const RenderText(text: '点击加载更多');
      }
    }
  }

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return GestureDetector(
      onTap: () {
        if ((state.mode == IndicatorMode.done || state.mode == IndicatorMode.inactive) &&
            (state.result == IndicatorResult.success || state.result == IndicatorResult.none)) {
          controller.callLoad(force: true);
        }
      },
      child: Container(
        height: 40.w,
        padding: EdgeInsets.only(bottom: 12.w),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 50, height: 1, color: const Color(0x11000000)),
            const SizedBox(width: 14),
            renderContext(state.result, state.mode),
            const SizedBox(width: 14),
            Container(width: 50, height: 1, color: const Color(0x11000000)),
          ],
        ),
      ),
    );
  }
}

class _DotAnimation extends StatefulWidget {
  final String? text;

  const _DotAnimation({super.key, this.text});

  @override
  State<_DotAnimation> createState() => _DotAnimationState();
}

class _DotAnimationState extends State<_DotAnimation> with TickerProviderStateMixin {
  Timer? _timer2;
  Timer? _timer3;
  final double? size;
  late final Animation<double> _dot1Anim;
  late final Animation<double> _dot2Anim;
  late final Animation<double> _dot3Anim;
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _controller3;

  _DotAnimationState({this.size});

  @override
  void initState() {
    _controller1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _controller2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _controller3 = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _dot1Anim = Tween(begin: 0.8, end: 1.2).animate(_controller1);
    _dot2Anim = Tween(begin: 0.8, end: 1.2).animate(_controller2);
    _dot3Anim = Tween(begin: 0.8, end: 1.2).animate(_controller3);

    _controller1.repeat(reverse: true);
    _timer2 = Timer(const Duration(milliseconds: 200), () => _controller2.repeat(reverse: true));
    _timer3 = Timer(const Duration(milliseconds: 400), () => _controller2.repeat(reverse: true));
    super.initState();
  }

  @override
  void dispose() {
    _timer2?.cancel();
    _timer3?.cancel();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70.w,
      height: 12.w,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.text == null
              ? const SizedBox()
              : Text(
                widget.text!,
                style: TextStyle(fontSize: 11.sp, color: Colors.black26, height: 1),
              ),
          AnimatedBuilder(
            animation: _dot1Anim,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _dot1Anim.value,
                child: Container(
                  width: size ?? 4.w,
                  height: size ?? 4.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _dot2Anim,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _dot2Anim.value,
                child: Container(
                  width: size ?? 4.w,
                  height: size ?? 4.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _dot3Anim,
            builder: (BuildContext context, Widget? child) {
              return Transform.scale(
                scale: _dot3Anim.value,
                child: Container(
                  width: size ?? 4.w,
                  height: size ?? 4.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
