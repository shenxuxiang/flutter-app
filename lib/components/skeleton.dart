import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SkeletonScreen extends StatefulWidget {
  const SkeletonScreen({super.key});

  @override
  State<SkeletonScreen> createState() => _SkeletonScreenState();
}

class _SkeletonScreenState extends State<SkeletonScreen> with SingleTickerProviderStateMixin {
  final Color _darkColor = const Color(0x18000000);
  AnimationController? _animationController;
  Animation<double>? _animation;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(milliseconds: 800), () {
      setState(() => _timer = null);
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2600),
      );
      _animation = CurvedAnimation(parent: _animationController!, curve: Curves.ease);
      _animationController?.repeat();
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  /// 返回上一页
  handleGoBack() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return _timer != null
        ? const SizedBox()
        : Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 540,
            child: Stack(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: _darkColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      for (int i = 0; i < 5; i++)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 68,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: _darkColor,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 230,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _darkColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 230,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: _darkColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation!,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(-1.2, 0),
                          end: const Alignment(1.2, 0),
                          colors: [
                            const Color(0x00FFFFFF),
                            const Color(0x88FFFFFF),
                            const Color(0x00FFFFFF),
                            const Color(0x00FFFFFF),
                          ],
                          stops: [
                            _animation!.value - 0.1,
                            _animation!.value,
                            _animation!.value,
                            _animation!.value + 0.1,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
  }
}
