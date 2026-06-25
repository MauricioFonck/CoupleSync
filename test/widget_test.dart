// Smoke test del scaffolding inicial (Fase 1).
//
// Firebase solo se inicializa en `main()`, no en `build()`, por lo que montar
// `CoupleSyncApp` directamente no requiere Firebase.
import 'package:couplesync/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app arranca y muestra la marca CoupleSync', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: CoupleSyncApp()));

    expect(find.text('CoupleSync'), findsOneWidget);
    expect(find.text('Fase 1 — scaffolding inicial'), findsOneWidget);
  });
}
