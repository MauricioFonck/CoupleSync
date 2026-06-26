# CoupleSync — ROADMAP de Implementación

> **Estado:** PASO 1 — Plan de implementación (sin código).
> Este documento es la **fuente de verdad del progreso**. Se actualiza en cada paso posterior.

---

## Convención de seguimiento

- Una tarea se marca `- [x]` **solo** cuando está **implementada Y probada** (compila, pasa lint y pasa sus tests donde aplique).
- Al cerrar cada **Plan** se hace **un commit** con el prefijo del plan. Ej.: `feat(fase2-plan2.1): value objects de dominio`.
- **Un commit por Plan cerrado** (no por tarea suelta).
- **Identidad de git** (configurar antes del primer commit, en Fase 1):
  ```bash
  git config user.name "MauricioFonck"
  git config user.email "mauricioandresvergarafonseca@gmail.com"
  ```
- **PROHIBIDO** añadir coautoría o trailers de herramienta. El mensaje de commit contiene **solo** la descripción del cambio. Nada de `Co-Authored-By:`, `Co-authored-by: Claude ...`, ni `🤖 Generated with Claude Code`.
- Todos los commits van **exclusivamente** a nombre de Mauricio.
- Las tareas que dependen de una **decisión pendiente** se marcan con **⚠️ DECISIÓN**.
- Las tareas que tocan **infraestructura externa** (Firebase Console, Google Cloud Console, GitHub) se marcan con **🔧 MANUAL** (requieren acción humana fuera del repo).

### Leyenda de marcadores
| Marcador | Significado |
|---|---|
| ⚠️ DECISIÓN | Depende de una decisión arquitectónica documentada (§5/§6). |
| 🔧 MANUAL | Acción humana en consola externa (Firebase/GCP/GitHub), no automatizable desde el repo. |
| 🔒 SEGURIDAD | Tarea con impacto directo en seguridad/credenciales. |

---

## Resumen de decisiones arquitectónicas

### Decisión D1 — Almacenamiento de imágenes (§5)

**Opciones:** (A) Firestore para todo · (B) Firestore para metadatos + Realtime Database solo para blobs Base64.

**✅ Recomendación: Opción A — Firestore para todo, con una colección dedicada `media/{mediaId}`.**

**Justificación:**
- **Simplicidad / KISS:** una sola base de datos, un solo modelo de seguridad (un único set de Security Rules), una sola configuración de persistencia offline y un solo SDK. Introducir RTDB añadiría una segunda base que asegurar, un segundo modelo offline y más superficie de mantenimiento, sin beneficio para 2 usuarios.
- **Costo/límites en Spark:** para **exactamente 2 usuarios**, los límites de Firestore (50K lecturas/día, 20K escrituras/día, 1 GiB almacenado) son holgadísimos. No hay presión de cuota que justifique mover blobs a RTDB.
- **El problema real (no descargar blobs al listar) ya se resuelve** separando el blob en su propia colección `media/{mediaId}` y guardando solo `imageId` en la entidad. Listar actividades/penitencias nunca trae el Base64.
- **Control de tamaño:** el pipeline de compresión (redimensionado a ~800–1000px lado mayor + JPEG/WebP calidad 70–80%) deja el Base64 con objetivo **≤ ~300 KB**, muy por debajo del límite de **1 MiB/documento** de Firestore. Se valida el tamaño **antes** de escribir y se rechaza si excede un umbral de guarda (ej. 700 KB).

**Implicaciones de diseño:**
- Colección `media/{mediaId}` con campos: `{ id, base64, mime, width, height, byteSize, ownerEntityType, ownerEntityId?, createdBy, createdAt }`.
- Las entidades (`Activity`, `Penalty`, …) referencian `imageId?` (nullable).
- Port de dominio `MediaRepositoryPort` con `save(MediaBlob)`, `getById(MediaId)`, `delete(MediaId)`.
- Borrado de huérfanos: al eliminar/actualizar la imagen de una entidad, se borra el blob asociado (limpieza explícita en el caso de uso).

> Si en el futuro creciera el volumen de imágenes, migrar blobs a RTDB (o a Storage con Blaze) es un cambio **aislado al adaptador de infraestructura** gracias al port; el dominio no se entera.

### Decisión D2 — Generación semanal automática (§6) — *Lazy generation* en cliente

**✅ Fijada por el prompt. Confirmada.**
- Al **abrir la app** (cualquiera de A o B), un servicio comprueba si existe la agenda de la semana objetivo. Si la fecha actual es **domingo o posterior** y la agenda aún no existe, dispara `GenerateWeeklyScheduleUseCase` y persiste.
- **Guard transaccional:** documento `weeklySchedules/{año-Wsemana}` (ISO week, ej. `2026-W26`) creado dentro de una **transacción Firestore** para evitar doble generación si A y B abren a la vez. El primero que crea el doc gana; el segundo aborta sin duplicar.
- La lógica vive en el **dominio** (`GenerateWeeklyScheduleUseCase`); el disparo es el único elemento "cliente".

### Decisión D3 — Notificaciones (§6) — GitHub Actions + `firebase-admin`

