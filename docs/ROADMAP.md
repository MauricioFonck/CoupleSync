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

### Plan 3.1 — Services de orquestación
- [ ] `ActivityService`, `PenaltyService`, `AvailabilityService` que componen use cases.
- [ ] `SchedulingService` (orquesta generación semanal + reprogramación).
- [ ] `ConfirmationService` (orquesta confirmaciones y cierre de eventos).
- [ ] `StatisticsService` (orquesta cálculo de rachas/KPIs).

### Plan 3.2 — Commands y Queries
- [ ] Definir commands (escritura) y queries (lectura) como objetos/DTOs de entrada/salida de la capa.
- [ ] Mapear errores de dominio a resultados de aplicación (Result/Either o excepciones controladas) — definir convención.
- [ ] Tests de orquestación (services llaman a los use cases correctos en el orden correcto).

**Definition of Done — Fase 3**
- [ ] `application/` solo depende de `domain/` (verificado).
- [ ] Tests de services en verde.
- [ ] Convención de manejo de errores documentada.

---

# Fase 4 — Infraestructura & Adaptadores
**Dependencias:** Fases 2 y 3 · **Entregables:** adaptadores concretos (Firebase) implementando los ports, mappers Freezed, Composition Root/DI.

### Plan 4.1 — Autenticación
- [ ] Implementar `FirebaseAuthAdapter` (`AuthPort`): login email/password A o B, logout, estado de sesión.
- [ ] Manejo de errores de auth → excepciones/Result de aplicación.
- [ ] Tests del adaptador (con emulador o mocks del SDK).

### Plan 4.2 — DTOs y Mappers (Freezed + json_serializable)
- [ ] DTOs Freezed para cada entidad/colección con `fromJson/toJson`.
- [ ] Mappers DTO ↔ Dominio (sin filtrar tipos de Firestore al dominio).
- [ ] Ejecutar `build_runner` y verificar generación.
- [ ] Tests de round-trip de mappers (dominio→DTO→dominio).

### Plan 4.3 — Repositorios Firestore
- [ ] Implementar repos Firestore para `activities, penalties, availability, weeklySchedules, scheduledEvents, confirmations, statistics, settings, notifications, auditLogs`.
- [ ] `WeeklyScheduleRepository`: creación del guard `weeklySchedules/{año-Wsemana}` dentro de **transacción** (⚠️ DECISIÓN D2).
- [ ] Server timestamps (`createdAt/updatedAt`) y `updatedAt` para mitigación de conflictos (⚠️ DECISIÓN D4).
- [ ] Tests con **Firebase Emulator Suite** (Firestore).

### Plan 4.4 — Adaptador de Media (compresión web + Base64) ⚠️ DECISIÓN D1
- [ ] Implementar pipeline web: seleccionar imagen → redimensionar (lado mayor ~800–1000px) → comprimir (JPEG/WebP ~70–80%) → codificar Base64, usando solución **web-compatible** (`image` Dart puro / canvas).
- [ ] Validar `byteSize` antes de escribir (rechazar si supera umbral de guarda, ej. 700 KB).
- [ ] `MediaRepository` (`MediaRepositoryPort`) sobre colección `media/{mediaId}` separada de las entidades.
- [ ] Limpieza de blobs huérfanos al actualizar/eliminar imagen de una entidad.
- [ ] Tests del pipeline (tamaño resultante < umbral, round-trip Base64).

### Plan 4.5 — FCM (recepción y tokens)
- [ ] Implementar `FcmTokenAdapter` (`NotificationTokenPort`): obtener token web (VAPID), persistirlo en `users/{uid}.fcmTokens`.
- [ ] Manejo de recepción de mensajes en foreground/background (service worker FCM en web).
- [ ] Tests de gestión de tokens (mock del SDK).

### Plan 4.6 — Composition Root / DI 🔒
- [ ] Centralizar el wiring (ports→adaptadores) en `infrastructure/` (composition root).
- [ ] Exponer los providers Riverpod que inyectan implementaciones a la capa de presentación (sin que la UI conozca Firebase).
- [ ] Verificar que `presentation/` no importa Firebase directamente.

