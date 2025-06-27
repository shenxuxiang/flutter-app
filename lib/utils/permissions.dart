import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> requestLocation() async {
    return await Permission.location.request().isGranted;
  }

  static Future<bool> requestLocationAlways() async {
    /// 需要在 AndroidManifest.xml 中添加 ACCESS_BACKGROUND_LOCATION 权限
    /// 始终允许
    return await Permission.locationAlways.request().isGranted;
  }

  /// 安装 apk
  static Future<bool> requestInstallPackage() async {
    return await Permission.requestInstallPackages.request().isGranted;
  }

  /// 调用相机
  static Future<bool> requestCamera() async {
    return await Permission.camera.request().isGranted;
  }

  /// 调用通知权限
  static Future<bool> requestNotification() async {
    return await Permission.notification.request().isGranted;
  }

  /// 存储文件到目录的权限
  // static Future<bool> requestStorage() async {
  //   return await Permission.photos.request().isGranted ||
  //       await Permission.storage.request().isGranted;
  // }
}
