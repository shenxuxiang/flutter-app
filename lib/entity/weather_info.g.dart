// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInfo _$WeatherInfoFromJson(Map<String, dynamic> json) => WeatherInfo(
  aqi: json['aqi'] as String,
  vis: json['vis'] as String,
  temp: json['temp'] as String,
  icon: json['icon'] as String,
  text: json['text'] as String,
  tempMax: json['tempMax'] as String,
  tempMin: json['tempMin'] as String,
  windDir: json['windDir'] as String,
  humidity: json['humidity'] as String,
  category: json['category'] as String,
  windSpeed: json['windSpeed'] as String,
  windScale: json['windScale'] as String,
  regionCode: json['regionCode'] as String,
);

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'regionCode': instance.regionCode,
      'temp': instance.temp,
      'text': instance.text,
      'icon': instance.icon,
      'windSpeed': instance.windSpeed,
      'windScale': instance.windScale,
      'humidity': instance.humidity,
      'vis': instance.vis,
      'aqi': instance.aqi,
      'tempMin': instance.tempMin,
      'tempMax': instance.tempMax,
      'windDir': instance.windDir,
      'category': instance.category,
    };
