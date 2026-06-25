// Firebase options for CoupleSync (web target only).
//
// Escrito a mano (sin FlutterFire CLI) con la configuración del proyecto
// `couplesync-cb0a8` (plan Spark / gratis).
//
// IMPORTANTE:
// - `storageBucket` se OMITE intencionalmente: Cloud Storage exige plan Blaze
//   y el proyecto se mantiene en Spark. Las imágenes van en Base64 (ver §5).
// - La API key web NO es secreta; la protección real es Security Rules +
//   App Check + restricción de la key por HTTP referrer (ver docs/SECURITY.md).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for CoupleSync.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  /// Returns the options for the current platform.
  ///
  /// Only the web target is supported in this stage (PWA). Native targets
  /// throw on purpose to keep the scope explicit.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'CoupleSync solo soporta el target web en esta etapa. '
      'Plataforma no soportada: $defaultTargetPlatform',
    );
  }

  /// Web configuration for project `couplesync-cb0a8`.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCpu_NMcONHAr2qVnv3x58A5z8nEhpi-VA',
    authDomain: 'couplesync-cb0a8.firebaseapp.com',
    projectId: 'couplesync-cb0a8',
    messagingSenderId: '678018643671',
    appId: '1:678018643671:web:680d520e538abb460f2292',
    measurementId: 'G-BDDRF6SGTH',
    // storageBucket: OMITIDO (plan Spark, sin Cloud Storage).
  );
}
