import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_schedule_dto.freezed.dart';
part 'weekly_schedule_dto.g.dart';

@freezed
abstract class WeeklyScheduleDto with _$WeeklyScheduleDto {
  const factory WeeklyScheduleDto({
    required String weekId,
    required List<String> eventIds,
    required String generatedAt,
  }) = _WeeklyScheduleDto;

  factory WeeklyScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$WeeklyScheduleDtoFromJson(json);
}
