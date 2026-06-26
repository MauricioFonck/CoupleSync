// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvailabilityDto _$AvailabilityDtoFromJson(Map<String, dynamic> json) =>
    _AvailabilityDto(
      userId: json['userId'] as String,
      availableWeekdays: (json['availableWeekdays'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      slotsByWeekday: (json['slotsByWeekday'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => TimeSlotDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
      blockedDates: (json['blockedDates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      unavailablePeriods: (json['unavailablePeriods'] as List<dynamic>)
          .map((e) => DateRangeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AvailabilityDtoToJson(_AvailabilityDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'availableWeekdays': instance.availableWeekdays,
      'slotsByWeekday': instance.slotsByWeekday,
      'blockedDates': instance.blockedDates,
      'unavailablePeriods': instance.unavailablePeriods,
    };
