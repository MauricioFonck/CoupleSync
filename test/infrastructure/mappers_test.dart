import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/media_blob.dart';
import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/entities/roulette_item.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/entities/streak_stats.dart';
import 'package:couplesync/domain/entities/user.dart';
import 'package:couplesync/domain/entities/weekly_schedule.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/scheduling_config.dart';
import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/time_slot.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/firebase/dtos/activity_dto.dart';
import 'package:couplesync/infrastructure/firebase/mappers/mappers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userA = UserId('A');

  test('Activity round-trip dominio→DTO→dominio (+ json)', () {
    final a = Activity(
      id: ActivityId('a1'),
      title: 'Cena',
      description: 'd',
      category: ActivityCategory('Comida'),
      createdBy: userA,
      active: true,
      imageId: MediaId('m1'),
      createdAt: DateTime.utc(2026, 6, 1, 10),
      updatedAt: DateTime.utc(2026, 6, 2, 11),
    );
    expect(a.toDto().toDomain(), a);
    // json round-trip del DTO.
    expect(ActivityDto.fromJson(a.toDto().toJson()), a.toDto());
  });

  test('Penalty round-trip', () {
    final p = Penalty(
      id: PenaltyId('p1'),
      title: 'Lavar',
      description: 'd',
      severity: Severity.high,
      active: false,
      imageId: MediaId('m2'),
    );
    expect(p.toDto().toDomain(), p);
  });

  test('Availability round-trip con colecciones', () {
    final av = Availability(
      userId: userA,
      availableWeekdays: const {1, 3, 5},
      slotsByWeekday: {
        1: [TimeSlot(startMinutes: 540, endMinutes: 600)],
      },
      blockedDates: {DateTime.utc(2026, 6, 25)},
      unavailablePeriods: [
        DateRange(
          start: DateTime.utc(2026, 7, 1),
          end: DateTime.utc(2026, 7, 10),
        ),
      ],
    );
    expect(av.toDto().toDomain(), av);
  });

  test('ScheduledEvent round-trip (confirmaciones aparte)', () {
    final e = ScheduledEvent(
      id: ScheduledEventId('e1'),
      date: DateTime.utc(2026, 6, 25),
      weekId: WeekId('2026-W26'),
      activityIds: [ActivityId('a1'), ActivityId('a2')],
      status: CompletionStatus.completed,
      confirmations: const [],
      notes: 'nota',
      createdAt: DateTime.utc(2026, 6, 20),
    );
    expect(e.toDto().toDomain(), e);

    final conf = Confirmation(
      userId: userA,
      activityId: ActivityId('a1'),
      status: ConfirmationStatus.approved,
    );
    final withConf = e.toDto().toDomain(confirmations: [conf]);
    expect(withConf.confirmations.single, conf);
  });

  test(
    'Confirmation / WeeklySchedule / MediaBlob / StreakStats / Config / User',
    () {
      final conf = Confirmation(
        userId: userA,
        activityId: ActivityId('a1'),
        status: ConfirmationStatus.rejected,
      );
      expect(conf.toDto().toDomain(), conf);

      final ws = WeeklySchedule(
        weekId: WeekId('2026-W26'),
        eventIds: [ScheduledEventId('e1')],
        generatedAt: DateTime.utc(2026, 6, 21),
      );
      expect(ws.toDto().toDomain(), ws);

      final blob = MediaBlob(
        id: MediaId('m1'),
        base64: 'AAAA',
        mime: 'image/jpeg',
        width: 800,
        height: 600,
        byteSize: 1000,
        createdBy: userA,
        createdAt: DateTime.utc(2026),
      );
      expect(blob.toDto().toDomain(), blob);

      final stats = StreakStats(
        currentStreak: 2,
        bestStreak: 5,
        weeklyCompletionRate: 0.5,
        monthlyCompletionRate: 0.25,
        yearlyCompletionRate: 0.1,
      );
      expect(stats.toDto().toDomain(), stats);

      final cfg = SchedulingConfig(daysPerWeek: 3, activitiesPerDay: 2);
      expect(cfg.toDto().toDomain(), cfg);

      final user = User(id: userA, displayName: 'Ana');
      expect(user.toDto().toDomain(), user);

      final roulette = RouletteItem(
        id: RouletteItemId('r1'),
        text: 'idea',
        favorite: true,
      );
      expect(roulette.toDto().toDomain(), roulette);
    },
  );
}
