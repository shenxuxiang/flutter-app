import 'package:json_annotation/json_annotation.dart';
import 'demand_sub_category.dart';

part 'demand_category.g.dart';

@JsonSerializable()
class DemandCategory {
  @JsonKey(name: 'demandCategoryId')
  final String demandCategoryId;

  @JsonKey(name: 'demandName')
  final String demandName;

  @JsonKey(name: 'children')
  final List<DemandSubCategory>? children;

  const DemandCategory({required this.demandCategoryId, required this.demandName, this.children});

  factory DemandCategory.fromJson(Map<String, dynamic> json) => _$DemandCategoryFromJson(json);

  toJson() => _$DemandCategoryToJson(this);
}
