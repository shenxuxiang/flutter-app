// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receiving_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivingAddress _$ReceivingAddressFromJson(Map<String, dynamic> json) =>
    ReceivingAddress(
      phone: json['phone'] as String,
      address: json['address'] as String,
      username: json['username'] as String,
      addressId: json['addressId'] as String,
      regionName: json['regionName'] as String,
      regionCode: json['regionCode'] as String,
      defaultFlag: json['defaultFlag'] as bool,
    );

Map<String, dynamic> _$ReceivingAddressToJson(ReceivingAddress instance) =>
    <String, dynamic>{
      'addressId': instance.addressId,
      'username': instance.username,
      'phone': instance.phone,
      'address': instance.address,
      'regionCode': instance.regionCode,
      'regionName': instance.regionName,
      'defaultFlag': instance.defaultFlag,
    };
