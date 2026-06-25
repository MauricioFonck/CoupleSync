import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

/// reCAPTCHA v3 site key for Firebase App Check (web).
///
/// Se inyecta en build/run para no commitearla:
///   flutter run -d chrome --dart-define=RECAPTCHA_V3_SITE_KEY=xxxx
///
/// Por defecto vacía, de modo que la app arranca en desarrollo sin que App
/// Check bloquee el inicio (ver Plan 1.6 y docs/SECURITY.md).
const String _recaptchaV3SiteKey =
    String.fromEnvironment('RECAPTCHA_V3_SITE_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check solo se activa cuando hay site key, para no bloquear el arranque
  // local. En producción la key se inyecta vía --dart-define.
  if (_recaptchaV3SiteKey.isNotEmpty) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(_recaptchaV3SiteKey),
    );
  }

  runApp(const ProviderScope(child: CoupleSyncApp()));
}

/// Root widget. El theme Material 3 definitivo, el router y los providers se
/// construyen en la Fase 5; aquí solo hay un scaffolding mínimo (Plan 1.7).
class CoupleSyncApp extends StatelessWidget {
  const CoupleSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoupleSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE91E63)),
        useMaterial3: true,
      ),
      home: const _BootstrapScreen(),
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text('CoupleSync', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Fase 1 — scaffolding inicial',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
