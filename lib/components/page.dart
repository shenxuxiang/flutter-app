import 'package:flutter/material.dart';

class PageWidget extends StatelessWidget {
  final Widget child;

  const PageWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
          image: AssetImage('assets/images/home_bg.png'),
        ),
      ),
      child: child,
    );
  }
}