**✅ Fijada por el prompt. Confirmada.**
- **Workflow programado (cron) de GitHub Actions** ejecuta un script **Node** con `firebase-admin`, autenticado con una **service account** guardada como **secret del repo** (🔒 nunca commiteada).
- El script **solo lee Firestore y envía FCM** (recordatorios diarios, confirmaciones pendientes, resumen semanal del domingo, aviso "nueva semana, abre la app"). **No** reimplementa reglas de negocio.
- Vive en `/automation`, **fuera** de las 4 capas de Flutter.
- **DRY:** la generación NO se duplica en Node. Si en el futuro se quisiera generación 100% desatendida, se ejecutaría un job **Dart** en CI reutilizando `GenerateWeeklyScheduleUseCase` con un adaptador Firestore server-side.

### Decisión D4 — Estrategia offline (§6)

**✅ Recomendación: Firestore offline persistence habilitada en web (IndexedDB) con `synchronizeTabs`.**
- Lecturas servidas desde caché local cuando no hay red; escrituras encoladas y reenviadas al reconectar.
- **Conflictos:** modelo *last-write-wins* de Firestore. Se mitiga con `updatedAt` (server timestamp) y diseño de documentos con escrituras a campos disjuntos cuando es posible.
- Las **confirmaciones** (A y B) se escriben en campos/documentos separados por usuario para evitar pisarse mutuamente.
- La **generación semanal** está protegida por la transacción del guard (D2), por lo que el offline no genera duplicados (la transacción requiere conectividad para confirmar).

### Decisión D5 — Seguridad de la API key web (§0.1)

- La API key web **no es secreta**. La protección real es: **Security Rules** + **Firebase App Check** + **restricción de la key por HTTP referrer** en Google Cloud Console.
- App Check con proveedor **reCAPTCHA v3** (o reCAPTCHA Enterprise) para web. Tareas incluidas en Fase 1 y reforzadas en Fase 10.

### Decisión D6 — Sin `storageBucket`, sin Cloud Functions

- **Firebase Storage: NO** se inicializa ni se invoca (exige Blaze). Imágenes en Base64 (D1).
- **Cloud Functions: NO** (exige Blaze). Sustituido por D2 (lazy generation) + D3 (GitHub Actions).
- `measurementId` (Analytics): **opcional**; se incluye solo si no añade complejidad.

---

## Mapa de fases y dependencias

| Fase | Nombre | Depende de |
|---|---|---|
| 1 | Fundamentos y Setup | — |
| 2 | Dominio | 1 |
| 3 | Aplicación | 2 |
| 4 | Infraestructura & Adaptadores | 2, 3 |
| 5 | Presentación base | 4 |
| 6 | Módulos funcionales UI | 5 |
| 7 | Lógica avanzada (generador, rachas, stats) | 4, 6 |
| 8 | Dashboard & gráficas | 7 |
| 9 | Notificaciones (GitHub Actions + firebase-admin) | 4, 7 |
| 10 | Seguridad (Security Rules) | 4, 6 |
| 11 | PWA completa & offline | 5 |
| 12 | Testing & Calidad (≥80%) | 2–11 |
| 13 | Producción & Deploy | 1–12 |

---

# Fase 1 — Fundamentos y Setup
**Dependencias:** ninguna · **Entregables:** repo conectado a GitHub, proyecto Flutter web con estructura hexagonal vacía, dependencias resueltas, Firebase (Auth/Firestore/FCM) configurado sin Storage/Functions, App Check + restricción de key, decisiones §5/§6 documentadas (este ROADMAP), scaffolding PWA inicial corriendo.

### Plan 1.1 — Inicialización de repositorio e identidad
- [x] Crear proyecto Flutter web: `flutter create --platforms web couplesync` (o configurar el existente).
- [x] 🔒 Configurar identidad git local: `git config user.name "MauricioFonck"` y `git config user.email "mauricioandresvergarafonseca@gmail.com"`.
- [x] Crear `.gitignore` adecuado para Flutter + excluir `**/serviceAccount*.json`, `*.env`, `automation/node_modules`, claves y secrets.
- [x] Conectar remoto y primer push (hecho: `main` rastrea `origin/main`, 14 commits subidos):
  ```bash
  git remote add origin https://github.com/MauricioFonck/CoupleSync.git
  git branch -M main
  git push -u origin main
  ```
- [x] Verificar que el commit inicial **no** contiene trailers de coautoría. *(Verificado: historial sin `Co-authored-by`/`Generated with`.)*

### Plan 1.2 — Estructura hexagonal de carpetas
- [x] Crear `lib/domain/{entities,value_objects,ports,use_cases,exceptions}/` (con `.gitkeep`).
- [x] Crear `lib/application/{services,commands,queries}/`.
- [x] Crear `lib/infrastructure/{firebase,repositories,datasources,notifications,authentication,media}/`.
- [x] Crear `lib/presentation/{screens,widgets,providers,routes,theme}/`.
- [x] Crear `automation/` (script Node de notificaciones) y `docs/`.
- [x] Documentar en `docs/ARCHITECTURE.md` la regla de dependencias (todo apunta al dominio) y qué puede importar cada capa.

