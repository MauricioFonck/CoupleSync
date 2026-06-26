import 'package:couplesync/application/services/couple_service.dart';
import 'package:couplesync/application/services/lazy_schedule_service.dart';
import 'package:couplesync/application/services/scheduling_service.dart';
import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/user.dart';
import 'package:couplesync/domain/use_cases/generate_weekly_schedule_use_case.dart';
import 'package:couplesync/domain/use_cases/reschedule_event_use_case.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/use_cases/_fakes.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');

  group('CoupleService', () {
    test('registra perfiles y devuelve los ids de la pareja', () async {
      final repo = InMemoryUserRepository();
      final service = CoupleService(userRepository: repo);

      await service.registerProfile(User(id: userA, displayName: 'Ana'));
      await service.registerProfile(User(id: userB, displayName: 'Bea'));

      final ids = (await service.coupleUserIds()).valueOrNull!;
      expect(ids.toSet(), {userA, userB});
    });
  });

  group('LazyScheduleService', () {
    late InMemoryActivityRepository activities;
    late InMemoryAvailabilityRepository availability;
    late InMemorySettingsRepository settings;
    late InMemoryWeeklyScheduleRepository weekly;
    late InMemoryScheduledEventRepository events;
    late LazyScheduleService lazy;

    Availability allDays(UserId u) => Availability(
      userId: u,
      availableWeekdays: const {1, 2, 3, 4, 5, 6, 7},
      slotsByWeekday: const {},
      blockedDates: const {},
      unavailablePeriods: const [],
    );

    LazyScheduleService build(DateTime now) {
      final scheduling = SchedulingService(
        generateWeeklySchedule: GenerateWeeklyScheduleUseCase(
          activityRepository: activities,
          availabilityRepository: availability,
          settingsRepository: settings,
          weeklyScheduleRepository: weekly,
          clock: FakeClock(now),
          random: FakeRandom(),
        ),
        rescheduleEvent: RescheduleEventUseCase(
          scheduledEventRepository: events,
        ),
        scheduledEventRepository: events,
      );
      return LazyScheduleService(scheduling: scheduling, clock: FakeClock(now));
    }

    setUp(() {
      activities = InMemoryActivityRepository()
        ..store['a1'] = Activity(
          id: ActivityId('a1'),
          title: 'A',
          description: '',
          category: ActivityCategory('C'),
          createdBy: userA,
          active: true,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        );
      availability = InMemoryAvailabilityRepository()
        ..store['A'] = allDays(userA)
        ..store['B'] = allDays(userB);
      settings = InMemorySettingsRepository();
      weekly = InMemoryWeeklyScheduleRepository();
      events = InMemoryScheduledEventRepository();
    });

    test('genera la agenda de la semana actual y es idempotente', () async {
      // Miércoles 24-jun-2026.
      final now = DateTime.utc(2026, 6, 24, 9);
      lazy = build(now);

      await lazy.ensureUpcoming(partnerA: userA, partnerB: userB);
      final week = WeekId.fromDate(now);
      expect(await weekly.exists(week), isTrue);
      final firstCount = weekly.savedEvents.length;
      expect(firstCount, greaterThan(0));

      // Segunda llamada: el guard evita duplicar (idempotente).
      await lazy.ensureUpcoming(partnerA: userA, partnerB: userB);
      expect(weekly.savedEvents.length, firstCount);
    });

    test('los domingos también prepara la semana siguiente', () async {
      // Domingo 28-jun-2026.
      final now = DateTime.utc(2026, 6, 28, 9);
      lazy = build(now);

      await lazy.ensureUpcoming(partnerA: userA, partnerB: userB);
      expect(await weekly.exists(WeekId.fromDate(now)), isTrue);
      expect(
        await weekly.exists(WeekId.fromDate(now.add(const Duration(days: 7)))),
        isTrue,
      );
    });
  });
}
