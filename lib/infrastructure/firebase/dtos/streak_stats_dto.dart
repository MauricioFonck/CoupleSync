import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_stats_dto.freezed.dart';
part 'streak_stats_dto.g.dart';

@freezed
abstract class StreakStatsDto with _$StreakStatsDto {
  const factory StreakStatsDto({
    required int currentStreak,
    required int bestStreak,
    required double weeklyCompletionRate,
    required double monthlyCompletionRate,
    required double yearlyCompletionRate,
  }) = _StreakStatsDto;

  factory StreakStatsDto.fromJson(Map<String, dynamic> json) =>
      _$StreakStatsDtoFromJson(json);
}
