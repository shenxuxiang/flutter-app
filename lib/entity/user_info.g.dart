// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  sex: (json['sex'] as num).toInt(),
  phone: json['phone'] as String,
  status: (json['status'] as num).toInt(),
  userId: json['userId'] as String,
  avatar: json['avatar'] as String,
  address: json['address'] as String,
  checked: json['checked'] as bool,
  username: json['username'] as String,
  idCardNum: json['idCardNum'] as String,
  profession: json['profession'] as String,
  regionName: json['regionName'] as String,
  regionCode: json['regionCode'] as String,
  description: json['description'] as String,
  idCardValidTime: json['idCardValidTime'] as String,
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'sex': instance.sex,
  'phone': instance.phone,
  'regionCode': instance.regionCode,
  'regionName': instance.regionName,
  'status': instance.status,
  'avatar': instance.avatar,
  'profession': instance.profession,
  'checked': instance.checked,
  'description': instance.description,
  'address': instance.address,
  'idCardNum': instance.idCardNum,
  'idCardValidTime': instance.idCardValidTime,
};
