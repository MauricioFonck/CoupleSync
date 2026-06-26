// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_blob_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaBlobDto _$MediaBlobDtoFromJson(Map<String, dynamic> json) =>
    _MediaBlobDto(
      id: json['id'] as String,
      base64: json['base64'] as String,
      mime: json['mime'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      byteSize: (json['byteSize'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$MediaBlobDtoToJson(_MediaBlobDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'base64': instance.base64,
      'mime': instance.mime,
      'width': instance.width,
      'height': instance.height,
      'byteSize': instance.byteSize,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
    };
