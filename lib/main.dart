import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'infrastructure/composition_root.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/theme/app_theme.dart';

/// reCAPTCHA v3 site key para App Check (web). `--dart-define=RECAPTCHA_V3_SITE_KEY=...`.
const String _recaptchaV3SiteKey = String.fromEnvironment(
  'RECAPTCHA_V3_SITE_KEY',
);

/// VAPID key para tokens FCM web. `--dart-define=FCM_VAPID_KEY=...`.
const String _fcmVapidKey = String.fromEnvironment('FCM_VAPID_KEY');

/// Permite mostrar SnackBars (p. ej. push en primer plano) desde fuera del árbol.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (_recaptchaV3SiteKey.isNotEmpty) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(_recaptchaV3SiteKey),
    );
  }

  // Persistencia offline (IndexedDB en web) — D4.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // Mensajes FCM en primer plano → SnackBar (recepción; el envío es externo, D3).
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          notification.title ?? notification.body ?? 'Notificación',
        ),
      ),
    );
  });

  final compositionRoot = CompositionRoot(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    messaging: FirebaseMessaging.instance,
    fcmVapidKey: _fcmVapidKey.isEmpty ? null : _fcmVapidKey,
  );

  runApp(
    ProviderScope(
      overrides: [compositionRootProvider.overrideWithValue(compositionRoot)],
      child: const CoupleSyncApp(),
    ),
  );
}

class CoupleSyncApp extends ConsumerWidget {
  const CoupleSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'CoupleSync',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
