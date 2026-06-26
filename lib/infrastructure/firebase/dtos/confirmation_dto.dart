import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirmation_dto.freezed.dart';
part 'confirmation_dto.g.dart';

@freezed
abstract class ConfirmationDto with _$ConfirmationDto {
  const factory ConfirmationDto({
    required String userId,
    required String activityId,
    required String status,
  }) = _ConfirmationDto;

  factory ConfirmationDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmationDtoFromJson(json);
}
