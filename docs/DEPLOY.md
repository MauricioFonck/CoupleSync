# Deploy — CoupleSync (Frontend en Vercel · Backend en Firebase Spark)

El **frontend** (Flutter web) se sirve desde **Vercel**. El **backend** sigue en
**Firebase** (Authentication, Firestore + Security Rules, FCM). Vercel solo hospeda
estáticos; las reglas y la auth NO se despliegan en Vercel.

---

## 1) Firebase Console — `couplesync-cb0a8` (🔧 una vez)
1. **Authentication → Sign-in method**: habilita **Email/Password**.
2. **Authentication → Users**: crea **A** y **B** (email + contraseña).
3. **Authentication → Settings → Authorized domains**: añade tu dominio de Vercel
   (p. ej. `couplesync.vercel.app`) además de `localhost`.
4. **Firestore Database → Create database** (modo producción, región p. ej. `eur3`).
5. **Cloud Messaging → Web Push certificates**: genera y copia la **VAPID key**
   (`FCM_VAPID_KEY`).
6. **App Check**: registra la app web con **reCAPTCHA v3**; copia la **site key**
   (`RECAPTCHA_V3_SITE_KEY`). Asegúrate de que el dominio de Vercel está permitido en
   la configuración de reCAPTCHA.

## 2) Desplegar Security Rules (Firebase CLI)
Las reglas viven en Firebase aunque el hosting sea Vercel:
```bash
npm install -g firebase-tools
firebase login
firebase deploy --only firestore:rules    # usa firestore.rules + .firebaserc
```

## 3) Frontend en Vercel
La config ya está en el repo: `vercel.json` (build + *rewrites* SPA) y `vercel-build.sh`
(clona Flutter stable y ejecuta `flutter build web`).

### Opción A — Git integration (recomendada)
1. En Vercel: **Add New → Project → Import** el repo `MauricioFonck/CoupleSync`.
2. Framework Preset: **Other** (lo toma de `vercel.json`).
3. **Environment Variables** (Production + Preview):
   - `RECAPTCHA_V3_SITE_KEY` = tu site key
   - `FCM_VAPID_KEY` = tu VAPID key
4. **Deploy**. Cada `git push` a `main` redeploya automáticamente.

> El build clona Flutter (~2-4 min la primera vez). Los `*.g.dart`/`*.freezed.dart`
> están commiteados, así que no se ejecuta `build_runner`.

### Opción B — CLI con build local (más rápido/controlado)
```bash
flutter build web --release \
  --dart-define=RECAPTCHA_V3_SITE_KEY=TU_SITE_KEY \
  --dart-define=FCM_VAPID_KEY=TU_VAPID_KEY
cd build/web
vercel --prod        # despliega los estáticos ya construidos
```
(En este caso añade un `vercel.json` mínimo con los *rewrites* dentro de `build/web`,
o usa la Opción A.)

## 4) Restringir la API key (Google Cloud Console)
*APIs y servicios → Credenciales →* Browser key → *Restricciones de aplicación →
Sitios web (HTTP referrers)*:
- `https://TU-DOMINIO.vercel.app/*`
- `http://localhost/*` (desarrollo)

## 5) Notificaciones (GitHub Actions, independiente de Vercel)
1. Firebase → *Project settings → Service accounts → Generate new private key* (JSON).
2. GitHub repo → *Settings → Secrets → Actions* → secret `FIREBASE_SERVICE_ACCOUNT`
   con el JSON completo.
3. *Actions → Notifications → Run workflow* (`daily`) para probar.

## 6) Checklist de salida
- [ ] `flutter analyze` + `flutter test` en verde (CI).
- [ ] Security Rules desplegadas en Firebase.
- [ ] App Check activo; API key restringida al dominio de Vercel.
- [ ] Dominio de Vercel en *Authorized domains* de Firebase Auth.
- [ ] Usuarios A/B creados; Firestore y FCM habilitados.
- [ ] Secret `FIREBASE_SERVICE_ACCOUNT` creado; workflow probado.
- [ ] PWA instalable/offline (Lighthouse) en la URL de Vercel.
- [ ] Smoke test E2E con A y B (login → actividad → agenda → confirmar).

> Nota: `firebase.json` conserva una sección `hosting` por si quisieras usar Firebase
> Hosting como alternativa; con Vercel solo se usa su sección `firestore`.

## Coste
Vercel (Hobby) + Firebase **Spark**: $0 para 2 usuarios. Sin Cloud Storage ni Functions.