**Definition of Done — Fase 4**
- [ ] Todos los ports tienen adaptador concreto y tests (emulador/mocks) en verde.
- [ ] Mappers con round-trip verificado.
- [ ] Pipeline de media produce Base64 < umbral y guarda en colección separada.
- [ ] Composition Root inyecta todo; la UI no toca Firebase (verificado).

---

# Fase 5 — Presentación base
**Dependencias:** Fase 4 · **Entregables:** theme Material 3, navegación, providers, login y shell responsive.

### Plan 5.1 — Theme Material 3
- [ ] Definir `ColorScheme` (light/dark), tipografía y componentes base en `presentation/theme/`.
- [ ] Theme responsive (breakpoints móvil/tablet/desktop).

### Plan 5.2 — Navegación (Go Router)
- [ ] Configurar `go_router` con rutas y **guard de autenticación** (redirige a login si no hay sesión).
- [ ] Definir rutas base: `/login`, `/dashboard`, `/activities`, `/penalties`, `/availability`, `/schedule`, `/history`.

### Plan 5.3 — Providers Riverpod base
- [ ] Provider de estado de auth (escucha `AuthPort`).
- [ ] Providers de servicios de aplicación (inyectados desde composition root).
- [ ] Patrón de estado (loading/data/error) definido y reutilizable.

### Plan 5.4 — Login y shell responsive
- [ ] Pantalla de login (A/B) con validación y manejo de errores.
- [ ] Shell responsive (NavigationRail en desktop / NavigationBar en móvil).
- [ ] Widget test de login (éxito/fallo) y de redirección por guard.

**Definition of Done — Fase 5**
- [ ] Login funcional con los 2 usuarios reales (o emulador).
- [ ] Navegación con guard de auth operativa.
- [ ] Shell responsive verificado en 3 breakpoints.
- [ ] Widget tests base en verde.

---

# Fase 6 — Módulos funcionales UI
**Dependencias:** Fase 5 · **Entregables:** CRUDs y flujos funcionales con imágenes.

### Plan 6.1 — CRUD Actividades (con imagen)
- [ ] Lista de actividades (sin cargar blobs; thumbnails por `imageId` bajo demanda).
- [ ] Formulario crear/editar con selector e **integración del pipeline de media** (Fase 4.4).
- [ ] Activar/desactivar actividad.
- [ ] Widget tests del flujo CRUD.

### Plan 6.2 — CRUD Penitencias (con imagen)
- [ ] Lista, crear/editar, severidad, activar/desactivar, imagen opcional.
- [ ] Widget tests del flujo.

### Plan 6.3 — Disponibilidad
- [ ] UI de gestión de disponibilidad por usuario (días, horarios, fechas bloqueadas, periodos de indisponibilidad).
- [ ] Validaciones y persistencia.
- [ ] Widget tests.

### Plan 6.4 — Agenda semanal + reprogramación manual
- [ ] Vista de agenda de la semana (eventos programados y su estado).
- [ ] Acción de **reprogramación manual** de un evento.
- [ ] Widget tests de visualización y reprogramación.

### Plan 6.5 — Flujo de confirmaciones
- [ ] UI para que A y B confirmen cada actividad (`approved/rejected`).
- [ ] Reflejar que el evento se completa **solo si ambos aprueban**.
- [ ] Widget tests del flujo de confirmación dual.

### Plan 6.6 — Historial
- [ ] Vista de historial (actividad, fecha, estado, confirmaciones, observaciones, penitencias).
- [ ] Filtros básicos (rango de fechas/estado).
- [ ] Widget tests.

**Definition of Done — Fase 6**
- [ ] Todos los CRUDs operativos contra Firestore (emulador/real).
- [ ] Imágenes suben comprimidas en Base64 sin superar límites.
- [ ] Flujo de confirmaciones cumple la regla "ambos aprueban".
- [ ] Widget tests de los módulos en verde.

---

# Fase 7 — Lógica avanzada (generador, rachas, estadísticas)
**Dependencias:** Fases 4 y 6 · **Entregables:** lazy generation operativa, rachas y agregación de stats.

