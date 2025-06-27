import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qm_agricultural_machinery_services/utils/utils.dart';

/// 订阅的导航回退事件
const navBackEvent = "measure_land_nav_back";

/// 状态
enum PlayStatus { none, pause, play }

/// 开始按钮
const startIcon = 'assets/images/measure_land/start.png';

/// 暂停按钮
const pauseIcon = 'assets/images/measure_land/pause.png';

/// 创建 Marker
factoryMarker(LatLng point) {
  return Marker(
    point: point,
    width: 26,
    height: 26,
    child: Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        border: Border.all(width: 4, color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withAlpha(opacity2Alpha(0.5)),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.blueAccent.withAlpha(opacity2Alpha(0.5)),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
    ),
  );
}
