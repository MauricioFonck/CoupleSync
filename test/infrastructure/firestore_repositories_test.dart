import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/entities/weekly_schedule.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/repositories/firestore_activity_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_availability_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_confirmation_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_scheduled_event_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_settings_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_weekly_schedule_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');
  late FakeFirebaseFirestore db;

  setUp(() => db = FakeFirebaseFirestore());

  Activity activity(String id, {bool active = true}) => Activity(
    id: ActivityId(id),
    title: id,
    description: '',
    category: ActivityCategory('Cat'),
    createdBy: userA,
    active: active,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );

  group('FirestoreActivityRepository', () {
    test('save/getById/getAll/getActive/delete', () async {
      final repo = FirestoreActivityRepository(db);
      await repo.save(activity('a1'));
      await repo.save(activity('a2', active: false));

      expect((await repo.getById(ActivityId('a1')))!.title, 'a1');
      expect((await repo.getAll()).length, 2);
      expect((await repo.getActive()).map((a) => a.id.value), ['a1']);

      await repo.delete(ActivityId('a1'));
      expect(await repo.getById(ActivityId('a1')), isNull);
    });
  });

  group('FirestoreAvailabilityRepository', () {
    test('vacía si no existe; round-trip si existe', () async {
      final repo = FirestoreAvailabilityRepository(db);
      expect((await repo.getForUser(userA)).availableWeekdays, isEmpty);

      await repo.save(
        Availability(
          userId: userA,
          availableWeekdays: const {1, 2},
          slotsByWeekday: const {},
          blockedDates: const {},
          unavailablePeriods: const [],
        ),
      );
      expect((await repo.getForUser(userA)).availableWeekdays, {1, 2});
    });
  });

  group('FirestoreWeeklyScheduleRepository (guard transaccional)', () {
    WeeklySchedule schedule() => WeeklySchedule(
      weekId: WeekId('2026-W26'),
      eventIds: [ScheduledEventId('evt1')],
      generatedAt: DateTime.utc(2026, 6, 21),
    );

    ScheduledEvent event() => ScheduledEvent(
      id: ScheduledEventId('evt1'),
      date: DateTime.utc(2026, 6, 25),
      weekId: WeekId('2026-W26'),
      activityIds: [ActivityId('a1')],
      status: CompletionStatus.pending,
      confirmations: const [],
      createdAt: DateTime.utc(2026, 6, 21),
    );

    test(
      'saveGenerated crea guard + eventos; segunda vez lanza conflicto',
      () async {
        final repo = FirestoreWeeklyScheduleRepository(db);
        await repo.saveGenerated(schedule: schedule(), events: [event()]);

        expect(await repo.exists(WeekId('2026-W26')), isTrue);
        expect((await repo.getByWeek(WeekId('2026-W26')))!.eventIds.length, 1);
        expect(
          (await db.collection('scheduledEvents').doc('evt1').get()).exists,
          isTrue,
        );

        expect(
          () => repo.saveGenerated(schedule: schedule(), events: [event()]),
          throwsA(isA<ScheduleGenerationConflictException>()),
        );
      },
    );
  });

  group('Confirmaciones end-to-end (hidratación + regla ambos aprueban)', () {
    test('getById hidrata confirmaciones de la subcolección', () async {
      final events = FirestoreScheduledEventRepository(db);
      final confirmations = FirestoreConfirmationRepository(db);
      final eventId = ScheduledEventId('e1');
      final act1 = ActivityId('a1');

      await events.save(
        ScheduledEvent(
          id: eventId,
          date: DateTime.utc(2026, 6, 25),
          weekId: WeekId('2026-W26'),
          activityIds: [act1],
          status: CompletionStatus.pending,
          confirmations: const [],
          createdAt: DateTime.utc(2026, 6, 20),
        ),
      );

      await confirmations.upsert(
        eventId,
        Confirmation(
          userId: userA,
          activityId: act1,
          status: ConfirmationStatus.approved,
        ),
      );
      await confirmations.upsert(
        eventId,
        Confirmation(
          userId: userB,
          activityId: act1,
          status: ConfirmationStatus.approved,
        ),
      );

      final hydrated = await events.getById(eventId);
      expect(hydrated!.confirmations.length, 2);
      expect(hydrated.isFullyApprovedBy(userA, userB), isTrue);
    });

    test('getByDateRange filtra por fecha', () async {
      final events = FirestoreScheduledEventRepository(db);
      await events.save(
        ScheduledEvent(
          id: ScheduledEventId('in'),
          date: DateTime.utc(2026, 6, 25),
          weekId: WeekId('2026-W26'),
          activityIds: const [],
          status: CompletionStatus.completed,
          confirmations: const [],
          createdAt: DateTime.utc(2026, 6, 20),
        ),
      );
      final found = await events.getByDateRange(
        DateRange(
          start: DateTime.utc(2026, 6, 1),
          end: DateTime.utc(2026, 6, 30),
        ),
      );
      expect(found.map((e) => e.id.value), ['in']);
    });
  });

  group('FirestoreSettingsRepository', () {
    test('defaults si no hay doc; round-trip', () async {
      final repo = FirestoreSettingsRepository(db);
      expect((await repo.getSchedulingConfig()).daysPerWeek, 3);
    });
  });
}