### Plan 7.1 — Lazy generation en cliente ⚠️ DECISIÓN D2
- [ ] Servicio de arranque que, al abrir la app, comprueba si existe la agenda de la semana objetivo.
- [ ] Disparo de `GenerateWeeklyScheduleUseCase` si es domingo o posterior y no existe agenda.
- [ ] **Guard transaccional** sobre `weeklySchedules/{año-Wsemana}` (evita doble generación si A y B abren a la vez).
- [ ] Tests de integración: doble apertura simultánea genera **una** sola agenda.

### Plan 7.2 — Rachas y agregación de estadísticas
- [ ] Conectar `CalculateStreaksUseCase` y `StatisticsService` a datos reales.
- [ ] Persistir/derivar `statistics` (racha actual, mejor, cumplimiento semanal/mensual/anual).
- [ ] Generación de penitencias ante incumplimiento, según reglas.
- [ ] Tests de cálculo sobre datasets controlados.

**Definition of Done — Fase 7**
- [ ] Generación semanal automática verificada (incl. caso concurrente).
- [ ] Rachas y stats calculadas correctamente sobre datos reales.
- [ ] Penitencias generadas según reglas.

---

# Fase 8 — Dashboard & gráficas
**Dependencias:** Fase 7 · **Entregables:** dashboard con KPIs y gráficas `fl_chart`.

### Plan 8.1 — KPIs
- [ ] Tarjetas KPI: programadas, completadas, pendientes, penitencias generadas, % cumplimiento, mejor racha, racha actual.
- [ ] Providers de lectura derivados de `StatisticsService`.

### Plan 8.2 — Gráficas `fl_chart`
- [ ] Gráficas semanal / mensual / anual / tendencias.
- [ ] Estados vacíos y de carga.
- [ ] Widget tests de render del dashboard.

**Definition of Done — Fase 8**
- [ ] Dashboard muestra KPIs y gráficas con datos reales.
- [ ] Render verificado en los 3 breakpoints.

---

# Fase 9 — Notificaciones (GitHub Actions + firebase-admin, sin Cloud Functions)
**Dependencias:** Fases 4 y 7 · **Entregables:** recepción FCM en cliente + emisor externo programado. ⚠️ DECISIÓN D3.

### Plan 9.1 — Recepción y tokens en el cliente
- [ ] Solicitar permiso de notificaciones y registrar token (VAPID) en `users/{uid}.fcmTokens` (apoyado en Fase 4.5).
- [ ] Service worker FCM en web para background.
- [ ] Manejo de mensajes en foreground (UI/snackbar).

### Plan 9.2 — Emisor externo (Node + firebase-admin) 🔒
- [ ] Crear `automation/` con script Node y `package.json` (fuera de las 4 capas).
- [ ] 🔧 MANUAL: generar **service account** en Firebase y guardarla como **secret** del repo (🔒 nunca commiteada).
- [ ] Script que **solo lee Firestore y envía FCM**: recordatorios diarios, confirmaciones pendientes, resumen semanal (domingo), aviso "nueva semana, abre la app".
- [ ] Garantizar **DRY**: no reimplementar reglas de negocio (sin generación duplicada en Node).
- [ ] Tests/dry-run del script contra el emulador.

### Plan 9.3 — Workflow programado de GitHub Actions
- [ ] `.github/workflows/notifications.yml` con `schedule` (cron) — recordatorios diarios + resumen dominical.
- [ ] Inyectar el secret de service account en el job.
- [ ] 🔧 MANUAL: verificar ejecución del workflow y recepción real de push.

**Definition of Done — Fase 9**
- [ ] Cliente recibe push en foreground y background.
- [ ] Workflow programado envía notificaciones reales sin Cloud Functions.
- [ ] Service account vive **solo** como secret; no hay credenciales en el repo (verificado).
- [ ] Sin lógica de negocio duplicada en `automation/`.

---

# Fase 10 — Seguridad (Security Rules)
**Dependencias:** Fases 4 y 6 · **Entregables:** reglas que restringen el acceso a la pareja autenticada. 🔒

### Plan 10.1 — Firestore Security Rules
- [ ] Reglas que permiten lectura/escritura **solo** a los UIDs de A y B autenticados.
- [ ] Validación de forma/campos por colección (tipos, tamaños, `byteSize` de media bajo límite).
- [ ] Proteger `auditLogs`/`statistics` contra escrituras indebidas del cliente cuando aplique.
- [ ] Tests de reglas con `@firebase/rules-unit-testing` (casos permitidos y denegados).

