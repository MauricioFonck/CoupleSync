import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  testWidgets('valida campos vacíos y no navega', (tester) async {
    await pumpApp(
      tester,
      auth: MockFirebaseAuth(mockUser: MockUser(uid: 'A')),
    );

    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Email inválido'), findsOneWidget);
    expect(find.text('Introduce la contraseña'), findsOneWidget);
    // Sigue en login.
    expect(find.byKey(const Key('login_submit')), findsOneWidget);
  });

  testWidgets('login correcto navega al dashboard', (tester) async {
    await pumpApp(
      tester,
      auth: MockFirebaseAuth(
        mockUser: MockUser(uid: 'A', email: 'a@x.com', displayName: 'Ana'),
      ),
    );

    await tester.enterText(find.byKey(const Key('login_email')), 'a@x.com');
    await tester.enterText(find.byKey(const Key('login_password')), 'secret');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Ana'), findsOneWidget);
  });
}
