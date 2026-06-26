import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_blob_dto.freezed.dart';
part 'media_blob_dto.g.dart';

@freezed
abstract class MediaBlobDto with _$MediaBlobDto {
  const factory MediaBlobDto({
    required String id,
    required String base64,
    required String mime,
    required int width,
    required int height,
    required int byteSize,
    required String createdBy,
    required String createdAt,
  }) = _MediaBlobDto;

  factory MediaBlobDto.fromJson(Map<String, dynamic> json) =>
      _$MediaBlobDtoFromJson(json);
}
