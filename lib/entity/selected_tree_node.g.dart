// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_tree_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectedTreeNode _$SelectedTreeNodeFromJson(Map<String, dynamic> json) =>
    SelectedTreeNode(
      value: json['value'] as String,
      label: json['label'] as String,
      fullName: json['fullName'] as String?,
      children: json['children'] as List<dynamic>?,
    );

Map<String, dynamic> _$SelectedTreeNodeToJson(SelectedTreeNode instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'fullName': instance.fullName,
      'children': instance.children,
    };
