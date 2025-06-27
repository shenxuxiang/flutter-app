package com.example.qm_agricultural_machinery_services

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import android.location.Location
import android.location.LocationListener
import android.os.Build
import android.os.Handler
import android.os.Looper

class GnssLocationManager(private val context: Activity) {
    private val locationManager: LocationManager =
        context.getSystemService(Context.LOCATION_SERVICE) as LocationManager;

    // 获取用户当前位置
    fun getCurrentLocation(result: MethodChannel.Result) {
        if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            val fineLocation = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
            );
            val crossLocation = ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION
            );

            if (fineLocation == PackageManager.PERMISSION_GRANTED || crossLocation == PackageManager.PERMISSION_GRANTED) {
                lateinit var locationListener: LocationListener;
                val handler = Handler(Looper.getMainLooper());
                val timeoutRunnable = Runnable {
                    locationManager.removeUpdates(locationListener);
                    result.error(
                        "LOCATION_UNAVAILABLE",
                        "No GNSS location available",
                        null
                    );
                }
                handler.postDelayed(timeoutRunnable, 10000);

                locationListener = object : LocationListener {
                    override fun onLocationChanged(location: Location) {
                        handler.removeCallbacks(timeoutRunnable)
                        locationManager.removeUpdates(this);
                        // 处理位置信息
                        result.success(
                            mapOf(
                                "latitude" to location.latitude,
                                "longitude" to location.longitude
                            )
                        );
                    }
                }

                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
                    locationManager.requestLocationUpdates(
                        LocationManager.NETWORK_PROVIDER,
                        0L,
                        0f,
                        ContextCompat.getMainExecutor(context),
                        locationListener,
                    );
                } else {
                    locationManager.requestLocationUpdates(
                        LocationManager.NETWORK_PROVIDER,
                        0L,
                        0f,
                        locationListener,
                    );
                }
            } else {
                result.error(
                    "PERMISSION_DENIED",
                    "Location permission not granted",
                    null
                );
            }
        }
    }

    // 持续更新
    fun updateLocation(callback: (location: Location) -> Unit): (() -> Unit)? {
        if (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            val locationListener = LocationListener { location ->
                // 处理位置信息
                callback(location);
            }

            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
                locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER,
                    0L,
                    0f,
                    ContextCompat.getMainExecutor(context),
                    locationListener,
                );
            } else {
                locationManager.requestLocationUpdates(
                    LocationManager.NETWORK_PROVIDER,
                    0L,
                    0f,
                    locationListener,
                );
            }

            // 移除位置更新
            fun stopUpdateLocation() {
                locationManager.removeUpdates(locationListener);
            };
            return ::stopUpdateLocation;
        }
        return null;
    }
}
