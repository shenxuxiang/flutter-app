import 'dart:async';
import 'package:qm_agricultural_machinery_services/common/app_location_service.dart';
import 'package:qm_agricultural_machinery_services/utils/toast.dart';

import 'constant.dart';
import 'control_panel1.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';
import 'package:qm_agricultural_machinery_services/utils/event_bus.dart';
import 'package:qm_agricultural_machinery_services/common/qm_icons.dart';
import 'package:qm_agricultural_machinery_services/utils/permissions.dart';
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';
import 'package:qm_agricultural_machinery_services/components/skeleton.dart';
import 'package:qm_agricultural_machinery_services/utils/platform_info.dart';
import 'package:qm_agricultural_machinery_services/utils/gnss_location_manager.dart';

class Panel1 extends StatefulWidget {
  const Panel1({super.key});

  @override
  State<Panel1> createState() => _Panel1State();
}

class _Panel1State extends State<Panel1> {
  final double mapMaxZoom = 18;
  final double mapInitZoom = 16.6;
  final List<Marker> markers = [];
  final mapController = MapController();
  final List<Polyline> polyLines = [
    Polyline(points: [], strokeWidth: 3, color: const Color(0xFFFF9900)),
  ];
  final interactionOptions = const InteractionOptions(
    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  );

  /// 轨迹长度
  double trackLength = 0;

  /// 用户的初始位置
  LatLng? initPosition;

  /// 用户位置监听流
  StreamSubscription? subscriptionOfUserLocationUpdate;

  @override
  void initState() {
    /// 添加 Navigator.pop() 事件监听
    eventBus.add(navBackEvent, handleListenNavBack);

    /// 获取用户的当前位置
    getUserLocation().then((LatLng? point) async {
      if (point == null) {
        Toast.warning('请在设置中打开定位权限', duration: const Duration(seconds: 1));
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else {
        setState(() {
          markers.clear();
          initPosition = point;
          markers.add(factoryMarker(point));
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    eventBus.off(navBackEvent);
    subscriptionOfUserLocationUpdate?.cancel();
    subscriptionOfUserLocationUpdate = null;
    super.dispose();
  }

  /// 对返回按钮进行监听
  handleListenNavBack([dynamic _]) {
    subscriptionOfUserLocationUpdate?.cancel();
    subscriptionOfUserLocationUpdate = null;
  }

  handle() async {}

  /// 矫正地图定位
  handleCorrectMapLocation() {
    handle();
  }

  /// 持续更新用户轨迹
  handleUpdateUserTrack(LatLng point) {
    final points = polyLines.first.points;
    double distance = 0;

    if (points.isNotEmpty) {
      final lastPoint = points.last;
      distance = Geolocator.distanceBetween(
        lastPoint.latitude,
        lastPoint.longitude,
        point.latitude,
        point.longitude,
      );
    }

    setState(() {
      markers.clear();
      points.add(point);
      trackLength += distance;
      markers.add(factoryMarker(point));
    });
    mapController.move(point, mapInitZoom);
  }

  /// 开始
  Future<void> handleStart() async {
    await AppLocationService.startTracking(handleUpdateUserTrack);
  }

  /// 暂停
  handlePause() {
    AppLocationService.pauseTracking();
  }

  /// 继续
  Future<void> handleContinue() async {
    await handleStart();
  }

  /// 退出测量
  Future<void> handleExitMeasure() async {
    subscriptionOfUserLocationUpdate?.cancel();
    subscriptionOfUserLocationUpdate = null;

    setState(() {
      polyLines.first.points.clear();
      trackLength = 0;
    });
  }

  /// 保存测量数据
  Future<void> handleSave() async {
    subscriptionOfUserLocationUpdate?.cancel();
    subscriptionOfUserLocationUpdate = null;

    setState(() {
      trackLength = 0;
      polyLines.first.points.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (initPosition == null) return const SkeletonScreen();
    return Stack(
      children: [
        Positioned.fill(
          bottom: 100.w,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              maxZoom: mapMaxZoom,
              crs: const Epsg3857(),
              initialZoom: mapInitZoom,
              initialCenter: initPosition!,
              interactionOptions: interactionOptions,
            ),
            children: [
              TileLayer(
                urlTemplate: GlobalVars.tiandituImg,
                subdomains: GlobalVars.tiandituCiaSubdomains,
                userAgentPackageName: 'com.example.qm_agricultural_machinery_services',
              ),
              TileLayer(
                urlTemplate: GlobalVars.tiandituCia,
                subdomains: GlobalVars.tiandituCiaSubdomains,
                userAgentPackageName: 'com.example.qm_agricultural_machinery_services',
              ),
              polyLines.first.points.isEmpty
                  ? const SizedBox()
                  : PolylineLayer(polylines: polyLines),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
        Positioned(
          right: 12.w,
          bottom: 156.w,
          child: GestureDetector(
            onTap: handleCorrectMapLocation,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(opacity2Alpha(0.6)),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Icon(QmIcons.position, color: Colors.white),
            ),
          ),
        ),
        ControlPanel1(
          onSave: handleSave,
          onStart: handleStart,
          onPause: handlePause,
          onContinue: handleContinue,
          onExitMeasure: handleExitMeasure,
          perimeter: trackLength,
        ),
      ],
    );
  }
}
