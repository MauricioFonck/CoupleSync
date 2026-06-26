import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_range_dto.freezed.dart';
part 'date_range_dto.g.dart';

@freezed
abstract class DateRangeDto with _$DateRangeDto {
  const factory DateRangeDto({required String start, required String end}) =
      _DateRangeDto;

  factory DateRangeDto.fromJson(Map<String, dynamic> json) =>
      _$DateRangeDtoFromJson(json);
}
