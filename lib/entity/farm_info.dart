import 'package:json_annotation/json_annotation.dart';

part 'farm_info.g.dart';

@JsonSerializable()
class FarmInfo {
  @JsonKey(name: 'farmId')
  final String farmId;

  @JsonKey(name: 'farmName')
  final String farmName;

  @JsonKey(name: 'unifiedSocialCreditCode')
  final String? unifiedSocialCreditCode;

  @JsonKey(name: 'organizationCode')
  final String? organizationCode;

  @JsonKey(name: 'leader')
  final String? leader;

  @JsonKey(name: 'longitude')
  final String longitude;

  @JsonKey(name: 'latitude')
  final String latitude;

  @JsonKey(name: 'location')
  final String? location;

  @JsonKey(name: 'regionCode')
  final String regionCode;

  @JsonKey(name: 'regionName')
  final String regionName;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'pname')
  final String pname;

  @JsonKey(name: 'cityname')
  final String cityname;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'adname')
  final String adname;

  @JsonKey(name: 'contact')
  final String? contact;

  @JsonKey(name: 'farmerCount')
  final int? farmerCount;

  @JsonKey(name: 'scopeBusiness')
  final String? scopeBusiness;

  @JsonKey(name: 'breedingTypeIdList')
  final List<dynamic>? breedingTypeIdList;

  @JsonKey(name: 'breedingTypeNames')
  final String? breedingTypeNames;

  @JsonKey(name: 'systemDefault')
  final bool systemDefault;

  const FarmInfo({
    required this.name,
    required this.pname,
    required this.adname,
    required this.leader,
    required this.farmId,
    required this.address,
    required this.latitude,
    required this.cityname,
    required this.farmName,
    required this.longitude,
    required this.regionCode,
    required this.regionName,
    required this.systemDefault,
    this.contact,
    this.location,
    this.farmerCount,
    this.scopeBusiness,
    this.organizationCode,
    this.breedingTypeNames,
    this.breedingTypeIdList,
    this.unifiedSocialCreditCode,
  });

  factory FarmInfo.fromJson(Map<String, dynamic> json) => _$FarmInfoFromJson(json);

  toJson() => _$FarmInfoToJson(this);
}
