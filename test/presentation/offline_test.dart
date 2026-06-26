import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(uid: 'A', displayName: 'Ana'),
  );

  testWidgets('muestra el banner offline cuando no hay conexión', (
    tester,
  ) async {
    await pumpApp(tester, auth: signedIn(), online: false);
    expect(find.byKey(const Key('offline_banner')), findsOneWidget);
  });

  testWidgets('oculta el banner cuando hay conexión', (tester) async {
    await pumpApp(tester, auth: signedIn());
    expect(find.byKey(const Key('offline_banner')), findsNothing);
  });
}
