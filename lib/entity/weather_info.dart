import 'package:json_annotation/json_annotation.dart';

part 'weather_info.g.dart';

@JsonSerializable()
class WeatherInfo {
  @JsonKey(name: 'regionCode')
  final String regionCode;

  @JsonKey(name: 'temp')
  final String temp;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'icon')
  final String icon;

  @JsonKey(name: 'windSpeed')
  final String windSpeed;

  @JsonKey(name: 'windScale')
  final String windScale;

  @JsonKey(name: 'humidity')
  final String humidity;

  @JsonKey(name: 'vis')
  final String vis;

  @JsonKey(name: 'aqi')
  final String aqi;

  @JsonKey(name: 'tempMin')
  final String tempMin;

  @JsonKey(name: 'tempMax')
  final String tempMax;

  @JsonKey(name: 'windDir')
  final String windDir;

  @JsonKey(name: 'category')
  final String category;

  const WeatherInfo({
    required this.aqi,
    required this.vis,
    required this.temp,
    required this.icon,
    required this.text,
    required this.tempMax,
    required this.tempMin,
    required this.windDir,
    required this.humidity,
    required this.category,
    required this.windSpeed,
    required this.windScale,
    required this.regionCode,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);
}
