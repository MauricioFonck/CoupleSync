# automation — Emisor de notificaciones (CoupleSync)

Infraestructura **externa** a las 4 capas de Flutter (D3 / §6). Un script Node con
`firebase-admin` que **solo lee Firestore y envía push FCM**. No contiene reglas de
negocio (la generación de la agenda vive en el dominio Dart).

## Qué envía
- **Diario** (`node index.js daily`): recordatorio de actividades de hoy y aviso de
  confirmaciones pendientes.
- **Semanal** (`node index.js weekly`, domingos): resumen + "nueva semana, abre la app".

## Credenciales 🔒
- `FIREBASE_SERVICE_ACCOUNT`: JSON de la *service account* de Firebase, inyectado como
  **secret del repo** (Settings → Secrets and variables → Actions). **Nunca** se commitea.
- Alternativa local: `GOOGLE_APPLICATION_CREDENTIALS` apuntando al fichero de la key.

## Ejecución
- Automática: workflow `.github/workflows/notifications.yml` (cron diario + domingo).
- Manual: pestaña *Actions* → *Notifications* → *Run workflow* (elige `daily`/`weekly`).
- Local:
  ```bash
  cd automation
  npm install
  FIREBASE_SERVICE_ACCOUNT="$(cat serviceAccount.json)" node index.js daily
  ```

## Coste
$0 — `firebase-admin` es gratis, FCM es gratis e ilimitado y los minutos de Actions de un
job pequeño caben en el plan gratuito.
