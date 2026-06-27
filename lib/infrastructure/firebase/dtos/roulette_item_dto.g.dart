// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roulette_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouletteItemDto _$RouletteItemDtoFromJson(Map<String, dynamic> json) =>
    _RouletteItemDto(
      id: json['id'] as String,
      text: json['text'] as String,
      favorite: json['favorite'] as bool,
      level: json['level'] as String? ?? 'medium',
    );

Map<String, dynamic> _$RouletteItemDtoToJson(_RouletteItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'favorite': instance.favorite,
      'level': instance.level,
    };
