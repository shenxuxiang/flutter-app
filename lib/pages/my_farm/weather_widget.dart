import 'constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qm_agricultural_machinery_services/entity/weather_info.dart';

class WeatherWidget extends StatelessWidget {
  final WeatherInfo? weather;

  const WeatherWidget({super.key, this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                weatherIcons[weather?.icon ?? '100']!,
                width: 63.w,
                height: 63.w,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 11.w),
              Text(
                weather?.temp ?? '',
                style: TextStyle(fontSize: 52.sp, color: const Color(0xFF333333), height: 1),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.w),
                child: Text(
                  '℃',
                  style: TextStyle(fontSize: 26.sp, color: const Color(0xFF333333), height: 1),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          DefaultTextStyle(
            style: TextStyle(fontSize: 16.sp, height: 1, color: const Color(0xFF333333)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weather?.text ?? ''),
                SizedBox(width: 16.w),
                Text('最高${weather?.tempMax ?? ''}℃'),
                SizedBox(width: 16.w),
                Text('最低${weather?.tempMin ?? ''}℃'),
              ],
            ),
          ),
          SizedBox(height: 20.w),
          DefaultTextStyle(
            style: TextStyle(fontSize: 14.sp, height: 1, color: const Color(0xFF4A4A4A)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('空气质量：'),
                      SizedBox(height: 7.w),
                      Text('${weather?.category ?? ''} ${weather?.aqi ?? ''}'),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('风速：'),
                      SizedBox(height: 7.w),
                      Text('${weather?.windDir ?? ''} ${weather?.windScale ?? ''} 级'),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('湿度：'),
                      SizedBox(height: 7.w),
                      Text('${weather?.humidity ?? ''} %'),
                    ],
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('能见度：'),
                      SizedBox(height: 7.w),
                      Text('${weather?.vis ?? ''} 公里'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
