import 'utils.dart' show printLog;
import 'package:flutter/services.dart';

/// 获取 Android SDK 的版本号
class PlatformInfo {
  static const platform = MethodChannel('qm_flutter_android_method_channel');

  static Future<({int level, String version, String appVersion})> getPlatformInfo() async {
    try {
      final info = await platform.invokeMethod('getPlatformInfo');

      return (
        level: info!['apiLevel'] as int,
        version: info!['versionName'] as String,
        appVersion: info['appVersion'] as String,
      );
    } on PlatformException catch (e) {
      printLog("Failed To Get Platform Info: ${e.message}");
      return (level: 0, version: '0', appVersion: '1.0.0');
    }
  }
}
