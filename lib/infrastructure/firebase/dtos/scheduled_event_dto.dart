import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheduled_event_dto.freezed.dart';
part 'scheduled_event_dto.g.dart';

/// Las confirmaciones NO se incrustan aquí: viven en la subcolección
/// `scheduledEvents/{id}/confirmations` (ver D4).
@freezed
abstract class ScheduledEventDto with _$ScheduledEventDto {
  const factory ScheduledEventDto({
    required String id,
    required String date,
    required String weekId,
    required List<String> activityIds,
    required String status,
    required String createdAt,
    String? notes,
  }) = _ScheduledEventDto;

  factory ScheduledEventDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduledEventDtoFromJson(json);
}
