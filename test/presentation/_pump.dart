import 'package:couplesync/infrastructure/composition_root.dart';
import 'package:couplesync/main.dart';
import 'package:couplesync/presentation/providers/app_providers.dart';
import 'package:couplesync/presentation/providers/connectivity_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/use_cases/_fakes.dart';

/// Monta `CoupleSyncApp` con un Composition Root de prueba (fake Firestore +
/// auth mock) y espera a que el router resuelva el guard.
Future<MockFirebaseAuth> pumpApp(
  WidgetTester tester, {
  required MockFirebaseAuth auth,
  FakeFirebaseFirestore? firestore,
  bool online = true,
}) async {
  final root = CompositionRoot(
    firestore: firestore ?? FakeFirebaseFirestore(),
    auth: auth,
    clock: FakeClock(DateTime.utc(2026, 6, 21)),
    random: FakeRandom(),
    idGenerator: SeqIdGenerator(),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        compositionRootProvider.overrideWithValue(root),
        isOnlineProvider.overrideWithValue(online),
      ],
      child: const CoupleSyncApp(),
    ),
  );
  await tester.pumpAndSettle();
  return auth;
}
