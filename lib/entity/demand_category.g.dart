// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demand_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DemandCategory _$DemandCategoryFromJson(Map<String, dynamic> json) =>
    DemandCategory(
      demandCategoryId: json['demandCategoryId'] as String,
      demandName: json['demandName'] as String,
      children:
          (json['children'] as List<dynamic>?)
              ?.map(
                (e) => DemandSubCategory.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$DemandCategoryToJson(DemandCategory instance) =>
    <String, dynamic>{
      'demandCategoryId': instance.demandCategoryId,
      'demandName': instance.demandName,
      'children': instance.children,
    };
