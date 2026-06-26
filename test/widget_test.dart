// Tests de arranque + guard de autenticación (Fase 5).
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'presentation/_pump.dart';

void main() {
  testWidgets('sin sesión redirige a /login', (tester) async {
    await pumpApp(tester, auth: MockFirebaseAuth());

    expect(find.byKey(const Key('login_submit')), findsOneWidget);
    expect(find.text('CoupleSync'), findsOneWidget);
  });

  testWidgets('con sesión muestra el dashboard dentro del shell',
      (tester) async {
    await pumpApp(
      tester,
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      ),
    );

    expect(find.text('Hola, Ana'), findsOneWidget);
    expect(find.byKey(const Key('logout_button')), findsOneWidget);
  });
}
