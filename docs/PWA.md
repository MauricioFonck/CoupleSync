# PWA & Offline — CoupleSync

## Instalable
- `web/manifest.json`: nombre, `id`/`scope`/`start_url`, `display: standalone`,
  iconos (incl. **maskable** 192/512), `theme_color` `#E91E63`, `shortcuts`
  (Agenda, Actividades) y `categories`.
- Verificación: Lighthouse → categoría PWA (instalable).

## Offline
- **App shell**: cacheado por el *service worker* que genera Flutter web
  (`flutter_service_worker.js`) en `flutter build web`.
- **Datos**: persistencia offline de Firestore habilitada en `main.dart`
  (`Settings(persistenceEnabled: true)`, IndexedDB en web — decisión **D4**).
  Las lecturas se sirven desde caché y las escrituras se **encolan** y se
  reenvían al reconectar (last-write-wins; ver D4).
- **Indicador**: `connectivityProvider`/`isOnlineProvider` muestran un banner
  "Sin conexión…" en `AppShell` cuando se pierde la red. En tests asume online
  si el plugin no está disponible.

## Estrategia de actualización
- El *service worker* de Flutter cambia de versión en cada `flutter build web`.
  Al recargar, el navegador instala el nuevo SW y sirve la versión actualizada.
- Para forzar la actualización sin esperar, basta recargar la pestaña; el
  `RefreshIndicator` del dashboard recarga los datos (no el SW).
- Mejora futura: escuchar `updatefound` del SW y mostrar un *prompt* "nueva
  versión disponible — recargar".
