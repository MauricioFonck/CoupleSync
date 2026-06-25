# Seguridad — CoupleSync

## Modelo de amenazas (resumen)
App **privada para 2 usuarios** (A y B) predefinidos en Firebase Auth. Sin registro
público. La superficie de ataque relevante es: acceso no autorizado a Firestore y abuso
de la API key web.

## API key web NO es secreta
La key web va embebida en el cliente; **no** es un secreto. La protección real es:

1. **Firestore Security Rules** — solo los UIDs de A y B autenticados leen/escriben
   (Fase 10).
2. **Firebase App Check** — proveedor **reCAPTCHA v3** para web. Verifica que las
   peticiones provienen de la app legítima.
3. **Restricción de la API key por HTTP referrer** en Google Cloud Console — limitada a
   los dominios de Firebase Hosting + `localhost` para desarrollo.

## App Check — operación
- La **site key** de reCAPTCHA v3 se inyecta en build/run, **no** se commitea:
  ```bash
  flutter run -d chrome --dart-define=RECAPTCHA_V3_SITE_KEY=xxxx
  flutter build web --release --dart-define=RECAPTCHA_V3_SITE_KEY=xxxx
  ```
- Si la variable está vacía, App Check **no** se activa (la app arranca en dev sin
  bloquear). En producción es obligatoria.
- Pasos manuales en consola (🔧): registrar la app en App Check, obtener la site key,
  y registrar la **debug token** del navegador durante desarrollo si se prueba con App
  Check activo.

## Credenciales — qué NUNCA se commitea 🔒
- **Service account** de la automatización (Fase 9): vive **solo** como *secret* del repo
  en GitHub Actions. Patrones ignorados en `.gitignore`: `**/serviceAccount*.json`,
  `*.env`, `secrets/`.
- VAPID key de FCM web: se inyecta vía `--dart-define` igual que la site key.

## Sin Cloud Storage / sin Cloud Functions
El proyecto se mantiene en **plan Spark**. No se inicializa Firebase Storage ni se usan
Cloud Functions (ver `docs/ROADMAP.md`, decisiones D1–D6).
