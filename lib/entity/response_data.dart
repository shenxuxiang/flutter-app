import 'package:json_annotation/json_annotation.dart';

part 'response_data.g.dart';

@JsonSerializable()
class ResponseData {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  dynamic data;

  @JsonKey(name: 'message')
  String message;

  ResponseData(this.code, this.data, this.message);

  factory ResponseData.fromJson(Map<String, dynamic> json) => _$ResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}