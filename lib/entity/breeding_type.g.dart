// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeding_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedingType _$BreedingTypeFromJson(Map<String, dynamic> json) => BreedingType(
  breedingTypeId: json['breedingTypeId'],
  breedingTypeName: json['breedingTypeName'] as String,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => BreedingType.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$BreedingTypeToJson(BreedingType instance) =>
    <String, dynamic>{
      'breedingTypeId': instance.breedingTypeId,
      'breedingTypeName': instance.breedingTypeName,
      'children': instance.children,
    };
