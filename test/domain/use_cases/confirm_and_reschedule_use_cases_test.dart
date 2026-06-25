import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/use_cases/confirm_activity_use_case.dart';
import 'package:couplesync/domain/use_cases/reschedule_event_use_case.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');
  final act1 = ActivityId('act1');
  final eventId = ScheduledEventId('e1');

  late InMemoryScheduledEventRepository events;
  late InMemoryConfirmationRepository confirmations;

  ScheduledEvent pendingEvent() => ScheduledEvent(
        id: eventId,
        date: DateTime.utc(2026, 6, 25),
        weekId: WeekId('2026-W26'),
        activityIds: [act1],
        status: CompletionStatus.pending,
        confirmations: const [],
        createdAt: DateTime.utc(2026, 6, 20),
      );

  setUp(() {
    events = InMemoryScheduledEventRepository();
    confirmations = InMemoryConfirmationRepository();
    events.store[eventId.value] = pendingEvent();
  });

  ConfirmActivityUseCase confirmUseCase() => ConfirmActivityUseCase(
        scheduledEventRepository: events,
        confirmationRepository: confirmations,
      );

  group('ConfirmActivityUseCase', () {
    test('no completa con una sola aprobación; completa cuando aprueban ambos',
        () async {
      final uc = confirmUseCase();
      final afterA = await uc.execute(
        eventId: eventId,
        userId: userA,
        activityId: act1,
        status: ConfirmationStatus.approved,
        partnerA: userA,
        partnerB: userB,
      );
      expect(afterA.status, CompletionStatus.pending);

      final afterB = await uc.execute(
        eventId: eventId,
        userId: userB,
        activityId: act1,
        status: ConfirmationStatus.approved,
        partnerA: userA,
        partnerB: userB,
      );
      expect(afterB.status, CompletionStatus.completed);
      expect(confirmations.store[eventId.value]!.length, 2);
    });

    test('lanza si la actividad no pertenece al evento', () async {
      expect(
        () => confirmUseCase().execute(
          eventId: eventId,
          userId: userA,
          activityId: ActivityId('otra'),
          status: ConfirmationStatus.approved,
          partnerA: userA,
          partnerB: userB,
        ),
        throwsA(isA<DomainInvariantException>()),
      );
    });

    test('lanza si el evento no existe', () async {
      expect(
        () => confirmUseCase().execute(
          eventId: ScheduledEventId('nope'),
          userId: userA,
          activityId: act1,
          status: ConfirmationStatus.approved,
          partnerA: userA,
          partnerB: userB,
        ),
        throwsA(isA<EntityNotFoundException>()),
      );
    });
  });

  group('RescheduleEventUseCase', () {
    test('mueve la fecha, recalcula semana y reinicia confirmaciones',
        () async {
      final moved = await RescheduleEventUseCase(
        scheduledEventRepository: events,
      ).execute(eventId: eventId, newDate: DateTime.utc(2026, 7, 23));

      expect(moved.date, DateTime.utc(2026, 7, 23));
      expect(moved.weekId, WeekId.fromDate(DateTime.utc(2026, 7, 23)));
      expect(moved.status, CompletionStatus.pending);
      expect(moved.confirmations, isEmpty);
    });

    test('no reprograma un evento cerrado', () async {
      events.store[eventId.value] =
          pendingEvent().copyWith(status: CompletionStatus.completed);
      expect(
        () => RescheduleEventUseCase(scheduledEventRepository: events)
            .execute(eventId: eventId, newDate: DateTime.utc(2026, 7, 23)),
        throwsA(isA<DomainInvariantException>()),
      );
    });
  });
}