### Plan 1.3 — Linting y calidad de código
- [x] Añadir `flutter_lints` y configurar `analysis_options.yaml` (linting estricto: strict-casts/raw-types, package-imports como error).
- [x] Añadir regla/guía que prohíba imports de Firebase/Flutter dentro de `lib/domain/**` (documentada en `docs/ARCHITECTURE.md`; test de arquitectura en Fase 12).
- [x] Configurar `dart format` y verificar `flutter analyze` sin warnings. *(`No issues found!`)*

### Plan 1.4 — Dependencias (versiones estables actuales)
- [x] Verificar y fijar versiones estables actuales de: `flutter_riverpod` 3.3.2, `go_router` 17.3.0, `firebase_core` 4.11.0, `firebase_auth` 6.5.4, `cloud_firestore` 6.6.0, `firebase_messaging` 16.4.1, `firebase_app_check` 0.4.5, `fl_chart` 1.2.0.
- [x] Verificar y fijar: `freezed` 3.2.6-dev.1 *(ver nota)*, `freezed_annotation` 3.1.0, `json_serializable` 6.14.0, `json_annotation` 4.12.0, `build_runner` 2.15.0.
- [x] Verificar **soporte web** de `image_picker` y elegirlo (1.2.2, con soporte web).
- [x] Añadir paquete de procesamiento de imágenes **compatible con web** (`image` 4.9.1, Dart puro) — **NO** `flutter_image_compress`.
- [x] Añadir dev deps de test: `mocktail` 1.0.5, `flutter_test` (SDK). *(`integration_test` se añadirá en Fase 12.)*
- [x] Ejecutar `flutter pub get` y confirmar resolución sin conflictos.
  > ⚠️ **Nota (riesgo aceptado):** `freezed` se fija en la preview `3.2.6-dev.1` porque la cadena estable `3.2.x` depende de `source_gen ^3`, incompatible con `json_serializable 6.14` (requiere `source_gen ^4`) bajo Dart 3.12. Revisar al actualizar SDK/paquetes. Ver `docs/DECISIONS.md`.

### Plan 1.5 — Configuración Firebase (Auth/Firestore/FCM, sin Storage/Functions)
- [x] Crear `FirebaseOptions` manualmente (`lib/firebase_options.dart`, web-only) con los valores del proyecto `couplesync-cb0a8`. *(FlutterFire CLI no instalado; el prompt permite la vía manual.)*
- [x] 🔒 Confirmar que **NO** se incluye/usa `storageBucket` y **NO** se inicializa Firebase Storage. *(Omitido a propósito en `firebase_options.dart`.)*
- [x] Inicializar `Firebase.initializeApp` en el arranque (`lib/main.dart`).
- [ ] 🔧 MANUAL (pendiente — Firebase Console): crear **manualmente** los 2 usuarios (A y B) en Authentication (email/password). Sin registro público.
- [ ] 🔧 MANUAL (pendiente — Firebase Console): habilitar Cloud Firestore (modo producción) y FCM.
- [ ] Habilitar persistencia offline de Firestore para web (⚠️ DECISIÓN D4). *(Se cablea junto al datasource en Fase 4.3.)*
- [ ] (Opcional) Integrar Analytics solo si no añade complejidad. *(Pospuesto; no aporta valor en Fase 1.)*

### Plan 1.6 — App Check y restricción de API key 🔒
- [ ] 🔧 MANUAL (pendiente — Firebase Console): registrar la app web en **App Check** con proveedor reCAPTCHA v3/Enterprise (⚠️ DECISIÓN D5) y obtener la site key.
- [x] Integrar `firebase_app_check` en el cliente y activarlo en el arranque. *(Activación guardada por `--dart-define=RECAPTCHA_V3_SITE_KEY`; no bloquea el arranque si está vacía.)*
- [ ] 🔧 MANUAL (pendiente — Google Cloud Console): restringir la API key web por **HTTP referrer** (dominios de hosting + localhost).
- [x] Documentar el procedimiento en `docs/SECURITY.md`.

### Plan 1.7 — Scaffolding PWA inicial
- [x] Configurar `web/manifest.json` (nombre CoupleSync, iconos, theme `#E91E63`/background `#FFFFFF`, display `standalone`).
- [x] Actualizar `web/index.html` (título/descripción) y pantalla placeholder de arranque. *(Build web verificado: `√ Built build\web`.)*
- [x] Confirmar que la PWA compila y App Check no bloquea el arranque. *(Sin site key, App Check no se activa.)*

### Plan 1.8 — Documentación de decisiones (§5/§6)
- [x] Crear `docs/ROADMAP.md` con convención de seguimiento, decisiones D1–D6 y todas las fases (este documento).
- [x] Crear `docs/DECISIONS.md` (ADR breve) enlazando a las secciones de decisiones de este ROADMAP.

**Definition of Done — Fase 1**
- [x] Repo en GitHub (`main`) con identidad correcta y sin trailers de coautoría. *(Push hecho; `main` rastrea `origin/main`.)*
- [x] `flutter analyze` limpio y estructura hexagonal creada.
- [ ] App arranca en Chrome con Firebase inicializado (Auth/Firestore/FCM), **sin** Storage ni Functions. *(Build web OK; arranque end-to-end requiere los pasos MANUAL de la consola: usuarios A/B, habilitar Firestore/FCM.)*
- [ ] App Check activo y API key restringida por referrer (verificado). *(Integrado en cliente; **faltan los pasos MANUAL** de consola: site key + referrer.)*
- [x] Decisiones D1–D6 documentadas en `docs/`.

