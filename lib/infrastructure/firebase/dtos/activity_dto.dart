import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_dto.freezed.dart';
part 'activity_dto.g.dart';

/// DTO de persistencia de `Activity`. Fechas como ISO-8601 string; enums como
/// `name`. El mapeo a/desde dominio vive en `activity_mapper.dart`.
@freezed
abstract class ActivityDto with _$ActivityDto {
  const factory ActivityDto({
    required String id,
    required String title,
    required String description,
    required String category,
    required String createdBy,
    required bool active,
    required String createdAt,
    required String updatedAt,
    String? imageId,
  }) = _ActivityDto;

  factory ActivityDto.fromJson(Map<String, dynamic> json) =>
      _$ActivityDtoFromJson(json);
}
