// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduling_config_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchedulingConfigDto _$SchedulingConfigDtoFromJson(Map<String, dynamic> json) =>
    _SchedulingConfigDto(
      daysPerWeek: (json['daysPerWeek'] as num).toInt(),
      activitiesPerDay: (json['activitiesPerDay'] as num).toInt(),
    );

Map<String, dynamic> _$SchedulingConfigDtoToJson(
  _SchedulingConfigDto instance,
) => <String, dynamic>{
  'daysPerWeek': instance.daysPerWeek,
  'activitiesPerDay': instance.activitiesPerDay,
};
