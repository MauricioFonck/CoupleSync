// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeSlotDto _$TimeSlotDtoFromJson(Map<String, dynamic> json) => _TimeSlotDto(
  startMinutes: (json['startMinutes'] as num).toInt(),
  endMinutes: (json['endMinutes'] as num).toInt(),
);

Map<String, dynamic> _$TimeSlotDtoToJson(_TimeSlotDto instance) =>
    <String, dynamic>{
      'startMinutes': instance.startMinutes,
      'endMinutes': instance.endMinutes,
    };
