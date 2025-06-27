import 'package:geolocator/geolocator.dart';

import 'utils.dart' show printLog;
import 'package:flutter/services.dart';

/// 获取 Android SDK 的版本号
class GnssLocationManager {
  static const platform = MethodChannel('qm_flutter_android_method_channel');

  static Future<({double latitude, double longitude})?> getCurrentLocation() async {
    try {
      final data = await platform.invokeMethod('getCurrentLocation');
      return (latitude: data!['latitude'] as double, longitude: data!['longitude'] as double);
    } on PlatformException catch (e) {
      printLog("Failed To Get User Location: ${e.message}");
      return null;
    }
  }

  static Stream<Position> updateLocationStream() {
    const channel = EventChannel("qm_flutter_android_event_channel");

    return channel.receiveBroadcastStream().map((data) => Position.fromMap(data));
  }
}