---

# Fase 2 — Dominio
**Dependencias:** Fase 1 completa · **Entregables:** capa `domain/` en Dart puro con tests verdes ≥80%.

### Plan 2.1 — Value Objects ✅
- [x] Definir VOs inmutables: `UserId`, `ActivityId`, `PenaltyId`, `MediaId`, `ScheduledEventId`, `WeekId` (ISO `año-Wsemana`, con `fromDate` y días de la semana).
- [x] Definir VOs de negocio: `DateRange`, `TimeSlot`, `Severity`, `ActivityCategory`, `CompletionStatus`, `ConfirmationStatus` (+ `SchedulingConfig`).
- [x] Implementar validación e invariantes (el constructor falla ante valores inválidos → lanza excepción de dominio).
- [x] Tests unitarios de cada VO (casos válidos e inválidos).

### Plan 2.2 — Entidades ✅
- [x] Modelar `User` (A/B), `Activity` (`id,title,description,category,createdBy,active,imageId?,createdAt,updatedAt`).
- [x] Modelar `Penalty` (`id,title,description,severity,active,imageId?`).
- [x] Modelar `Availability` (días disponibles, horarios, fechas bloqueadas, periodos de indisponibilidad) + `isDayAvailable`.
- [x] Modelar `WeeklySchedule`, `ScheduledEvent` (`id,date,activities,status,confirmations,notes,createdAt`; estados `pending|completed|missed|rescheduled`).
- [x] Modelar `Confirmation` (por usuario y actividad: `pending|approved|rejected`) + `MediaBlob` (D1).
- [x] Modelar `StreakStats` (racha actual, mejor racha, cumplimiento semanal/mensual/anual).
- [x] Regla interna: `ScheduledEvent` se completa **solo si A y B aprueban** (`isFullyApprovedBy`).
- [x] Tests unitarios de cada entidad (incl. reglas de transición de estado).

### Plan 2.3 — Excepciones de dominio ✅
- [x] Definir jerarquía **sellada** (`DomainException` base + validación, invariante, no-encontrado, conflicto de generación).
- [x] Tests de que los casos de uso lanzan las excepciones correctas.

### Plan 2.4 — Ports (interfaces) ✅
- [x] Definir ports de repositorio: `Activity`, `Penalty`, `Availability`, `WeeklySchedule`, `ScheduledEvent`, `Confirmation`, `Media`, `Statistics`, `Settings`.
- [x] Definir ports de servicios: `AuthPort`, `ClockPort`, `RandomPort`, `NotificationTokenPort`, `IdGeneratorPort`.
- [x] Confirmar que **ningún** port importa Firebase/Flutter (solo entidades/VOs de dominio).

### Plan 2.5 — Use Cases ✅
- [x] CRUD de actividades: crear/editar/activar/desactivar/eliminar.
- [x] CRUD de penitencias.
- [x] Gestión de disponibilidad (set/get por usuario).
- [x] `GenerateWeeklyScheduleUseCase`: disponibilidad de ambos → actividades activas → restricciones (aleatoriedad vía `RandomPort`, respeta disponibilidad, evita repeticiones consecutivas, mantiene variedad, nº días/semana y nº actividades/día configurables) → persiste con guard atómico.
- [x] `ConfirmActivityUseCase` (A/B): registra confirmación y completa el evento **solo si ambos aprueban** (`CompleteEvent` integrado aquí).
- [x] `RescheduleEventUseCase` (reprogramación manual).
- [x] `GeneratePenaltyUseCase` (selección aleatoria de penitencia activa).
- [x] `CalculateStreaksUseCase` (racha actual, mejor, cumplimiento semanal/mensual/anual).
- [x] Tests unitarios de todos los use cases con dobles de prueba in-memory + `ClockPort`/`RandomPort` deterministas.

**Definition of Done — Fase 2**
- [x] `domain/` no importa Flutter/Firebase/Riverpod (solo `package:collection`, Dart puro; test de arquitectura automatizado en Fase 12).
- [x] Cobertura de dominio ≥ 80%. *(Medida: **95.0%**, 512/539 líneas.)*
- [x] Todos los tests de dominio en verde. *(89 tests.)*
- [x] `GenerateWeeklyScheduleUseCase` y `CalculateStreaksUseCase` cubiertos con casos límite.

---

# Fase 3 — Aplicación
**Dependencias:** Fase 2 · **Entregables:** capa `application/` que orquesta el dominio, con tests.

### Plan 3.1 — Services de orquestación ✅
- [x] `ActivityService`, `PenaltyService`, `AvailabilityService` que componen use cases.
- [x] `SchedulingService` (orquesta generación semanal + reprogramación + eventos de la semana).
- [x] `ConfirmationService` (orquesta confirmaciones y cierre de eventos).
- [x] `StatisticsService` (orquesta cálculo de rachas + snapshot persistido).

