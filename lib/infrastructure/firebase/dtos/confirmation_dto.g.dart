// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConfirmationDto _$ConfirmationDtoFromJson(Map<String, dynamic> json) =>
    _ConfirmationDto(
      userId: json['userId'] as String,
      activityId: json['activityId'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ConfirmationDtoToJson(_ConfirmationDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'activityId': instance.activityId,
      'status': instance.status,
    };
