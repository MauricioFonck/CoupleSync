import '../entities/scheduled_event.dart';
import '../entities/streak_stats.dart';
import '../ports/clock_port.dart';
import '../ports/scheduled_event_repository_port.dart';
import '../value_objects/date_range.dart';
import '../value_objects/statuses.dart';

/// Calcula rachas y tasas de cumplimiento a partir del historial de eventos.
///
/// Solo cuentan los eventos **cerrados** (`completed`/`missed`); los `pending`
/// y `rescheduled` se ignoran para las tasas y rachas.
class CalculateStreaksUseCase {
  const CalculateStreaksUseCase({
    required ScheduledEventRepositoryPort scheduledEventRepository,
    required ClockPort clock,
  }) : _events = scheduledEventRepository,
       _clock = clock;

  final ScheduledEventRepositoryPort _events;
  final ClockPort _clock;

  Future<StreakStats> execute() async {
    final now = _clock.now();
    final all = await _events.getByDateRange(
      DateRange(start: DateTime.utc(2000), end: now),
    );

    final closed = all.where((e) => e.status.isClosed).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final currentStreak = _currentStreak(closed);
    final bestStreak = _bestStreak(closed);

    return StreakStats(
      currentStreak: currentStreak,
      bestStreak: bestStreak < currentStreak ? currentStreak : bestStreak,
      weeklyCompletionRate: _rate(closed, now, const Duration(days: 7)),
      monthlyCompletionRate: _rate(closed, now, const Duration(days: 30)),
      yearlyCompletionRate: _rate(closed, now, const Duration(days: 365)),
    );
  }

  /// Racha actual: completados consecutivos contando desde el más reciente
  /// hacia atrás; se corta ante el primer `missed`.
  int _currentStreak(List<ScheduledEvent> closedAsc) {
    var streak = 0;
    for (final e in closedAsc.reversed) {
      if (e.status == CompletionStatus.completed) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Mejor racha histórica de completados consecutivos.
  int _bestStreak(List<ScheduledEvent> closedAsc) {
    var best = 0;
    var run = 0;
    for (final e in closedAsc) {
      if (e.status == CompletionStatus.completed) {
        run++;
        if (run > best) best = run;
      } else {
        run = 0;
      }
    }
    return best;
  }

  double _rate(List<ScheduledEvent> closedAsc, DateTime now, Duration window) {
    final from = now.subtract(window);
    final inWindow = closedAsc.where(
      (e) => !e.date.isBefore(from) && !e.date.isAfter(now),
    );
    final total = inWindow.length;
    if (total == 0) return 0;
    final completed = inWindow
        .where((e) => e.status == CompletionStatus.completed)
        .length;
    return completed / total;
  }
}
