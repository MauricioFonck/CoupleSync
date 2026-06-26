import '../exceptions/domain_exception.dart';

/// Estadísticas de cumplimiento y rachas (calculadas en el dominio).
/// Las tasas están en `[0, 1]`.
final class StreakStats {
  StreakStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.weeklyCompletionRate,
    required this.monthlyCompletionRate,
    required this.yearlyCompletionRate,
  }) {
    if (currentStreak < 0 || bestStreak < 0) {
      throw const DomainValidationException(
        'Las rachas no pueden ser negativas.',
      );
    }
    if (currentStreak > bestStreak) {
      throw const DomainValidationException(
        'currentStreak no puede superar bestStreak.',
      );
    }
    for (final rate in <double>[
      weeklyCompletionRate,
      monthlyCompletionRate,
      yearlyCompletionRate,
    ]) {
      if (rate < 0 || rate > 1) {
        throw DomainValidationException(
          'Tasa de cumplimiento fuera de rango: $rate (0..1).',
        );
      }
    }
  }

  /// Estadísticas en cero (estado inicial).
  factory StreakStats.zero() => StreakStats(
    currentStreak: 0,
    bestStreak: 0,
    weeklyCompletionRate: 0,
    monthlyCompletionRate: 0,
    yearlyCompletionRate: 0,
  );

  final int currentStreak;
  final int bestStreak;
  final double weeklyCompletionRate;
  final double monthlyCompletionRate;
  final double yearlyCompletionRate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakStats &&
          other.currentStreak == currentStreak &&
          other.bestStreak == bestStreak &&
          other.weeklyCompletionRate == weeklyCompletionRate &&
          other.monthlyCompletionRate == monthlyCompletionRate &&
          other.yearlyCompletionRate == yearlyCompletionRate);

  @override
  int get hashCode => Object.hash(
    currentStreak,
    bestStreak,
    weeklyCompletionRate,
    monthlyCompletionRate,
    yearlyCompletionRate,
  );

  @override
  String toString() => 'StreakStats(current=$currentStreak, best=$bestStreak)';
}
