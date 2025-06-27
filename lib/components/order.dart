import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

enum OrderStatus { none, asc, desc }

Color _color = const Color(0xFFCCCCCC);
Color _activeColor = const Color(0xFF666666);

class OrderWidget extends StatefulWidget {
  final String title;
  final OrderStatus status;
  final void Function(OrderStatus sort) onChanged;

  const OrderWidget({
    super.key,
    required this.title,
    required this.status,
    required this.onChanged,
  });

  @override
  State<OrderWidget> createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> with SingleTickerProviderStateMixin {
  late OrderStatus _status;

  @override
  void didUpdateWidget(OrderWidget oldWidget) {
    if (widget.status != oldWidget.status && widget.status != _status) {
      _status = widget.status;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _status = widget.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.status == OrderStatus.none) {
          _status = OrderStatus.asc;
        } else if (widget.status == OrderStatus.asc) {
          _status = OrderStatus.desc;
        } else {
          _status = OrderStatus.none;
        }
        widget.onChanged(_status);
      },
      child: Container(
        height: 24.w,
        color: Colors.transparent,
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 13.sp, height: 1, color: const Color(0xFF4A4A4A)),
            ),
            CustomPaint(size: Size(16.sp, 16.sp), painter: OrderPaint(order: widget.status)),
          ],
        ),
      ),
    );
  }
}

class OrderPaint extends CustomPainter {
  final OrderStatus order;

  OrderPaint({required this.order}) : super();

  List<Color> computedColor() {
    Color upColor;
    Color downColor;
    if (order == OrderStatus.asc) {
      upColor = _activeColor;
      downColor = _color;
    } else if (order == OrderStatus.desc) {
      upColor = _color;
      downColor = _activeColor;
    } else {
      upColor = _color;
      downColor = _color;
    }
    return [upColor, downColor];
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = const Offset(0, 0) & size;
    Path up =
        Path()
          ..moveTo(rect.width / 2, rect.height / 13 * 1)
          ..lineTo(rect.width / 10 * 2, rect.height / 10 * 4)
          ..lineTo(rect.width / 10 * 8, rect.height / 10 * 4);

    Path down =
        Path()
          ..moveTo(rect.width / 2, rect.height / 13 * 12)
          ..lineTo(rect.width / 10 * 2, rect.height / 10 * 6)
          ..lineTo(rect.width / 10 * 8, rect.height / 10 * 6);

    Color upColor;
    Color downColor;
    [upColor, downColor] = computedColor();

    canvas.drawPath(
      up,
      Paint()
        ..style = PaintingStyle.fill
        ..color = upColor,
    );

    canvas.drawPath(
      down,
      Paint()
        ..style = PaintingStyle.fill
        ..color = downColor,
    );
  }

  @override
  bool shouldRepaint(OrderPaint oldDelegate) {
    if (order != oldDelegate.order) {
      return true;
    } else {
      return false;
    }
  }
}
