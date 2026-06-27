import 'package:couplesync/domain/entities/roulette_item.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/infrastructure/repositories/firestore_roulette_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '_pump.dart';

void main() {
  MockFirebaseAuth signedIn() => MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(uid: 'A', displayName: 'Ana'),
  );

  Future<void> goToRoulette(WidgetTester tester) async {
    await tester.tap(find.text('Ruleta').first);
    await tester.pumpAndSettle();
  }

  testWidgets('ruleta vacía ofrece importar', (tester) async {
    await pumpApp(tester, auth: signedIn());
    await goToRoulette(tester);
    expect(find.text('La ruleta está vacía.'), findsOneWidget);
  });

  testWidgets('sacar 20 y girar revela un resultado', (tester) async {
    final db = FakeFirebaseFirestore();
    final repo = FirestoreRouletteRepository(db);
    for (final id in ['r1', 'r2', 'r3']) {
      await repo.save(
        RouletteItem(id: RouletteItemId(id), text: 'Idea $id', favorite: false),
      );
    }

    await pumpApp(tester, auth: signedIn(), firestore: db);
    await goToRoulette(tester);

    await tester.tap(find.byKey(const Key('roulette_draw')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('roulette_spin')));
    // La animación usa timers encadenados; bombeamos con duraciones fijas hasta
    // que termine (pumpAndSettle falla por los huecos entre frames).
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    // Tras girar, ya no se muestra el texto de instrucción inicial.
    expect(find.text('Pulsa "Sacar 20" y luego "Girar"'), findsNothing);
    expect(find.byKey(const Key('roulette_card')), findsOneWidget);
  });

  testWidgets('importar ideas las añade al pool', (tester) async {
    await pumpApp(tester, auth: signedIn());
    await goToRoulette(tester);

    await tester.tap(find.byKey(const Key('roulette_manage')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('roulette_import')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('roulette_import_text')),
      'Idea uno\nIdea dos\n\nIdea tres',
    );
    await tester.tap(find.byKey(const Key('roulette_import_confirm')));
    await tester.pumpAndSettle();

    expect(find.text('Idea uno'), findsOneWidget);
    expect(find.text('Idea tres'), findsOneWidget);
  });
}