### Plan 3.2 — Commands y Queries ✅
- [x] Definir commands (escritura) y queries (lectura) como objetos de entrada de la capa.
- [x] Mapear errores de dominio a `Result<T>` (`Ok`/`Err`) con `AppFailure`/`FailureKind` vía `runCatching`. Convención documentada en `docs/ARCHITECTURE.md`.
- [x] Tests de orquestación (Ok/Err, mapeo de fallos, regla "ambos aprueban").

**Definition of Done — Fase 3**
- [x] `application/` solo depende de `domain/` (verificado; sin imports de Firebase/Flutter).
- [x] Tests de services en verde. *(Cobertura application 80.4%; total 105 tests.)*
- [x] Convención de manejo de errores documentada (`docs/ARCHITECTURE.md`).

---

# Fase 4 — Infraestructura & Adaptadores
**Dependencias:** Fases 2 y 3 · **Entregables:** adaptadores concretos (Firebase) implementando los ports, mappers Freezed, Composition Root/DI.

### Plan 4.1 — Autenticación ✅
- [x] Implementar `FirebaseAuthAdapter` (`AuthPort`): login email/password A o B, logout, estado de sesión.
- [x] Manejo de errores de auth → `DomainValidationException` (la capa de aplicación lo mapea a `AppFailure`).
- [x] Tests del adaptador con `firebase_auth_mocks`.

### Plan 4.2 — DTOs y Mappers (Freezed + json_serializable) ✅
- [x] DTOs Freezed para cada entidad/colección con `fromJson/toJson` (12 DTOs).
- [x] Mappers DTO ↔ Dominio (extensiones; los tipos de Firestore no cruzan al dominio).
- [x] Ejecutar `build_runner` y verificar generación (.freezed.dart/.g.dart commiteados).
- [x] Tests de round-trip de mappers (dominio→DTO→dominio + json).

### Plan 4.3 — Repositorios Firestore ✅
- [x] Implementar repos Firestore para `activities, penalties, availability, weeklySchedules, scheduledEvents, confirmations, statistics, settings, media`. *(`notifications`/`auditLogs` se añadirán cuando se usen — Fases 9/10.)*
- [x] `WeeklyScheduleRepository`: guard `weeklySchedules/{weekId}` dentro de **transacción** (D2); confirmaciones hidratadas desde subcolección (D4).
- [~] Timestamps: se persisten como ISO-8601 del cliente (vía `ClockPort`). *(Server timestamps de Firestore = refinamiento futuro; ver nota en `docs/DECISIONS.md`.)*
- [x] Tests con **`fake_cloud_firestore`** (in-memory) en vez del emulador (no disponible en este entorno; cubre CRUD, guard y confirmaciones).

### Plan 4.4 — Adaptador de Media (compresión web + Base64) ✅ ⚠️ D1
- [x] Pipeline web-compatible (`image` Dart puro): redimensiona lado mayor a ≤1000px, comprime JPEG calidad 80, codifica Base64 (`ImageMediaProcessor`/`MediaProcessorPort`).
- [x] Valida `byteSize` antes de escribir (el constructor de `MediaBlob` rechaza > 700 KB).
- [x] `FirestoreMediaRepository` (`MediaRepositoryPort`) sobre colección `media/{mediaId}` separada.
- [~] Limpieza de blobs huérfanos: se hará en los casos de uso de UI al cambiar/eliminar imagen (Fase 6).
- [x] Tests del pipeline (redimensionado, no-amplía, rechazo de bytes inválidos).

### Plan 4.5 — FCM (recepción y tokens) ✅
- [x] `FcmNotificationTokenAdapter` (`NotificationTokenPort`): token web (VAPID) y persistencia en `users/{uid}.fcmTokens` (arrayUnion/Remove).
- [ ] Manejo de recepción en foreground/background (service worker FCM en web) — se completa en Fase 9.
- [~] Tests: la obtención de token usa `FirebaseMessaging` (plugin, no mockeable sin Firebase); la persistencia de tokens se valida en Fase 9.

### Plan 4.6 — Composition Root / DI ✅ 🔒
- [x] Centralizar el wiring (ports→adaptadores) en `infrastructure/composition_root.dart`.
- [x] Adaptadores de sistema reales: `SystemClock`, `DartRandom`, `UuidIdGenerator`.
- [ ] Exponer providers Riverpod que inyectan el `CompositionRoot` a presentación — Fase 5.
- [x] Verificar que `presentation/` no importa Firebase directamente (se mantiene en Fase 5).

**Definition of Done — Fase 4**
- [x] Todos los ports tienen adaptador concreto y tests (mocks/fakes) en verde. *(124 tests totales.)*
- [x] Mappers con round-trip verificado.
- [x] Pipeline de media produce Base64 < umbral y guarda en colección separada.
- [x] Composition Root inyecta todo y un test end-to-end recorre crear→generar→confirmar sobre fake Firestore. *(Providers Riverpod en Fase 5.)*

---

# Fase 5 — Presentación base
**Dependencias:** Fase 4 · **Entregables:** theme Material 3, navegación, providers, login y shell responsive.

### Plan 5.1 — Theme Material 3 ✅
- [x] `AppTheme` con `ColorScheme.fromSeed` (light/dark) y componentes base en `presentation/theme/`.
- [x] `Breakpoints` responsive (compact/medium/expanded).

