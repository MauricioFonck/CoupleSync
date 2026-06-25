import 'package:couplesync/domain/entities/streak_stats.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StreakStats', () {
    test('zero es válido', () {
      final s = StreakStats.zero();
      expect(s.currentStreak, 0);
      expect(s.bestStreak, 0);
    });

    test('rechaza rachas negativas', () {
      expect(
        () => StreakStats(
          currentStreak: -1,
          bestStreak: 0,
          weeklyCompletionRate: 0,
          monthlyCompletionRate: 0,
          yearlyCompletionRate: 0,
        ),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('current no puede superar best', () {
      expect(
        () => StreakStats(
          currentStreak: 5,
          bestStreak: 3,
          weeklyCompletionRate: 0,
          monthlyCompletionRate: 0,
          yearlyCompletionRate: 0,
        ),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('rechaza tasas fuera de [0,1]', () {
      expect(
        () => StreakStats(
          currentStreak: 0,
          bestStreak: 0,
          weeklyCompletionRate: 1.5,
          monthlyCompletionRate: 0,
          yearlyCompletionRate: 0,
        ),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });
}
