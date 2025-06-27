import 'package:json_annotation/json_annotation.dart';

part 'demand_sub_category.g.dart';

@JsonSerializable()
class DemandSubCategory {
  @JsonKey(name: 'demandSubcategoryId')
  final String demandSubcategoryId;

  @JsonKey(name: 'demandSubcategoryName')
  final String demandSubcategoryName;

  const DemandSubCategory({required this.demandSubcategoryId, required this.demandSubcategoryName});

  factory DemandSubCategory.fromJson(Map<String, dynamic> json) =>
      _$DemandSubCategoryFromJson(json);

  toJson() => _$DemandSubCategoryToJson(this);
}
