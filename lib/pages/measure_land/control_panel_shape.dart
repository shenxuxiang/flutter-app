import 'dart:math';
import 'package:flutter/material.dart';

class ControlPanelShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = const Offset(0, 20) & size;
    final paint =
        Paint()
          ..isAntiAlias = true
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final double radius = 20;
    final path =
        Path()
          ..moveTo(rect.left, rect.bottom)
          ..lineTo(rect.left, rect.top - radius)
          ..arcTo(Rect.fromLTWH(rect.left, rect.top, radius * 2, radius * 2), pi, pi / 2, false)
          ..lineTo(rect.right - radius, rect.top)
          ..arcTo(
            Rect.fromLTWH(rect.right - 2 * radius, rect.top, radius * 2, radius * 2),
            pi / 180 * 270,
            pi / 2,
            false,
          )
          ..lineTo(rect.right, rect.bottom)
          ..close();

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(rect.width / 2, rect.top + 10), 35, paint);

    final path2 =
        Path()
          ..arcTo(
            Rect.fromCenter(
              center: Offset(rect.width / 2 - 46.1, rect.top - 20),
              width: 40,
              height: 40,
            ),
            pi / 180 * 33,
            pi / 180 * 57,
            false,
          )
          ..lineTo(rect.width / 2 - 46.1, rect.top)
          ..lineTo(rect.width / 2, rect.top)
          ..close();
    final path3 =
        Path()
          ..arcTo(
            Rect.fromCenter(
              center: Offset(rect.width / 2 + 46.1, rect.top - 20),
              width: 40,
              height: 40,
            ),
            pi / 180 * 90,
            pi / 180 * 57,
            false,
          )
          ..lineTo(rect.width / 2, rect.top)
          ..close();

    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
