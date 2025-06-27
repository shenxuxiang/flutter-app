import 'package:json_annotation/json_annotation.dart';

part 'selected_tree_node.g.dart';

@JsonSerializable()
class SelectedTreeNode {
  @JsonKey(name: 'value')
  final String value;

  @JsonKey(name: 'label')
  final String label;

  @JsonKey(name: 'fullName')
  final String? fullName;

  @JsonKey(name: 'children')
  final List<dynamic>? children;

  const SelectedTreeNode({required this.value, required this.label, this.fullName, this.children});

  factory SelectedTreeNode.fromJson(Map<String, dynamic> json) => _$SelectedTreeNodeFromJson(json);
}
