// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_item_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListItemOption _$ListItemOptionFromJson(Map<String, dynamic> json) =>
    ListItemOption(
      label: json['label'] as String,
      value: json['value'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$ListItemOptionToJson(ListItemOption instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'label': instance.label,
      'value': instance.value,
    };
