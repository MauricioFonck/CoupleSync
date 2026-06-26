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

## Notas de implementación (Fase 4)
- **Timestamps como ISO-8601 del cliente:** los DTOs guardan fechas como string
  ISO-8601 generado vía `ClockPort`, no como `Timestamp`/server timestamp de
  Firestore. Mantiene los DTOs `json`-puros y los mappers triviales y testeables
  con `fake_cloud_firestore`. Para 2 usuarios, last-write-wins con `updatedAt` de
  cliente es suficiente (D4). Migrar a server timestamps es un refinamiento
  aislado al repositorio si hiciera falta.
- **Tests sin emulador:** se usa `fake_cloud_firestore` (Firestore in-memory) y
  `firebase_auth_mocks` en lugar de Firebase Emulator Suite (no disponible en el
  entorno de desarrollo). Cubren CRUD, guard transaccional y confirmaciones.
- Archivos generados (`*.freezed.dart`, `*.g.dart`) se commitean para builds
  reproducibles sin requerir `build_runner` en cada checkout.
