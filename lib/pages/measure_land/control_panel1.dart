import 'package:latlong2/latlong.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

import '../../utils/permissions.dart';
import 'constant.dart';
import 'package:get/get.dart';
import 'control_panel_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/alert.dart';
import 'package:qm_agricultural_machinery_services/models/measure_land.dart';
import 'package:qm_agricultural_machinery_services/utils/user_tap_feedback.dart';
import 'package:qm_agricultural_machinery_services/components/button_widget.dart';

class ControlPanel1 extends StatefulWidget {
  final void Function() onPause;
  final Future<void> Function() onSave;
  final Future<void> Function() onStart;
  final Future<void> Function() onContinue;
  final Future<void> Function() onExitMeasure;

  final double perimeter;

  const ControlPanel1({
    super.key,
    required this.onSave,
    required this.onPause,
    required this.onStart,
    required this.onContinue,
    required this.onExitMeasure,
    required this.perimeter,
  });

  @override
  State<ControlPanel1> createState() => _ControlPanel1State();
}

class _ControlPanel1State extends State<ControlPanel1> {
  PlayStatus status = PlayStatus.none;
  final measureLandModel = Get.find<MeasureLandModel>();

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    measureLandModel.canPop.value = true;
    super.dispose();
  }

  /// 触发开始、暂停
  handleTap() {
    UserTapFeedback.selection();
    switch (status) {
      case PlayStatus.none:
        handleStart();
      case PlayStatus.play:
        handlePause();
      case PlayStatus.pause:
        handleContinue();
    }
  }

  /// 开始
  handleStart() async {
    try {
      if (await Permissions.requestLocation() &&
          await Permissions.requestLocationAlways() &&
          await Permissions.requestNotification()) {
        await widget.onStart();
        setState(() {
          status = PlayStatus.play;
        });
        measureLandModel.canPop.value = false;
      }
    } finally {}
  }

  /// 暂停
  handlePause() {
    widget.onPause();
    setState(() {
      status = PlayStatus.pause;
    });
  }

  /// 继续
  handleContinue() async {
    try {
      await widget.onContinue();
      setState(() {
        status = PlayStatus.play;
      });
    } finally {}
  }

  /// 退出测量
  handleExitMeasure() {
    UserTapFeedback.selection();
    Alert.confirm(
      title: '确定要退出测量吗？',
      cancelText: '取消',
      confirmText: '确定',
      onConfirm: () async {
        await widget.onExitMeasure();
        setState(() {
          status = PlayStatus.none;
        });
        measureLandModel.canPop.value = true;
      },
    );
  }

  /// 保存
  handleSave() {
    UserTapFeedback.selection();
    Alert.confirm(
      title: '确定要保存测量数据吗？',
      cancelText: '取消',
      confirmText: '确定',
      onConfirm: () async {
        await widget.onSave();
        setState(() {
          status = PlayStatus.none;
        });
        measureLandModel.canPop.value = true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      height: 155.w,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            width: 360.w,
            height: 155.w,
            child: CustomPaint(
              painter: ControlPanelShape(),
              child: Container(
                height: 88.w,
                padding: EdgeInsets.only(top: 75.w),
                child: Text(
                  status == PlayStatus.none
                      ? '开始'
                      : status == PlayStatus.play
                      ? '暂停'
                      : '继续',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1, fontSize: 13.sp, color: const Color(0xFF666666)),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: handleTap,
            child: Image.asset(
              status == PlayStatus.none || status == PlayStatus.pause ? startIcon : pauseIcon,
              width: 66,
              height: 66,
            ),
          ),
          Positioned(
            top: 0.w,
            width: 360.w,
            height: 155.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 147.w,
                      height: 88.w,
                      child: Column(
                        children: [
                          SizedBox(height: 37.w),
                          Text(
                            widget.perimeter.toStringAsFixed(1),
                            style: TextStyle(
                              height: 1,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 16.w),
                          Text(
                            '估算面积（亩）',
                            style: TextStyle(
                              height: 1,
                              fontSize: 13.sp,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 147.w,
                      height: 88.w,
                      child: Column(
                        children: [
                          SizedBox(height: 37.w),
                          Text(
                            widget.perimeter.toStringAsFixed(1),
                            style: TextStyle(
                              height: 1,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          SizedBox(height: 16.w),
                          Text(
                            '目前周长（米）',
                            style: TextStyle(
                              height: 1,
                              fontSize: 13.sp,
                              color: const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                      ghost: true,
                      width: 106.w,
                      height: 36.w,
                      radius: 18.w,
                      text: '退出测量',
                      type: 'default',
                      onTap: handleExitMeasure,
                      disabled: status == PlayStatus.none,
                    ),
                    SizedBox(width: 22.w),
                    ButtonWidget(
                      width: 106.w,
                      height: 36.w,
                      radius: 18.w,
                      text: '保存结束',
                      onTap: handleSave,
                      disabled: status == PlayStatus.none,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
