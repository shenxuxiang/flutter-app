// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'farm_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FarmInfo _$FarmInfoFromJson(Map<String, dynamic> json) => FarmInfo(
  name: json['name'] as String,
  pname: json['pname'] as String,
  adname: json['adname'] as String,
  leader: json['leader'] as String?,
  farmId: json['farmId'] as String,
  address: json['address'] as String,
  latitude: json['latitude'] as String,
  cityname: json['cityname'] as String,
  farmName: json['farmName'] as String,
  longitude: json['longitude'] as String,
  regionCode: json['regionCode'] as String,
  regionName: json['regionName'] as String,
  systemDefault: json['systemDefault'] as bool,
  contact: json['contact'] as String?,
  location: json['location'] as String?,
  farmerCount: (json['farmerCount'] as num?)?.toInt(),
  scopeBusiness: json['scopeBusiness'] as String?,
  organizationCode: json['organizationCode'] as String?,
  breedingTypeNames: json['breedingTypeNames'] as String?,
  breedingTypeIdList: json['breedingTypeIdList'] as List<dynamic>?,
  unifiedSocialCreditCode: json['unifiedSocialCreditCode'] as String?,
);

Map<String, dynamic> _$FarmInfoToJson(FarmInfo instance) => <String, dynamic>{
  'farmId': instance.farmId,
  'farmName': instance.farmName,
  'unifiedSocialCreditCode': instance.unifiedSocialCreditCode,
  'organizationCode': instance.organizationCode,
  'leader': instance.leader,
  'longitude': instance.longitude,
  'latitude': instance.latitude,
  'location': instance.location,
  'regionCode': instance.regionCode,
  'regionName': instance.regionName,
  'address': instance.address,
  'pname': instance.pname,
  'cityname': instance.cityname,
  'name': instance.name,
  'adname': instance.adname,
  'contact': instance.contact,
  'farmerCount': instance.farmerCount,
  'scopeBusiness': instance.scopeBusiness,
  'breedingTypeIdList': instance.breedingTypeIdList,
  'breedingTypeNames': instance.breedingTypeNames,
  'systemDefault': instance.systemDefault,
};
