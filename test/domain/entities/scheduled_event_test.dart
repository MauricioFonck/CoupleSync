import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');
  final act1 = ActivityId('act1');

  ScheduledEvent baseEvent() => ScheduledEvent(
        id: ScheduledEventId('e1'),
        date: DateTime.utc(2026, 6, 25),
        weekId: WeekId('2026-W26'),
        activityIds: [act1],
        status: CompletionStatus.pending,
        confirmations: const [],
        createdAt: DateTime.utc(2026, 6, 20),
      );

  group('ScheduledEvent confirmaciones', () {
    test('no está aprobado sin confirmaciones', () {
      expect(baseEvent().isFullyApprovedBy(userA, userB), isFalse);
    });

    test('no se completa si solo uno aprueba', () {
      final e = baseEvent().upsertConfirmation(
        Confirmation(
          userId: userA,
          activityId: act1,
          status: ConfirmationStatus.approved,
        ),
      );
      expect(e.isApprovedBy(act1, userA), isTrue);
      expect(e.isFullyApprovedBy(userA, userB), isFalse);
    });

    test('se completa solo si AMBOS aprueban', () {
      final e = baseEvent()
          .upsertConfirmation(
            Confirmation(
              userId: userA,
              activityId: act1,
              status: ConfirmationStatus.approved,
            ),
          )
          .upsertConfirmation(
            Confirmation(
              userId: userB,
              activityId: act1,
              status: ConfirmationStatus.approved,
            ),
          );
      expect(e.isFullyApprovedBy(userA, userB), isTrue);
    });

    test('upsert reemplaza la confirmación previa del mismo usuario', () {
      final e = baseEvent()
          .upsertConfirmation(
            Confirmation(
              userId: userA,
              activityId: act1,
              status: ConfirmationStatus.approved,
            ),
          )
          .upsertConfirmation(
            Confirmation(
              userId: userA,
              activityId: act1,
              status: ConfirmationStatus.rejected,
            ),
          );
      expect(e.confirmations.length, 1);
      expect(e.isApprovedBy(act1, userA), isFalse);
    });

    test('un rechazo de B impide la aprobación total', () {
      final e = baseEvent()
          .upsertConfirmation(
            Confirmation(
              userId: userA,
              activityId: act1,
              status: ConfirmationStatus.approved,
            ),
          )
          .upsertConfirmation(
            Confirmation(
              userId: userB,
              activityId: act1,
              status: ConfirmationStatus.rejected,
            ),
          );
      expect(e.isFullyApprovedBy(userA, userB), isFalse);
    });
  });
}
