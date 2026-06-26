// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakStatsDto _$StreakStatsDtoFromJson(Map<String, dynamic> json) =>
    _StreakStatsDto(
      currentStreak: (json['currentStreak'] as num).toInt(),
      bestStreak: (json['bestStreak'] as num).toInt(),
      weeklyCompletionRate: (json['weeklyCompletionRate'] as num).toDouble(),
      monthlyCompletionRate: (json['monthlyCompletionRate'] as num).toDouble(),
      yearlyCompletionRate: (json['yearlyCompletionRate'] as num).toDouble(),
    );

Map<String, dynamic> _$StreakStatsDtoToJson(_StreakStatsDto instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'bestStreak': instance.bestStreak,
      'weeklyCompletionRate': instance.weeklyCompletionRate,
      'monthlyCompletionRate': instance.monthlyCompletionRate,
      'yearlyCompletionRate': instance.yearlyCompletionRate,
    };
