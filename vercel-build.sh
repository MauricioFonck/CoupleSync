#!/usr/bin/env bash
# Build de CoupleSync (Flutter web) en el entorno de Vercel.
# Vercel no trae Flutter, así que lo clonamos (canal stable) y construimos.
# Los archivos generados (*.freezed.dart / *.g.dart) están commiteados, por lo que
# NO se ejecuta build_runner aquí.
set -euo pipefail

FLUTTER_HOME="${FLUTTER_HOME:-$HOME/flutter}"

if [ ! -x "$FLUTTER_HOME/bin/flutter" ]; then
  echo "Clonando Flutter (stable)…"
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 "$FLUTTER_HOME"
fi

export PATH="$FLUTTER_HOME/bin:$PATH"

flutter --version
flutter config --enable-web
flutter pub get

flutter build web --release \
  --dart-define=RECAPTCHA_V3_SITE_KEY="${RECAPTCHA_V3_SITE_KEY:-}" \
  --dart-define=FCM_VAPID_KEY="${FCM_VAPID_KEY:-}"
