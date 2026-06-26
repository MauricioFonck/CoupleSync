import 'package:couplesync/application/commands/commands.dart';
import 'package:couplesync/application/queries/queries.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/composition_root.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/use_cases/_fakes.dart';

void main() {
  final userA = UserId('A');
  final userB = UserId('B');

  Availability allDays(UserId u) => Availability(
        userId: u,
        availableWeekdays: const {1, 2, 3, 4, 5, 6, 7},
        slotsByWeekday: const {},
        blockedDates: const {},
        unavailablePeriods: const [],
      );

  test('flujo end-to-end: crear actividad → generar agenda → confirmar', () async {
    final root = CompositionRoot(
      firestore: FakeFirebaseFirestore(),
      auth: MockFirebaseAuth(),
      clock: FakeClock(DateTime.utc(2026, 6, 21)),
      random: FakeRandom(),
      idGenerator: SeqIdGenerator(),
    );

    // 1) Crear actividad.
    final created = await root.activityService.create(
      CreateActivityCommand(
        title: 'Cena',
        description: 'd',
        category: ActivityCategory('Comida'),
        createdBy: userA,
      ),
    );
    expect(created.isOk, isTrue);
    expect((await root.activityService.list()).valueOrNull, hasLength(1));

    // 2) Disponibilidad de ambos.
    await root.availabilityService.set(allDays(userA));
    await root.availabilityService.set(allDays(userB));

    // 3) Generar agenda.
    final week = WeekId('2026-W26');
    final generated = await root.schedulingService.generate(
      GenerateScheduleCommand(
        targetWeek: week,
        partnerA: userA,
        partnerB: userB,
      ),
    );
    expect(generated.isOk, isTrue);
    expect(generated.valueOrNull!.eventIds, isNotEmpty);

    // 4) Confirmar la primera actividad del primer evento con ambos usuarios.
    final events =
        (await root.schedulingService.eventsOfWeek(WeekEventsQuery(week)))
            .valueOrNull!;
    final event = events.first;
    final activityId = event.activityIds.first;

    await root.confirmationService.confirm(
      ConfirmActivityCommand(
        eventId: event.id,
        userId: userA,
        activityId: activityId,
        status: ConfirmationStatus.approved,
      ),
      partnerA: userA,
      partnerB: userB,
    );
    final afterB = await root.confirmationService.confirm(
      ConfirmActivityCommand(
        eventId: event.id,
        userId: userB,
        activityId: activityId,
        status: ConfirmationStatus.approved,
      ),
      partnerA: userA,
      partnerB: userB,
    );

    expect(afterB.valueOrNull!.status, CompletionStatus.completed);
  });

  test('expone authPort funcional', () async {
    final root = CompositionRoot(
      firestore: FakeFirebaseFirestore(),
      auth: MockFirebaseAuth(
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      ),
    );
    final user = await root.authPort.signIn(email: 'a@x.com', password: 'pw');
    expect(user.id, userA);
    expect(root.notificationTokenPort, isNull); // sin messaging en test
  });
}
