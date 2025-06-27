import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef PersistentHeaderDelegateBuilder =
    Widget Function(BuildContext context, double shrinkOffset, bool overlapsConten);

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double maxExtent;
  @override
  final double minExtent;

  final PersistentHeaderDelegateBuilder builder;

  PersistentHeaderDelegate({required this.maxExtent, this.minExtent = 0, required Widget child})
    : builder = ((a, b, c) => child);

  PersistentHeaderDelegate.fixedExtent({required double height, required Widget child})
    : maxExtent = height,
      minExtent = height,
      builder = ((a, b, c) => child);

  PersistentHeaderDelegate.builder({
    this.minExtent = 0,
    required this.builder,
    required this.maxExtent,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: builder(context, shrinkOffset, overlapsContent));
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
  }
}
