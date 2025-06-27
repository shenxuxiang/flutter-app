import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const _notificationId = 8813;
const _notificationChannelId = 'qm_background_service_location_notification_channel';

@pragma('vm:entry-point')
class AppLocationService {
  static StreamSubscription<Position>? _subscriptionOfLocationStream;
  static StreamSubscription<Map<String, dynamic>?>? _subscriptionOfUpdateStream;

  /// 创建一个 service
  static final FlutterBackgroundService service = FlutterBackgroundService();

  /// 通知栏（一个用于显示本地通知的跨平台插件）。
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Android 通知通道。
  static final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    _notificationChannelId,
    '定位通知',
    description: '这是一条关于后台持续定位的通知',
    importance: Importance.high,
  );

  /// 初始化工作
  static Future<void> initialize() async {
    /// 通知初始化
    await notificationsPlugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
    );

    /// 创建通知渠道
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    service.configure(
      iosConfiguration: IosConfiguration(),
      androidConfiguration: AndroidConfiguration(
        autoStart: false,
        isForegroundMode: true,
        onStart: _onStartService,
        initialNotificationContent: '',
        initialNotificationTitle: '后台服务已开启',
        notificationChannelId: _notificationChannelId,
        foregroundServiceNotificationId: _notificationId,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void _onStartService(ServiceInstance instance) {
    instance.on('start_location_tracking').listen((_) => _startLocationUpdate(instance));
    instance.on('pause_location_tracking').listen((_) => _stopLocationUpdate());
  }

  /// 开始定位
  @pragma('vm:entry-point')
  static Future<void> _startLocationUpdate(ServiceInstance instance) async {
    try {
      /// Android 12 及以上的设备，使用 Geolocator 定位
      /// Android 11 及以下的设备，使用 GnssLocationManager 原生定位
      final locationSettings = AndroidSettings(
        distanceFilter: 0,
        accuracy: LocationAccuracy.best,
        intervalDuration: const Duration(seconds: 1),
      );

      void updateTrack(Position position) {
        instance.invoke('update_location', {
          'latitude': position.latitude,
          'longitude': position.longitude,
        });
      }

      _subscriptionOfLocationStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(updateTrack);
    } finally {}
  }

  /// 取消定位
  @pragma('vm:entry-point')
  static void _stopLocationUpdate() {
    _subscriptionOfLocationStream?.cancel();
    _subscriptionOfLocationStream = null;
  }

  /// 开始追踪（用户触发）
  static Future<void> startTracking(void Function(LatLng point) callback) async {
    try {
      if (!(await service.isRunning())) await service.startService();

      _subscriptionOfUpdateStream = service.on('update_location').listen((event) {
        if (event != null) {
          final lat = event['latitude'] as double;
          final lng = event['longitude'] as double;
          final point = LatLng(lat, lng);
          callback(point);
          // 发送通知到前台通知栏
          _showLocationNotification();
        }
      });

      service.invoke('start_location_tracking');
    } catch (error, stack) {
      debugPrint("$error");
      debugPrint("$stack");
      rethrow;
    }
  }

  /// 暂停追踪（用户触发）
  static void pauseTracking() {
    _subscriptionOfUpdateStream?.cancel();
    _subscriptionOfUpdateStream = null;
    service.invoke('pause_location_tracking');
  }

  /// 发送通知
  static Future<void> _showLocationNotification() async {
    await notificationsPlugin.show(
      1,
      '位置更新',
      '用户正在后台使用GPS定位',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _notificationChannelId,
          '位置更新',
          importance: Importance.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}
