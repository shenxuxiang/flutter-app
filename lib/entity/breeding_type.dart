import 'package:json_annotation/json_annotation.dart';

part 'breeding_type.g.dart';

@JsonSerializable()
class BreedingType {
  @JsonKey(name: 'breedingTypeId')
  final dynamic breedingTypeId;

  @JsonKey(name: 'breedingTypeName')
  final String breedingTypeName;

  @JsonKey(name: 'children')
  final List<BreedingType>? children;

  const BreedingType({required this.breedingTypeId, required this.breedingTypeName, this.children});

  factory BreedingType.fromJson(Map<String, dynamic> json) => _$BreedingTypeFromJson(json);

  Map<String, dynamic> toJson() => _$BreedingTypeToJson(this);
}
