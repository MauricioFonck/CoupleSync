import 'package:couplesync/application/app_failure.dart';
import 'package:couplesync/application/commands/commands.dart';
import 'package:couplesync/application/queries/queries.dart';
import 'package:couplesync/application/services/activity_service.dart';
import 'package:couplesync/application/services/confirmation_service.dart';
import 'package:couplesync/application/services/scheduling_service.dart';
import 'package:couplesync/application/services/statistics_service.dart';
import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/use_cases/activity_use_cases.dart';
import 'package:couplesync/domain/use_cases/calculate_streaks_use_case.dart';
import 'package:couplesync/domain/use_cases/confirm_activity_use_case.dart';
import 'package:couplesync/domain/use_cases/generate_weekly_schedule_use_case.dart';
import 'package:couplesync/domain/use_cases/reschedule_event_use_case.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/scheduling_config.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/use_cases/_fakes.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');
  final clock = FakeClock(DateTime.utc(2026, 6, 21));

  group('ActivityService', () {
    late InMemoryActivityRepository repo;
    late ActivityService service;

    setUp(() {
      repo = InMemoryActivityRepository();
      service = ActivityService(
        createActivity: CreateActivityUseCase(
          activityRepository: repo,
          idGenerator: SeqIdGenerator(),
          clock: clock,
        ),
        updateActivity: UpdateActivityUseCase(
          activityRepository: repo,
          clock: clock,
        ),
        setActivityActive: SetActivityActiveUseCase(
          activityRepository: repo,
          clock: clock,
        ),
        deleteActivity: DeleteActivityUseCase(activityRepository: repo),
        activityRepository: repo,
      );
    });

    test('create devuelve Ok y persiste', () async {
      final r = await service.create(
        CreateActivityCommand(
          title: 'Cena',
          description: 'd',
          category: ActivityCategory('Comida'),
          createdBy: userA,
        ),
      );
      expect(r.isOk, isTrue);
      expect(r.valueOrNull, isA<Activity>());
      expect(repo.store.length, 1);
    });

    test('create con título vacío devuelve Err(validation)', () async {
      final r = await service.create(
        CreateActivityCommand(
          title: '  ',
          description: 'd',
          category: ActivityCategory('Comida'),
          createdBy: userA,
        ),
      );
      expect(r.failureOrNull!.kind, FailureKind.validation);
    });

    test('update inexistente devuelve Err(notFound)', () async {
      final r = await service.update(
        UpdateActivityCommand(id: ActivityId('x'), title: 't'),
      );
      expect(r.failureOrNull!.kind, FailureKind.notFound);
    });

    test('list onlyActive filtra', () async {
      await service.create(
        CreateActivityCommand(
          title: 'A',
          description: '',
          category: ActivityCategory('C'),
          createdBy: userA,
        ),
      );
      final created = repo.store.values.first;
      await service.setActive(created.id, active: false);
      final r = await service.list(const ActivitiesQuery(onlyActive: true));
      expect(r.valueOrNull, isEmpty);
    });
  });

  group('SchedulingService', () {
    late InMemoryActivityRepository activities;
    late InMemoryAvailabilityRepository availability;
    late InMemorySettingsRepository settings;
    late InMemoryWeeklyScheduleRepository weekly;
    late InMemoryScheduledEventRepository events;
    late SchedulingService service;

    Availability allDays(UserId u) => Availability(
      userId: u,
      availableWeekdays: const {1, 2, 3, 4, 5, 6, 7},
      slotsByWeekday: const {},
      blockedDates: const {},
      unavailablePeriods: const [],
    );

    setUp(() {
      activities = InMemoryActivityRepository();
      availability = InMemoryAvailabilityRepository();
      settings = InMemorySettingsRepository(
        SchedulingConfig(daysPerWeek: 1, activitiesPerDay: 1),
      );
      weekly = InMemoryWeeklyScheduleRepository();
      events = InMemoryScheduledEventRepository();
      activities.store['a1'] = Activity(
        id: ActivityId('a1'),
        title: 'A',
        description: '',
        category: ActivityCategory('C'),
        createdBy: userA,
        active: true,
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      );
      availability.store['A'] = allDays(userA);
      availability.store['B'] = allDays(userB);
      service = SchedulingService(
        generateWeeklySchedule: GenerateWeeklyScheduleUseCase(
          activityRepository: activities,
          availabilityRepository: availability,
          settingsRepository: settings,
          weeklyScheduleRepository: weekly,
          clock: clock,
          random: FakeRandom(),
        ),
        rescheduleEvent: RescheduleEventUseCase(
          scheduledEventRepository: events,
        ),
        scheduledEventRepository: events,
      );
    });

    test('generate devuelve Ok', () async {
      final r = await service.generate(
        GenerateScheduleCommand(
          targetWeek: WeekId('2026-W26'),
          partnerA: userA,
          partnerB: userB,
        ),
      );
      expect(r.isOk, isTrue);
    });

    test('generar dos veces la misma semana devuelve Err(conflict)', () async {
      final cmd = GenerateScheduleCommand(
        targetWeek: WeekId('2026-W26'),
        partnerA: userA,
        partnerB: userB,
      );
      await service.generate(cmd);
      final r = await service.generate(cmd);
      expect(r.failureOrNull!.kind, FailureKind.conflict);
    });

    test('sin actividades activas devuelve Err(invariant)', () async {
      activities.store.clear();
      final r = await service.generate(
        GenerateScheduleCommand(
          targetWeek: WeekId('2026-W26'),
          partnerA: userA,
          partnerB: userB,
        ),
      );
      expect(r.failureOrNull!.kind, FailureKind.invariant);
    });
  });

  group('ConfirmationService', () {
    test('completa el evento cuando ambos aprueban', () async {
      final events = InMemoryScheduledEventRepository();
      final confirmations = InMemoryConfirmationRepository();
      final eventId = ScheduledEventId('e1');
      final act1 = ActivityId('act1');
      events.store[eventId.value] = ScheduledEvent(
        id: eventId,
        date: DateTime.utc(2026, 6, 25),
        weekId: WeekId('2026-W26'),
        activityIds: [act1],
        status: CompletionStatus.pending,
        confirmations: const [],
        createdAt: DateTime.utc(2026, 6, 20),
      );
      final service = ConfirmationService(
        confirmActivity: ConfirmActivityUseCase(
          scheduledEventRepository: events,
          confirmationRepository: confirmations,
        ),
      );

      await service.confirm(
        ConfirmActivityCommand(
          eventId: eventId,
          userId: userA,
          activityId: act1,
          status: ConfirmationStatus.approved,
        ),
        partnerA: userA,
        partnerB: userB,
      );
      final r = await service.confirm(
        ConfirmActivityCommand(
          eventId: eventId,
          userId: userB,
          activityId: act1,
          status: ConfirmationStatus.approved,
        ),
        partnerA: userA,
        partnerB: userB,
      );
      expect(r.valueOrNull!.status, CompletionStatus.completed);
    });
  });

  group('StatisticsService', () {
    test('refresh calcula y persiste snapshot', () async {
      final events = InMemoryScheduledEventRepository();
      final stats = InMemoryStatisticsRepository();
      final service = StatisticsService(
        calculateStreaks: CalculateStreaksUseCase(
          scheduledEventRepository: events,
          clock: clock,
        ),
        statisticsRepository: stats,
      );

      final r = await service.refresh();
      expect(r.isOk, isTrue);
      expect(stats.stored, isNotNull);

      final latest = await service.latest();
      expect(latest.valueOrNull!.currentStreak, 0);
    });
  });
}
