// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityDto _$ActivityDtoFromJson(Map<String, dynamic> json) => _ActivityDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  createdBy: json['createdBy'] as String,
  active: json['active'] as bool,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  imageId: json['imageId'] as String?,
);

Map<String, dynamic> _$ActivityDtoToJson(_ActivityDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'createdBy': instance.createdBy,
      'active': instance.active,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'imageId': instance.imageId,
    };
