# Arquitectura — CoupleSync

Arquitectura **Hexagonal (Ports & Adapters)**. La regla de oro: **las dependencias
apuntan siempre hacia el dominio**. El dominio no conoce a nadie; todos conocen al
dominio (a través de sus interfaces/ports).

```
presentation  ──►  application  ──►  domain  ◄──  infrastructure
   (UI)            (orquesta)       (núcleo)        (adaptadores)
```

## Capas y qué puede importar cada una

### `lib/domain/` — núcleo (Dart puro)
`entities/`, `value_objects/`, `ports/`, `use_cases/`, `exceptions/`
- **PROHIBIDO** importar Flutter, Firebase, Firestore, Riverpod o cualquier paquete
  de infraestructura. Solo Dart y otros archivos de `domain/`.
- Define **ports** (interfaces) que la infraestructura implementará.
- Contiene la lógica de negocio: `GenerateWeeklyScheduleUseCase`, cálculo de rachas, etc.
- Verificación automatizada de pureza: **test de arquitectura** en la Fase 12.

### `lib/application/` — orquestación
`services/`, `commands/`, `queries/`
- Solo importa `domain/`. Compone use cases. No conoce Firebase ni Flutter.
- **Entradas:** los servicios reciben **commands** (escritura) y **queries** (lectura).
- **Salidas / errores (convención):** todos los métodos de servicio devuelven
  `Result<T>` (`Ok<T>` | `Err<T>`). El helper `runCatching` captura cualquier
  excepción y la traduce a `AppFailure` con un `FailureKind`
  (`validation | invariant | notFound | conflict | unexpected`) mediante
  `AppFailure.fromException`. **Las excepciones de dominio nunca cruzan a la
  presentación**; la UI hace `result.fold(onOk, onErr)` y decide cómo mostrar
  cada `FailureKind`.

### `lib/infrastructure/` — adaptadores
`firebase/`, `repositories/`, `datasources/`, `notifications/`, `authentication/`, `media/`
- Implementa los **ports** del dominio con tecnología concreta (Firebase Auth,
  Firestore, FCM, codificación Base64).
- Mappers DTO (Freezed) ↔ Dominio. Los tipos de Firestore **nunca** cruzan al dominio.
- Aquí vive el **Composition Root / DI** (Fase 4).

### `lib/presentation/` — UI
`screens/`, `widgets/`, `providers/`, `routes/`, `theme/`
- Solo UI, Riverpod, navegación (go_router) y estado visual.
- **La UI nunca accede directamente a Firebase/Firestore.** Todo pasa por casos de uso
  inyectados desde el Composition Root.

## Fuera de las 4 capas
- `automation/` — emisor de notificaciones (Node + `firebase-admin`) ejecutado por
  GitHub Actions. Es **infraestructura externa**, no parte del dominio (ver §6 del prompt
  y `docs/ROADMAP.md`).

## Principios
SOLID · DRY · KISS · Separation of Concerns · Dependency Inversion · Composition Root ·
Domain First.
