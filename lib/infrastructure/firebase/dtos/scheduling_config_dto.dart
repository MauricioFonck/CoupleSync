import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheduling_config_dto.freezed.dart';
part 'scheduling_config_dto.g.dart';

@freezed
abstract class SchedulingConfigDto with _$SchedulingConfigDto {
  const factory SchedulingConfigDto({
    required int daysPerWeek,
    required int activitiesPerDay,
  }) = _SchedulingConfigDto;

  factory SchedulingConfigDto.fromJson(Map<String, dynamic> json) =>
      _$SchedulingConfigDtoFromJson(json);
}
