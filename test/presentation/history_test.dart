import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/repositories/firestore_scheduled_event_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  testWidgets('el historial lista eventos pasados con su estado', (
    tester,
  ) async {
    final db = FakeFirebaseFirestore();
    await FirestoreScheduledEventRepository(db).save(
      ScheduledEvent(
        id: ScheduledEventId('h1'),
        date: DateTime.utc(2025, 5, 10),
        weekId: WeekId.fromDate(DateTime.utc(2025, 5, 10)),
        activityIds: [ActivityId('a1')],
        status: CompletionStatus.completed,
        confirmations: const [],
        createdAt: DateTime.utc(2025, 5, 1),
      ),
    );

    await pumpApp(
      tester,
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      ),
      firestore: db,
    );
    await tester.tap(find.text('Historial').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('10/5/2025'), findsOneWidget);
    expect(find.textContaining('Completado'), findsOneWidget);
  });
}
