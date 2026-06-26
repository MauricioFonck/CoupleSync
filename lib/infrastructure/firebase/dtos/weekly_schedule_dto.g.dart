// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_schedule_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyScheduleDto _$WeeklyScheduleDtoFromJson(Map<String, dynamic> json) =>
    _WeeklyScheduleDto(
      weekId: json['weekId'] as String,
      eventIds: (json['eventIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      generatedAt: json['generatedAt'] as String,
    );

Map<String, dynamic> _$WeeklyScheduleDtoToJson(_WeeklyScheduleDto instance) =>
    <String, dynamic>{
      'weekId': instance.weekId,
      'eventIds': instance.eventIds,
      'generatedAt': instance.generatedAt,
    };
