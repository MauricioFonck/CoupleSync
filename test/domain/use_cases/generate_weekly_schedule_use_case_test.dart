import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/use_cases/generate_weekly_schedule_use_case.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/scheduling_config.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');
  final week = WeekId('2026-W26');

  late InMemoryActivityRepository activities;
  late InMemoryAvailabilityRepository availability;
  late InMemorySettingsRepository settings;
  late InMemoryWeeklyScheduleRepository weekly;

  Activity activity(String id) => Activity(
        id: ActivityId(id),
        title: id,
        description: '',
        category: ActivityCategory('Cat'),
        createdBy: userA,
        active: true,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );

  Availability allDays(UserId u) => Availability(
        userId: u,
        availableWeekdays: const {1, 2, 3, 4, 5, 6, 7},
        slotsByWeekday: const {},
        blockedDates: const {},
        unavailablePeriods: const [],
      );

  GenerateWeeklyScheduleUseCase build({int days = 2, int perDay = 1}) =>
      GenerateWeeklyScheduleUseCase(
        activityRepository: activities,
        availabilityRepository: availability,
        settingsRepository: settings,
        weeklyScheduleRepository: weekly,
        clock: FakeClock(DateTime.utc(2026, 6, 21)),
        random: FakeRandom(),
      );

  setUp(() {
    activities = InMemoryActivityRepository();
    availability = InMemoryAvailabilityRepository();
    settings = InMemorySettingsRepository(
      SchedulingConfig(daysPerWeek: 2, activitiesPerDay: 1),
    );
    weekly = InMemoryWeeklyScheduleRepository();
    for (final a in ['a1', 'a2', 'a3']) {
      activities.store[a] = activity(a);
    }
    availability.store['A'] = allDays(userA);
    availability.store['B'] = allDays(userB);
  });

  test('genera N días con la disponibilidad de ambos', () async {
    final schedule =
        await build().execute(targetWeek: week, partnerA: userA, partnerB: userB);

    expect(schedule.weekId, week);
    expect(schedule.eventIds.length, 2);
    expect(weekly.savedEvents.length, 2);
    expect(weekly.savedEvents.every((e) => e.status == CompletionStatus.pending),
        isTrue);
    // perDay = 1 y sin repetición consecutiva.
    expect(weekly.savedEvents[0].activityIds, [ActivityId('a1')]);
    expect(weekly.savedEvents[1].activityIds, [ActivityId('a2')]);
  });

  test('lanza conflicto si la semana ya existe (guard)', () async {
    final useCase = build();
    await useCase.execute(targetWeek: week, partnerA: userA, partnerB: userB);
    expect(
      () => useCase.execute(targetWeek: week, partnerA: userA, partnerB: userB),
      throwsA(isA<ScheduleGenerationConflictException>()),
    );
  });

  test('lanza invariante si no hay actividades activas', () async {
    activities.store.clear();
    expect(
      () => build().execute(targetWeek: week, partnerA: userA, partnerB: userB),
      throwsA(isA<DomainInvariantException>()),
    );
  });

  test('evita repeticiones consecutivas con pocas actividades', () async {
    activities.store
      ..clear()
      ..['a1'] = activity('a1')
      ..['a2'] = activity('a2');
    await settings.saveSchedulingConfig(
      SchedulingConfig(daysPerWeek: 3, activitiesPerDay: 1),
    );

    await build().execute(targetWeek: week, partnerA: userA, partnerB: userB);

    final picks =
        weekly.savedEvents.map((e) => e.activityIds.single.value).toList();
    expect(picks.length, 3);
    for (var i = 1; i < picks.length; i++) {
      expect(picks[i], isNot(picks[i - 1]));
    }
  });

  test('respeta la indisponibilidad (un usuario sin días => 0 eventos)',
      () async {
    availability.store['B'] = Availability.empty(userB);
    final schedule =
        await build().execute(targetWeek: week, partnerA: userA, partnerB: userB);
    expect(schedule.eventIds, isEmpty);
    expect(weekly.savedEvents, isEmpty);
  });
}