### Plan 5.2 — Navegación (Go Router) ✅
- [x] `go_router` con **guard de autenticación** (redirige a `/login` sin sesión; a `/dashboard` con sesión) y `refreshListenable` ligado a `authStateProvider`.
- [x] Rutas base: `/login`, `/dashboard`, `/activities`, `/penalties`, `/availability`, `/schedule`, `/history` (con `ShellRoute`).

### Plan 5.3 — Providers Riverpod base ✅
- [x] `compositionRootProvider` (override en main/tests) + `authStateProvider` (escucha `AuthPort`).
- [x] Providers de los 6 servicios de aplicación inyectados desde el Composition Root.
- [x] `SignInController` (`AsyncValue<void>`: loading/data/error) reutilizable.

### Plan 5.4 — Login y shell responsive ✅
- [x] Pantalla de login (A/B) con validación y manejo de errores (vía `AppFailure`).
- [x] `AppShell` responsive (`NavigationRail` en ancho / `NavigationBar` en compacto) con logout.
- [x] Widget tests: validación, login correcto→dashboard, guard, navegación y los 2 modos del shell.

**Definition of Done — Fase 5**
- [x] Login funcional (verificado con `firebase_auth_mocks`; con los usuarios reales tras los pasos MANUAL de consola).
- [x] Navegación con guard de auth operativa.
- [x] Shell responsive verificado (compact `NavigationBar` / expanded `NavigationRail`).
- [x] Widget tests base en verde. *(130 tests totales; build web OK.)*

---

# Fase 6 — Módulos funcionales UI
**Dependencias:** Fase 5 · **Entregables:** CRUDs y flujos funcionales con imágenes.

### Plan 6.1 — CRUD Actividades (con imagen) ✅
- [x] Lista de actividades (no carga blobs; solo indica si hay imagen — D1).
- [x] Formulario crear/editar con `image_picker` + pipeline de media (procesa→guarda→`imageId`).
- [x] Activar/desactivar (Switch) y eliminar; `ActivitiesController` (AsyncNotifier) refresca tras cada cambio.
- [x] Widget tests del flujo CRUD (crear, validación, eliminar).

### Plan 6.2 — CRUD Penitencias (con imagen) ✅
- [x] Lista, crear/editar, severidad (dropdown), activar/desactivar, imagen opcional.
- [x] Widget test del flujo.

### Plan 6.3 — Disponibilidad ✅
- [x] UI de disponibilidad por usuario: días de la semana (FilterChips) + fechas bloqueadas (date picker). Conserva franjas/periodos al guardar.
- [x] Persistencia vía `AvailabilityService`.
- [x] Widget test (seleccionar días + guardar).

### Plan 6.4 — Agenda semanal + reprogramación manual ✅
- [x] Vista de agenda de la semana (navegación entre semanas, estado de cada evento).
- [x] **Reprogramación manual** (date picker → `RescheduleEventUseCase`).
- [x] Widget test de visualización. *(La generación de eventos es lazy — Fase 7.)*

### Plan 6.5 — Flujo de confirmaciones ✅
- [x] UI para que A y B aprueben/rechacen cada actividad; el compañero se infiere de las confirmaciones existentes (app de 2 usuarios).
- [x] El evento pasa a `Completado` **solo si ambos aprueban** (regla de dominio).
- [x] Widget test **end-to-end**: B había aprobado, A aprueba → evento completado.

### Plan 6.6 — Historial ✅
- [x] Vista de historial (fecha, nº de actividades, estado) ordenada por fecha desc.
- [~] Filtros por rango/estado: pendientes (mejora futura).
- [x] Widget test con evento sembrado.

**Definition of Done — Fase 6**
- [x] Todos los CRUDs operativos contra Firestore (verificado con `fake_cloud_firestore` en widget tests).
- [x] Imágenes: pipeline de compresión+Base64 integrado en los formularios (validación de tamaño en dominio).
- [x] Flujo de confirmaciones cumple la regla "ambos aprueban" (test end-to-end).
- [x] Widget tests de los módulos en verde. *(138 tests totales; build web OK.)*

---

# Fase 7 — Lógica avanzada (generador, rachas, estadísticas)
**Dependencias:** Fases 4 y 6 · **Entregables:** lazy generation operativa, rachas y agregación de stats.

### Plan 7.1 — Lazy generation en cliente ✅ ⚠️ D2
- [x] `homeBootstrapProvider`: al entrar autenticado, registra el perfil y dispara la generación.
- [x] `LazyScheduleService`: genera la semana actual y, los **domingos**, también la siguiente.
- [x] **Guard transaccional** `weeklySchedules/{weekId}` (conflicto = ya existe; se ignora).
- [x] **Directorio de pareja** (`CoupleService` + `UserRepositoryPort`) para resolver los UIDs de A y B (necesarios para generar/confirmar).
- [x] Tests: idempotencia (doble llamada → una agenda), caso domingo, registro de perfiles.

### Plan 7.2 — Rachas y agregación de estadísticas ✅
- [x] `CalculateStreaksUseCase` + `StatisticsService.refresh()` conectados a datos reales (recalcula y persiste snapshot).
- [x] `statistics` derivadas (racha actual/mejor, cumplimiento semanal/mensual/anual).
- [~] Generación de penitencias ante incumplimiento: `GeneratePenaltyUseCase` existe; el disparo automático al marcar `missed` se integra al cerrar semanas (mejora futura).
- [x] Tests de cálculo sobre datasets controlados (Fase 2 + agregación en dashboard).

