# Deploy — CoupleSync (Firebase Hosting, plan Spark)

## Requisitos previos (🔧 manual, una vez)
1. Instalar Firebase CLI: `npm i -g firebase-tools` y `firebase login`.
2. En **Firebase Console** (proyecto `couplesync-cb0a8`):
   - Crear los 2 usuarios A y B en **Authentication** (email/password).
   - Habilitar **Cloud Firestore** (modo producción) y **FCM**.
   - Registrar la app web en **App Check** (reCAPTCHA v3) y copiar la *site key*.
3. En **Google Cloud Console**: restringir la API key web por **HTTP referrer**
   (dominio de hosting + `localhost`).
4. Crear el secret `FIREBASE_SERVICE_ACCOUNT` en GitHub (para las notificaciones).

## Build de producción
```bash
flutter build web --release \
  --dart-define=RECAPTCHA_V3_SITE_KEY=<tu_site_key> \
  --dart-define=FCM_VAPID_KEY=<tu_vapid_key>
```

## Desplegar reglas + hosting
```bash
firebase deploy --only firestore:rules,hosting
```
- `firebase.json` sirve `build/web` con rewrite SPA a `index.html` y `no-cache`
  para el service worker (para que las actualizaciones se apliquen al recargar).
- `.firebaserc` fija el proyecto `couplesync-cb0a8`.

## Checklist de salida a producción
- [ ] `flutter analyze` limpio y `flutter test` en verde (CI).
- [ ] Security Rules desplegadas (`firestore.rules`).
- [ ] App Check activo y API key restringida por referrer.
- [ ] Usuarios A y B creados; Firestore y FCM habilitados.
- [ ] Workflow de notificaciones probado (Actions → Run workflow).
- [ ] PWA instalable y usable offline (Lighthouse).
- [ ] Smoke test E2E con los 2 usuarios reales (login → actividad → agenda → confirmar).

## Coste
Plan **Spark ($0)**: Hosting, Firestore, Auth y FCM dentro de cuotas gratuitas;
sin Cloud Storage ni Cloud Functions (D1/D6).
