import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_range_dto.dart';
import 'time_slot_dto.dart';

part 'availability_dto.freezed.dart';
part 'availability_dto.g.dart';

@freezed
abstract class AvailabilityDto with _$AvailabilityDto {
  const factory AvailabilityDto({
    required String userId,
    required List<int> availableWeekdays,
    required Map<String, List<TimeSlotDto>> slotsByWeekday,
    required List<String> blockedDates,
    required List<DateRangeDto> unavailablePeriods,
  }) = _AvailabilityDto;

  factory AvailabilityDto.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityDtoFromJson(json);
}
