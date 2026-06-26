import 'package:couplesync/domain/entities/confirmation.dart';
import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/repositories/firestore_confirmation_repository.dart';
import 'package:couplesync/infrastructure/repositories/firestore_scheduled_event_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  final act1 = ActivityId('a1');

  // Evento de la semana actual para que aparezca en la agenda.
  ScheduledEvent currentWeekEvent() {
    final monday = WeekId.fromDate(DateTime.now()).mondayUtc;
    return ScheduledEvent(
      id: ScheduledEventId('e1'),
      date: monday,
      weekId: WeekId.fromDate(monday),
      activityIds: [act1],
      status: CompletionStatus.pending,
      confirmations: const [],
      createdAt: monday,
    );
  }

  MockFirebaseAuth signedIn(String uid) => MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: uid, displayName: uid),
      );

  testWidgets('la agenda muestra el evento de la semana', (tester) async {
    final db = FakeFirebaseFirestore();
    await FirestoreScheduledEventRepository(db).save(currentWeekEvent());

    await pumpApp(tester, auth: signedIn('A'), firestore: db);
    await tester.tap(find.text('Agenda').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('actividad(es)'), findsOneWidget);
    expect(find.textContaining('Pendiente'), findsOneWidget);
  });

  testWidgets('completa el evento cuando el segundo usuario aprueba',
      (tester) async {
    final db = FakeFirebaseFirestore();
    await FirestoreScheduledEventRepository(db).save(currentWeekEvent());
    // El usuario B ya aprobó previamente.
    await FirestoreConfirmationRepository(db).upsert(
      ScheduledEventId('e1'),
      Confirmation(
        userId: UserId('B'),
        activityId: act1,
        status: ConfirmationStatus.approved,
      ),
    );

    // Inicia sesión el usuario A.
    await pumpApp(tester, auth: signedIn('A'), firestore: db);
    await tester.tap(find.text('Agenda').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ListTile).first); // abre confirmaciones
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('event_status')), findsOneWidget);

    await tester.tap(find.byKey(Key('approve_${act1.value}')));
    await tester.pumpAndSettle();

    // A aprueba y, como B ya había aprobado, el evento se completa.
    expect(find.text('Evento: Completado'), findsOneWidget);
  });
}
