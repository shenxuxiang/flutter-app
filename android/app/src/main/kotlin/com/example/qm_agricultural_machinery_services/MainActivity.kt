package com.example.qm_agricultural_machinery_services

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall

class MainActivity() : FlutterActivity() {
    // 创建 GnssLocationManager 实例（用于GPS定位）
    private lateinit var gnssLocationManager: GnssLocationManager;
    private val qmFlutterAndAndroidEventChannel = "qm_flutter_android_event_channel";
    private val qmFlutterAndAndroidMethodChannel = "qm_flutter_android_method_channel";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            qmFlutterAndAndroidMethodChannel
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
            when (call.method) {
                "getPlatformInfo" -> {
                    val versionName = Build.VERSION.RELEASE;  // 如 "13"
                    val apiLevel = Build.VERSION.SDK_INT;     // 如 33
                    val packageManager = packageManager.getPackageInfo(packageName, 0);
                    result.success(
                        mapOf(
                            "versionName" to versionName,
                            "apiLevel" to apiLevel,
                            "appVersion" to packageManager.versionName,
                        )
                    )
                }

                "getCurrentLocation" -> { // 2. 设置新的 MethodChannel（一次性GPS定位）
                    if (!::gnssLocationManager.isInitialized) {
                        gnssLocationManager = GnssLocationManager(this);
                    }

                    // 调用 GnssLocationManager 的方法获取位置
                    gnssLocationManager.getCurrentLocation(result);
                }

                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            qmFlutterAndAndroidEventChannel
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink) {
                    startLocationUpdate(sink);
                }

                override fun onCancel(arguments: Any?) {
                    stopLocationUpdate();
                }
            }
        )
    }

    private var stopUpdateFunction: (() -> Unit)? = null;
    private fun startLocationUpdate(sink: EventChannel.EventSink) {
        if (!::gnssLocationManager.isInitialized) {
            gnssLocationManager = GnssLocationManager(this);
        }

        stopUpdateFunction = gnssLocationManager.updateLocation { location ->
            // 将位置数据转换为 Map
            val locationData = mapOf(
                "latitude" to location.latitude,
                "longitude" to location.longitude,
                "accuracy" to location.accuracy,
                "timestamp" to location.time,
                "speed" to location.speed
            );
            // 通过 sink 发送到 Flutter
            sink.success(locationData);
        }
    }

    private fun stopLocationUpdate() {
        stopUpdateFunction?.invoke();
        stopUpdateFunction = null;
    }

}