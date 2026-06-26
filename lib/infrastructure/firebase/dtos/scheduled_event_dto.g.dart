// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduledEventDto _$ScheduledEventDtoFromJson(Map<String, dynamic> json) =>
    _ScheduledEventDto(
      id: json['id'] as String,
      date: json['date'] as String,
      weekId: json['weekId'] as String,
      activityIds: (json['activityIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ScheduledEventDtoToJson(_ScheduledEventDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'weekId': instance.weekId,
      'activityIds': instance.activityIds,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'notes': instance.notes,
    };
