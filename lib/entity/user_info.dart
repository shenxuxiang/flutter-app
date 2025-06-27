import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'userId')
  final String userId; // 用户id

  @JsonKey(name: 'username')
  final String username; // 用户名

  @JsonKey(name: 'sex')
  final int sex;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'regionCode')
  final String regionCode;

  @JsonKey(name: 'regionName')
  final String regionName;

  @JsonKey(name: 'status')
  final int status; // 状态

  @JsonKey(name: 'avatar')
  final String avatar; // 头像

  @JsonKey(name: 'profession')
  final String profession; // 职位

  @JsonKey(name: 'checked')
  final bool checked; // 是否已审核

  @JsonKey(name: 'description')
  final String description; // 描述

  @JsonKey(name: 'address')
  final String address; // 详细地址

  @JsonKey(name: 'idCardNum')
  final String idCardNum; // 身份证号码

  @JsonKey(name: 'idCardValidTime')
  final String idCardValidTime; // 身份证有效期

  const UserInfo({
    required this.sex,
    required this.phone,
    required this.status,
    required this.userId,
    required this.avatar,
    required this.address,
    required this.checked,
    required this.username,
    required this.idCardNum,
    required this.profession,
    required this.regionName,
    required this.regionCode,
    required this.description,
    required this.idCardValidTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  toJson() => _$UserInfoToJson(this);
}
