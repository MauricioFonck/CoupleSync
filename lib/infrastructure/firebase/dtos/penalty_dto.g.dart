// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penalty_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PenaltyDto _$PenaltyDtoFromJson(Map<String, dynamic> json) => _PenaltyDto(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  severity: json['severity'] as String,
  active: json['active'] as bool,
  imageId: json['imageId'] as String?,
);

Map<String, dynamic> _$PenaltyDtoToJson(_PenaltyDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'severity': instance.severity,
      'active': instance.active,
      'imageId': instance.imageId,
    };
