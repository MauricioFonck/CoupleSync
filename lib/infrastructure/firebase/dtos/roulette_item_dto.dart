import 'package:freezed_annotation/freezed_annotation.dart';

part 'roulette_item_dto.freezed.dart';
part 'roulette_item_dto.g.dart';

@freezed
abstract class RouletteItemDto with _$RouletteItemDto {
  const factory RouletteItemDto({
    required String id,
    required String text,
    required bool favorite,
    // Por defecto 'medium' para compatibilidad con ítems creados sin nivel.
    @Default('medium') String level,
  }) = _RouletteItemDto;

  factory RouletteItemDto.fromJson(Map<String, dynamic> json) =>
      _$RouletteItemDtoFromJson(json);
}
