import 'package:flutter/material.dart';

class MarkerIcon extends StatelessWidget {
  const MarkerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/map_location.png', fit: BoxFit.cover);
  }
}
