import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_dto.freezed.dart';
part 'time_slot_dto.g.dart';

@freezed
abstract class TimeSlotDto with _$TimeSlotDto {
  const factory TimeSlotDto({
    required int startMinutes,
    required int endMinutes,
  }) = _TimeSlotDto;

  factory TimeSlotDto.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDtoFromJson(json);
}
