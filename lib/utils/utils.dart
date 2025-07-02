import 'dart:io';
import 'dart:async';
import 'toast.dart';
import 'dart:convert';
import 'storage.dart';
import 'platform_info.dart';
import 'dart:math' show Random;
import 'load_env.dart' show getEnv;
import 'gnss_location_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart' show DefaultAssetBundle, debugPrint;
import 'package:qm_agricultural_machinery_services/common/global_vars.dart';

/// 生成唯一字符串
String generateUniqueString() {
  final random = Random().nextInt(100000);
  final timeStamp = DateTime.now().microsecondsSinceEpoch;

  return '$timeStamp-$random';
}

Future<void> callPhone(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw '无法拨打电话';
  }
}

String getNetworkAssetURL(String input) {
  return '${getEnv('FILE_BASE_URL')}$input';
}

/// 打印日志
void printLog(dynamic message) {
  if (kDebugMode) debugPrint(message is String ? message : '$message');
}

int opacity2Alpha(double opacity) => (255 * opacity).round();

/// 节流函数
throttle<T extends Function>(T callback, {delay = const Duration(milliseconds: 200)}) {
  Timer? timer;
  return ([dynamic arguments]) {
    timer ??= Timer(delay, () {
      Function.apply(callback, arguments);
      timer = null;
    });

    return;
  };
}

/// 查找所有的父节点(包含当前节点)
List<dynamic> findParentNodes(List<dynamic> sourceList, String keyName, String key) {
  final stack = List.of(sourceList);
  List<dynamic> result = [];

  while (stack.isNotEmpty) {
    final item = stack.removeAt(0);
    if (item[keyName] == key) {
      result.add(item);
      dynamic parent = item['return'];
      while (parent != null) {
        result.insert(0, parent);
        parent = parent['return'];
      }

      return result;
    }

    final children = item['children'] ?? [];
    int length = children.length;
    while (length-- > 0) {
      final child = children[length];
      child['return'] = item;
      stack.insert(0, child);
    }
  }

  return result;
}

/// 查找树中指定层级的资源
findSourceTree(List<dynamic> tree, dynamic id, String keyName) {
  final stack = List.of(tree);
  while (stack.isNotEmpty) {
    final item = stack.removeAt(0);
    if (item[keyName] == id) return item;

    final children = item['children'] ?? [];
    int len = children.length;
    while (len-- > 0) {
      stack.insert(0, children[len]);
    }
  }
}

/// 获取用户登录凭证
String? getStorageUserToken() {
  return Storage.getItem('User_Token') as String?;
}

/// 设置用户登录凭证
Future<bool> setStorageUserToken(String? token) async {
  return await Storage.setItem('User_Token', token);
}

/// 获取用户当前正在使用的收货地址
// ReceivingAddress? getStorageReceivingAddress() {
//   final address = Storage.getItem('Receiving_Address');
//   return address == null ? null : ReceivingAddress.fromJson(address);
// }

/// 设置用户当前使用的收货地址
// Future<bool> setStorageReceivingAddress(ReceivingAddress? address) async {
//   return await Storage.setItem('Receiving_Address', address?.toJson());
// }

/// 获取用户信息
getStorageUserInfo() {
  return Storage.getItem('User_Info');
}

/// 设置用户信息
Future<bool> setStorageUserInfo(Map<String, dynamic>? useInfo) async {
  return Storage.setItem('User_Info', useInfo);
}

/// 压缩图像
Future<File> compressImage(String filePath, {int quality = 95, int rotate = 0}) async {
  final dir = await getTemporaryDirectory();
  final tempPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpeg';
  final file = await FlutterImageCompress.compressAndGetFile(
    filePath,
    tempPath,
    rotate: rotate,
    quality: quality,
  );

  return File(file!.path);
}

/// 获取用户当前位置
Future<LatLng?> getUserLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show('定位服务不可用');
      return null;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      Toast.show('定位不可用，请到系统设置中开启定位功能');
      return null;
    }

    /// 获取当前手机的 AndroidSKD 的版本号
    final platformInfo = await PlatformInfo.getPlatformInfo();

    /// 获取用户的当前位置(经纬度)
    if (platformInfo.level > 30) {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 10),
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } else {
      /// 在小于等于 Android 11 的设备上无法使用 Geolocator 获取用户位置，
      /// 必须使用原生的方式来获取用户的位置
      final point = await GnssLocationManager.getCurrentLocation();
      if (point == null) return null;
      return LatLng(point.latitude, point.longitude);
    }
  } catch (error, stack) {
    printLog(error);
    printLog(stack);
    return null;
  }
}

/// 获取 APP 自带的 region
Future<List<dynamic>> getRegionTreeList() async {
  final asset = 'assets/json/region_data.json';
  final text = await DefaultAssetBundle.of(GlobalVars.context!).loadString(asset);
  return json.decode(text);
}

/// 获取用户轨迹
List<LatLng>? getStorageUserTrack() {
  List<Map<String, dynamic>>? list = Storage.getItem('User_Track');
  if (list == null) return null;

  List<LatLng> points = [];
  for (final item in list) {
    points.add(LatLng.fromJson(item));
  }
  return points;
}

/// 添加用户轨迹
Future<bool> setStorageUserTrack(List<LatLng>? points) async {
  if (points == null) return Storage.setItem('User_Track', null);

  /// [ {'coordinates': [longitude, latitude]}, ... ]
  List<Map<String, dynamic>> list = [];
  for (LatLng point in points) {
    list.add(point.toJson());
  }

  return Storage.setItem('User_Track', list);
}
