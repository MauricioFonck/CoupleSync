// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roulette_spin_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouletteSpinDto _$RouletteSpinDtoFromJson(Map<String, dynamic> json) =>
    _RouletteSpinDto(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      text: json['text'] as String,
      level: json['level'] as String,
      createdAt: json['createdAt'] as String,
      done: json['done'] as bool,
    );

Map<String, dynamic> _$RouletteSpinDtoToJson(_RouletteSpinDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'text': instance.text,
      'level': instance.level,
      'createdAt': instance.createdAt,
      'done': instance.done,
    };
