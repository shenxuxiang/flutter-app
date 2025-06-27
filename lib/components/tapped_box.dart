import 'package:flutter/material.dart';

class TappedBox extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const TappedBox({super.key, this.padding, this.margin, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(color: Colors.transparent, padding: padding, margin: margin, child: child),
    );
  }
}
