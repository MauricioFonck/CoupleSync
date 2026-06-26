import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: 'A', displayName: 'Ana'),
      );

  Future<void> goToActivities(WidgetTester tester) async {
    await tester.tap(find.text('Actividades').first);
    await tester.pumpAndSettle();
  }

  testWidgets('crear actividad la muestra en la lista', (tester) async {
    await pumpApp(tester, auth: signedIn());
    await goToActivities(tester);

    expect(find.text('Sin actividades. Crea la primera.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('activities_add')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('activity_title')), 'Cine');
    await tester.enterText(
      find.byKey(const Key('activity_category')),
      'Ocio',
    );
    await tester.tap(find.byKey(const Key('activity_save')));
    await tester.pumpAndSettle();

    expect(find.text('Cine'), findsOneWidget);
    expect(find.text('Ocio'), findsOneWidget);
  });

  testWidgets('validación impide guardar sin título', (tester) async {
    await pumpApp(tester, auth: signedIn());
    await goToActivities(tester);

    await tester.tap(find.byKey(const Key('activities_add')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('activity_save')));
    await tester.pumpAndSettle();

    expect(find.text('Requerido'), findsWidgets);
  });

  testWidgets('eliminar quita la actividad de la lista', (tester) async {
    await pumpApp(tester, auth: signedIn());
    await goToActivities(tester);

    await tester.tap(find.byKey(const Key('activities_add')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('activity_title')), 'Cena');
    await tester.enterText(
      find.byKey(const Key('activity_category')),
      'Comida',
    );
    await tester.tap(find.byKey(const Key('activity_save')));
    await tester.pumpAndSettle();
    expect(find.text('Cena'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    expect(find.text('Cena'), findsNothing);
  });
}
