import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/use_cases/calculate_streaks_use_case.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  late InMemoryScheduledEventRepository events;

  ScheduledEvent event(DateTime date, CompletionStatus status) =>
      ScheduledEvent(
        id: ScheduledEventId('e-${date.toIso8601String()}'),
        date: date,
        weekId: WeekId.fromDate(date),
        activityIds: [ActivityId('a1')],
        status: status,
        confirmations: const [],
        createdAt: date,
      );

  setUp(() => events = InMemoryScheduledEventRepository());

  CalculateStreaksUseCase build(DateTime now) => CalculateStreaksUseCase(
    scheduledEventRepository: events,
    clock: FakeClock(now),
  );

  test('racha actual cuenta completados consecutivos al final', () async {
    final now = DateTime.utc(2026, 6, 30);
    for (final e in [
      event(DateTime.utc(2026, 6, 10), CompletionStatus.completed),
      event(DateTime.utc(2026, 6, 12), CompletionStatus.missed),
      event(DateTime.utc(2026, 6, 14), CompletionStatus.completed),
      event(DateTime.utc(2026, 6, 16), CompletionStatus.completed),
    ]) {
      events.store[e.id.value] = e;
    }

    final stats = await build(now).execute();
    expect(stats.currentStreak, 2);
    expect(stats.bestStreak, 2);
  });

  test('mejor racha es el run máximo histórico', () async {
    final now = DateTime.utc(2026, 6, 30);
    for (final e in [
      event(DateTime.utc(2026, 6, 1), CompletionStatus.completed),
      event(DateTime.utc(2026, 6, 2), CompletionStatus.completed),
      event(DateTime.utc(2026, 6, 3), CompletionStatus.completed),
      event(DateTime.utc(2026, 6, 4), CompletionStatus.missed),
      event(DateTime.utc(2026, 6, 5), CompletionStatus.completed),
    ]) {
      events.store[e.id.value] = e;
    }

    final stats = await build(now).execute();
    expect(stats.bestStreak, 3);
    expect(stats.currentStreak, 1);
  });

  test('tasas de cumplimiento por ventana', () async {
    final now = DateTime.utc(2026, 6, 30);
    // En los últimos 7 días: 1 completado, 1 fallado => 0.5.
    events.store['c'] = event(
      DateTime.utc(2026, 6, 28),
      CompletionStatus.completed,
    );
    events.store['m'] = event(
      DateTime.utc(2026, 6, 27),
      CompletionStatus.missed,
    );

    final stats = await build(now).execute();
    expect(stats.weeklyCompletionRate, 0.5);
  });

  test('sin eventos cerrados las tasas son 0 y rachas 0', () async {
    final stats = await build(DateTime.utc(2026, 6, 30)).execute();
    expect(stats.currentStreak, 0);
    expect(stats.bestStreak, 0);
    expect(stats.yearlyCompletionRate, 0);
  });
}
