import 'package:couplesync/domain/entities/scheduled_event.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/statuses.dart';
import 'package:couplesync/domain/value_objects/week_id.dart';
import 'package:couplesync/infrastructure/repositories/firestore_scheduled_event_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  ScheduledEvent event(String id, CompletionStatus status) => ScheduledEvent(
        id: ScheduledEventId(id),
        date: DateTime.utc(2025, 5, 10),
        weekId: WeekId.fromDate(DateTime.utc(2025, 5, 10)),
        activityIds: [ActivityId('a1')],
        status: status,
        confirmations: const [],
        createdAt: DateTime.utc(2025, 5, 1),
      );

  testWidgets('el dashboard muestra KPIs agregados', (tester) async {
    final db = FakeFirebaseFirestore();
    final repo = FirestoreScheduledEventRepository(db);
    await repo.save(event('e1', CompletionStatus.completed));
    await repo.save(event('e2', CompletionStatus.pending));

    await pumpApp(
      tester,
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      ),
      firestore: db,
    );
    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('kpi_scheduled')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('kpi_completed')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
  });
}