### Plan 10.2 — Endurecimiento App Check / key 🔒
- [ ] Verificar App Check activo en producción (⚠️ DECISIÓN D5).
- [ ] Revisar restricción de API key por referrer y dominios de hosting.
- [ ] Actualizar `docs/SECURITY.md`.

**Definition of Done — Fase 10**
- [ ] Reglas desplegadas; acceso de terceros denegado (verificado con tests).
- [ ] App Check y restricción de key confirmados en producción.

---

# Fase 11 — PWA completa & offline
**Dependencias:** Fase 5 · **Entregables:** PWA instalable, offline y con estrategia de actualización. ⚠️ DECISIÓN D4.

### Plan 11.1 — Manifest e instalación
- [ ] `manifest.json` completo (iconos maskable, shortcuts, theme/background).
- [ ] Install prompt y verificación de instalabilidad (Lighthouse PWA).

### Plan 11.2 — Service worker y offline
- [ ] Estrategia de cache del app shell (Flutter web service worker).
- [ ] Persistencia offline de Firestore (IndexedDB, `synchronizeTabs`) y comportamiento ante reconexión.
- [ ] Indicadores de estado offline/online en UI.

### Plan 11.3 — Estrategia de actualización
- [ ] Detección de nueva versión del service worker y prompt de recarga.
- [ ] Verificar invalidación de cache tras deploy.

**Definition of Done — Fase 11**
- [ ] Lighthouse PWA pasa (instalable, offline básico).
- [ ] App utilizable sin red (lecturas cacheadas, escrituras encoladas).
- [ ] Update prompt funcional.

---

# Fase 12 — Testing & Calidad
**Dependencias:** Fases 2–11 · **Entregables:** suite de tests con cobertura ≥ 80%.

### Plan 12.1 — Unit & dominio
- [ ] Completar unit tests de dominio/aplicación a cobertura ≥ 80%.
- [ ] Test de **arquitectura**: `lib/domain/**` no importa Flutter/Firebase/Riverpod.

### Plan 12.2 — Widget & integración
- [ ] Widget tests de pantallas clave (login, CRUDs, confirmaciones, dashboard).
- [ ] Integration tests de flujos críticos (login→crear actividad→generar agenda→confirmar) sobre emulador.

### Plan 12.3 — Cobertura y CI
- [ ] `.github/workflows/ci.yml`: `flutter analyze` + `flutter test --coverage`.
- [ ] Reportar cobertura y fijar umbral ≥ 80%.

**Definition of Done — Fase 12**
- [ ] Cobertura global ≥ 80%.
- [ ] CI verde (análisis + tests).
- [ ] Test de arquitectura en verde.

---

# Fase 13 — Producción & Deploy
**Dependencias:** Fases 1–12 · **Entregables:** PWA desplegada en Firebase Hosting con checklist de salida.

### Plan 13.1 — Build y configuración de entornos
- [ ] `flutter build web --release` optimizado (tree-shaking de iconos, renderer adecuado).
- [ ] Configuración de entornos (dev vs prod) y variables.

### Plan 13.2 — Deploy Firebase Hosting
- [ ] 🔧 MANUAL: configurar Firebase Hosting (`firebase.json`, `hosting`).
- [ ] Desplegar y verificar dominio + HTTPS.
- [ ] 🔧 MANUAL: confirmar que el referrer de la API key incluye el dominio de hosting (D5).

### Plan 13.3 — Checklist de salida a producción
- [ ] Verificar Security Rules desplegadas (Fase 10) y App Check activo.
- [ ] Verificar workflow de notificaciones en producción (Fase 9).
- [ ] Verificar PWA instalable y offline (Fase 11).
- [ ] Smoke test end-to-end con los 2 usuarios reales.

**Definition of Done — Fase 13**
- [ ] PWA accesible en producción vía Firebase Hosting (HTTPS).
- [ ] Seguridad, notificaciones y offline verificados en producción.
- [ ] Checklist de salida completo.

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
