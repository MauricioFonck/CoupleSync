import 'package:freezed_annotation/freezed_annotation.dart';

part 'roulette_spin_dto.freezed.dart';
part 'roulette_spin_dto.g.dart';

@freezed
abstract class RouletteSpinDto with _$RouletteSpinDto {
  const factory RouletteSpinDto({
    required String id,
    required String itemId,
    required String text,
    required String level,
    required String createdAt,
    required bool done,
  }) = _RouletteSpinDto;

  factory RouletteSpinDto.fromJson(Map<String, dynamic> json) =>
      _$RouletteSpinDtoFromJson(json);
}
