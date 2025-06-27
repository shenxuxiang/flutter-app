import 'package:json_annotation/json_annotation.dart';

part 'receiving_address.g.dart';

@JsonSerializable()
class ReceivingAddress {
  @JsonKey(name: 'addressId')
  final String addressId;

  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'regionCode')
  final String regionCode;

  @JsonKey(name: 'regionName')
  final String regionName;

  @JsonKey(name: 'defaultFlag')
  final bool defaultFlag;

  const ReceivingAddress({
    required this.phone,
    required this.address,
    required this.username,
    required this.addressId,
    required this.regionName,
    required this.regionCode,
    required this.defaultFlag,
  });

  factory ReceivingAddress.fromJson(Map<String, dynamic> json) => _$ReceivingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivingAddressToJson(this);
}
