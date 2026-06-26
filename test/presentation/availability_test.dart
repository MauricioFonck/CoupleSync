import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      );

  testWidgets('selecciona días y guarda la disponibilidad', (tester) async {
    await pumpApp(tester, auth: signedIn());

    await tester.tap(find.text('Disponibilidad').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('weekday_1')));
    await tester.tap(find.byKey(const Key('weekday_3')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('availability_save')));
    await tester.pumpAndSettle();

    expect(find.text('Disponibilidad guardada'), findsOneWidget);
  });
}