**Definition of Done — Fase 7**
- [x] Generación semanal automática verificada (incl. idempotencia por guard).
- [x] Rachas y stats calculadas sobre datos reales (dashboard).
- [~] Penitencias: caso de uso listo; disparo automático pendiente de integrar.

---

# Fase 8 — Dashboard & gráficas
**Dependencias:** Fase 7 · **Entregables:** dashboard con KPIs y gráficas `fl_chart`.

### Plan 8.1 — KPIs ✅
- [x] Tarjetas KPI: programadas, completadas, pendientes, % cumplimiento, racha actual, mejor racha. *(Penitencias generadas: cuando se integre el disparo automático — 7.2.)*
- [x] `dashboardProvider` deriva de `StatisticsService` + conteo de eventos por estado.

### Plan 8.2 — Gráficas `fl_chart` ✅
- [x] `BarChart` de cumplimiento semanal/mensual/anual.
- [x] Estados de carga (spinner) y `RefreshIndicator` para recargar.
- [x] Widget test de render (KPIs con valores agregados).

**Definition of Done — Fase 8**
- [x] Dashboard muestra KPIs y gráfica con datos reales (test con eventos sembrados).
- [x] Render dentro del shell responsive (heredado de Fase 5).

---

# Fase 9 — Notificaciones (GitHub Actions + firebase-admin, sin Cloud Functions)
**Dependencias:** Fases 4 y 7 · **Entregables:** recepción FCM en cliente + emisor externo programado. ⚠️ DECISIÓN D3.

### Plan 9.1 — Recepción y tokens en el cliente ✅
- [x] Solicita permiso y registra el token (VAPID) en `users/{uid}.fcmTokens` al arrancar (`homeBootstrap`, guardado si no hay messaging en tests).
- [x] Service worker FCM en web (`web/firebase-messaging-sw.js`) para background.
- [x] Mensajes en foreground → SnackBar (vía `scaffoldMessengerKey` en `main`).

### Plan 9.2 — Emisor externo (Node + firebase-admin) ✅ 🔒
- [x] `automation/` con `index.js` + `package.json` (fuera de las 4 capas).
- [ ] 🔧 MANUAL (pendiente): generar **service account** y guardarla como **secret** `FIREBASE_SERVICE_ACCOUNT`.
- [x] Script que **solo lee Firestore y envía FCM**: recordatorios diarios, confirmaciones pendientes, resumen semanal (domingo), aviso "nueva semana".
- [x] **DRY**: sin reglas de negocio ni generación en Node.
- [~] Dry-run contra emulador: pendiente (no hay `node` en el entorno de desarrollo).

### Plan 9.3 — Workflow programado de GitHub Actions ✅
- [x] `.github/workflows/notifications.yml` con `schedule` (diario 08:00 UTC + domingo 18:00 UTC) y `workflow_dispatch`.
- [x] Inyecta `secrets.FIREBASE_SERVICE_ACCOUNT` en el job.
- [ ] 🔧 MANUAL (pendiente): verificar ejecución real y recepción de push.

**Definition of Done — Fase 9**
- [x] Cliente preparado para recibir push en foreground y background.
- [x] Workflow programado listo (sin Cloud Functions).
- [x] Service account **solo** como secret; nada commiteado (`.gitignore` cubre `serviceAccount*.json`).
- [x] Sin lógica de negocio duplicada en `automation/`. *(Verificación real requiere los pasos MANUAL de consola/secret.)*

---

# Fase 10 — Seguridad (Security Rules)
**Dependencias:** Fases 4 y 6 · **Entregables:** reglas que restringen el acceso a la pareja autenticada. 🔒

### Plan 10.1 — Firestore Security Rules ✅
- [x] `firestore.rules`: todo acceso requiere autenticación (= la pareja, al no haber registro público).
- [x] Reglas **explícitas por colección** (no comodín) + validación de `byteSize` de media (D1).
- [x] `auditLogs` de solo lectura; colecciones no listadas **denegadas** por defecto.
- [x] Scaffold de tests `@firebase/rules-unit-testing` en `firestore-rules-tests/`. *(Requiere emulador+node para ejecutar.)*

### Plan 10.2 — Endurecimiento App Check / key 🔒
- [ ] 🔧 MANUAL (pendiente): verificar App Check activo en producción (D5).
- [ ] 🔧 MANUAL (pendiente): restricción de API key por referrer + dominios de hosting.
- [x] `docs/SECURITY.md` actualizado con las reglas.

**Definition of Done — Fase 10**
- [x] Reglas escritas y listas para desplegar (`firebase deploy --only firestore:rules`). *(Despliegue + verificación con tests = pasos MANUAL.)*
- [ ] App Check y restricción de key confirmados en producción (MANUAL).

---

# Fase 11 — PWA completa & offline
**Dependencias:** Fase 5 · **Entregables:** PWA instalable, offline y con estrategia de actualización. ⚠️ DECISIÓN D4.

