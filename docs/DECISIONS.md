# Decisiones Arquitectónicas (ADR resumido) — CoupleSync

Las decisiones completas con su justificación viven en
[`docs/ROADMAP.md`](./ROADMAP.md#resumen-de-decisiones-arquitectónicas). Este archivo es
un índice rápido.

| ID | Decisión | Resultado |
|----|----------|-----------|
| **D1** | Almacenamiento de imágenes (§5) | **Firestore para todo**, colección dedicada `media/{mediaId}`; las entidades referencian `imageId`. Base64 comprimido ≤ ~300 KB. (No se usa Realtime Database.) |
| **D2** | Generación semanal (§6) | **Lazy generation** en cliente al abrir la app + **guard transaccional** `weeklySchedules/{año-Wsemana}`. |
| **D3** | Notificaciones (§6) | **GitHub Actions (cron) + Node + `firebase-admin`** con service account como *secret*. Solo lee Firestore y envía FCM. Carpeta `automation/`. |
| **D4** | Offline (§6) | Firestore offline persistence (IndexedDB, `synchronizeTabs`); conflictos last-write-wins mitigados con `updatedAt` y escrituras a campos disjuntos. |
| **D5** | Seguridad de la API key (§0.1) | Security Rules + App Check (reCAPTCHA v3) + restricción por HTTP referrer. Ver `docs/SECURITY.md`. |
| **D6** | Sin Storage / sin Functions | Plan **Spark**: no se inicializa Cloud Storage ni se usan Cloud Functions. |

## Notas de implementación (Fase 1)
- `freezed` se fijó en la preview `3.2.6-dev.1` porque la cadena estable `3.2.x` depende
  de `source_gen ^3`, incompatible con `json_serializable 6.14` (estable actual, requiere
  `source_gen ^4`) bajo Dart 3.12. Revisar al subir el SDK/paquetes. (Riesgo aceptado.)
- `firebase_options.dart` se escribió a mano (sin FlutterFire CLI) y **omite**
  `storageBucket` a propósito (D6).
- App Check se activa solo si se provee `RECAPTCHA_V3_SITE_KEY` vía `--dart-define`.
