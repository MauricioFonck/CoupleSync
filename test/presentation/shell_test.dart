import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      );

  testWidgets('navega entre destinos del shell', (tester) async {
    await pumpApp(tester, auth: signedIn());

    expect(find.text('Hola, Ana'), findsOneWidget);

    await tester.tap(find.text('Historial').first);
    await tester.pumpAndSettle();
    expect(find.text('Sin historial todavía.'), findsOneWidget);
  });

  testWidgets('usa NavigationBar en pantallas compactas', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpApp(tester, auth: signedIn());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('usa NavigationRail en pantallas anchas', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpApp(tester, auth: signedIn());

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
