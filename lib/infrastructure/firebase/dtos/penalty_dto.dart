import 'package:freezed_annotation/freezed_annotation.dart';

part 'penalty_dto.freezed.dart';
part 'penalty_dto.g.dart';

@freezed
abstract class PenaltyDto with _$PenaltyDto {
  const factory PenaltyDto({
    required String id,
    required String title,
    required String description,
    required String severity,
    required bool active,
    String? imageId,
  }) = _PenaltyDto;

  factory PenaltyDto.fromJson(Map<String, dynamic> json) =>
      _$PenaltyDtoFromJson(json);
}