### Plan 11.1 — Manifest e instalación ✅
- [x] `manifest.json` completo (iconos maskable, shortcuts Agenda/Actividades, `id`/`scope`/`lang`, theme/background).
- [~] Install prompt: el navegador lo ofrece con la PWA instalable; verificación Lighthouse = paso manual.

### Plan 11.2 — Service worker y offline ✅
- [x] App shell cacheado por el service worker de Flutter web (`flutter build web`).
- [x] Persistencia offline de Firestore habilitada (`Settings(persistenceEnabled: true)`, D4).
- [x] Indicador offline/online en UI (`connectivityProvider` + banner en `AppShell`) con test.

### Plan 11.3 — Estrategia de actualización ✅
- [x] Documentada en `docs/PWA.md` (el SW cambia de versión por build; recarga aplica la nueva).
- [~] Prompt "nueva versión" vía `updatefound`: mejora futura documentada.

**Definition of Done — Fase 11**
- [x] PWA instalable (manifest + build web genera SW). *(Lighthouse = verificación manual.)*
- [x] App utilizable sin red (lecturas cacheadas, escrituras encoladas por Firestore).
- [~] Update prompt: estrategia documentada; prompt explícito pendiente.

---

# Fase 12 — Testing & Calidad
**Dependencias:** Fases 2–11 · **Entregables:** suite de tests con cobertura ≥ 80%.

### Plan 12.1 — Unit & dominio ✅
- [x] Unit tests de dominio/aplicación (cobertura dominio **96.5%**, total lib **83.2%** ≥ 80%).
- [x] Test de **arquitectura**: `lib/domain/**` y `lib/application/**` no importan Flutter/Firebase/Riverpod (verificado automáticamente).

### Plan 12.2 — Widget & integración ✅
- [x] Widget tests de pantallas clave (login, actividades, penitencias, disponibilidad, agenda, confirmaciones, historial, dashboard, offline).
- [x] Flujo crítico (login→actividad→agenda→confirmar→completar) cubierto end-to-end con `fake_cloud_firestore` (equivalente al emulador en este entorno).

### Plan 12.3 — Cobertura y CI ✅
- [x] `.github/workflows/ci.yml`: `dart format --set-exit-if-changed` + `flutter analyze` + `flutter test --coverage` + artefacto de cobertura.
- [x] Cobertura medida y reportada (total **83.2%**, ≥ 80%).

**Definition of Done — Fase 12**
- [x] Cobertura global ≥ 80% (83.2%).
- [x] CI definido (análisis + formato + tests + cobertura). *(Ejecución en GitHub al hacer push/PR.)*
- [x] Test de arquitectura en verde (146 tests totales).

---

# Fase 13 — Producción & Deploy
**Dependencias:** Fases 1–12 · **Entregables:** PWA desplegada en Firebase Hosting con checklist de salida.

### Plan 13.1 — Build y configuración de entornos ✅
- [x] `flutter build web --release` verificado; comando documentado con `--dart-define` (site key/VAPID) en `docs/DEPLOY.md`.
- [x] Variables de entorno por `--dart-define` (dev sin keys; prod con keys).

### Plan 13.2 — Deploy Firebase Hosting ✅ (config) / 🔧 (ejecución)
- [x] `firebase.json` (hosting `build/web`, rewrite SPA, `no-cache` del SW + reglas) y `.firebaserc` (`couplesync-cb0a8`).
- [ ] 🔧 MANUAL (pendiente): `firebase deploy` y verificar dominio + HTTPS.
- [ ] 🔧 MANUAL (pendiente): añadir el dominio de hosting al referrer de la API key (D5).

### Plan 13.3 — Checklist de salida a producción
- [x] Checklist documentado en `docs/DEPLOY.md`.
- [ ] 🔧 MANUAL (pendiente): ejecutar el checklist (rules, App Check, notificaciones, PWA, smoke test E2E).

**Definition of Done — Fase 13**
- [~] PWA lista para desplegar (config completa); **deploy = paso MANUAL** (requiere Firebase CLI/login).
- [ ] Seguridad, notificaciones y offline verificados en producción (MANUAL).
- [x] Checklist de salida documentado.

---

## Riesgos técnicos señalados
- **Límite 1 MiB/documento Firestore** para Base64 → mitigado por compresión + validación de tamaño + umbral de guarda (D1).
- **Doble generación semanal** si A y B abren a la vez → mitigado por guard transaccional (D2).
- **Soporte web de paquetes** (`image_picker`/compresión nativa) → verificar en Fase 1; usar `image` Dart puro/canvas.
- **Service account expuesta** → solo como secret de GitHub; `.gitignore` y revisión en Fase 9 (🔒).
- **Conflictos offline** (last-write-wins) → escrituras a campos disjuntos y confirmaciones por usuario (D4).
- **App Check podría bloquear el arranque** si está mal configurado → validar en Fase 1.7 y 10.2.

---

## ✋ Solicitud de aprobación

Este es el entregable del **PASO 1**: el plan de implementación completo. **No se ha generado código de implementación** ni se ha inicializado el repositorio.

**Por favor, revisa el ROADMAP y dame tu aprobación explícita antes de comenzar la Fase 1.** Si quieres ajustar el fasado, las decisiones D1–D6, o el nivel de granularidad, indícamelo y lo actualizo antes de empezar.
