import 'package:json_annotation/json_annotation.dart';

part 'list_item_option.g.dart';

@JsonSerializable()
class ListItemOption {
  @JsonKey(name: 'enabled')
  final bool enabled;

  @JsonKey(name: 'label')
  final String label;

  @JsonKey(name: 'value')
  final String value;

  const ListItemOption({required this.label, required this.value, this.enabled = true});

  factory ListItemOption.fromJson(Map<String, dynamic> json) => _$ListItemOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ListItemOptionToJson(this);
}
