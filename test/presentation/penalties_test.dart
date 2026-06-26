import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      );

  testWidgets('crear penitencia con severidad la muestra en la lista',
      (tester) async {
    await pumpApp(tester, auth: signedIn());

    await tester.tap(find.text('Penitencias').first);
    await tester.pumpAndSettle();
    expect(find.text('Sin penitencias. Crea la primera.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('penalties_add')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('penalty_title')),
      'Lavar platos',
    );
    await tester.tap(find.byKey(const Key('penalty_save')));
    await tester.pumpAndSettle();

    expect(find.text('Lavar platos'), findsOneWidget);
    expect(find.textContaining('Severidad'), findsOneWidget);
  });
}
