import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItemWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final IconData activeIcon;

  const TabItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isActive,
    required this.activeIcon,
  });

  @override
  State<TabItemWidget> createState() => _TabItemWidgetState();
}

class _TabItemWidgetState extends State<TabItemWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.ease);

    if (widget.isActive) _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(TabItemWidget oldWidget) {
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      width: 42.w,
      height: 40.w,
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          final color = ColorTween(
            begin: const Color(0xFF4A4A4A),
            end: primaryColor,
          ).evaluate(_animation);
          final scale = Tween(begin: 1.0, end: 1.1).evaluate(_animation);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                alignment: Alignment.bottomCenter,
                scale: scale,
                child: Icon(
                  size: 22.sp,
                  color: color,
                  widget.isActive ? widget.activeIcon : widget.icon,
                ),
              ),
              Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    height: 1.4,
                    color: color,
                    fontSize: 12.sp,
                    fontWeight: widget.isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
