// Emisor de notificaciones FCM de CoupleSync.
//
// SOLO lee Firestore y envía push (recordatorios diarios, confirmaciones
// pendientes, resumen semanal y aviso de nueva semana). NO reimplementa reglas
// de negocio: la generación de la agenda vive en el dominio Dart (D3 / §6).
//
// Credenciales: variable de entorno FIREBASE_SERVICE_ACCOUNT (JSON de la service
// account, inyectado como secret del repo) o GOOGLE_APPLICATION_CREDENTIALS.
//
// Uso: `node index.js daily` | `node index.js weekly`.

const admin = require('firebase-admin');

function initAdmin() {
  const raw = process.env.FIREBASE_SERVICE_ACCOUNT;
  if (raw) {
    admin.initializeApp({ credential: admin.credential.cert(JSON.parse(raw)) });
  } else {
    // Usa GOOGLE_APPLICATION_CREDENTIALS si está disponible.
    admin.initializeApp();
  }
  return admin;
}

function startOfUtcDay(date) {
  return Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate());
}

function isSameUtcDay(isoString, ref) {
  const d = new Date(isoString);
  return startOfUtcDay(d) === startOfUtcDay(ref);
}

function daysAgoUtc(isoString, ref) {
  return (startOfUtcDay(ref) - startOfUtcDay(new Date(isoString))) / 86400000;
}

async function getAllTokens(db) {
  const snap = await db.collection('users').get();
  const tokens = [];
  snap.forEach((doc) => {
    const arr = doc.get('fcmTokens');
    if (Array.isArray(arr)) tokens.push(...arr);
  });
  return [...new Set(tokens)];
}

function buildMessages(events, mode, now) {
  const messages = [];

  const todayPending = events.filter(
    (e) => e.status === 'pending' && isSameUtcDay(e.date, now),
  );
  if (todayPending.length > 0) {
    messages.push({
      title: 'CoupleSync',
      body: `Tenéis ${todayPending.length} actividad(es) hoy 💕`,
    });
  }

  const overduePending = events.filter(
    (e) => e.status === 'pending' && daysAgoUtc(e.date, now) > 0,
  );
  if (overduePending.length > 0) {
    messages.push({
      title: 'Confirmaciones pendientes',
      body: `Hay ${overduePending.length} evento(s) por confirmar.`,
    });
  }

  if (mode === 'weekly') {
    const completedLastWeek = events.filter(
      (e) => e.status === 'completed' && daysAgoUtc(e.date, now) <= 7,
    ).length;
    messages.push({
      title: 'Resumen semanal',
      body: `Completadas esta semana: ${completedLastWeek}.`,
    });
    messages.push({
      title: 'Nueva semana',
      body: 'Abre la app para preparar la agenda de la semana 🗓️',
    });
  }

  return messages;
}

async function run() {
  const app = initAdmin();
  const db = app.firestore();
  const messaging = app.messaging();

  const mode = process.argv[2] === 'weekly' ? 'weekly' : 'daily';
  const now = new Date();

  const eventsSnap = await db.collection('scheduledEvents').get();
  const events = eventsSnap.docs.map((d) => d.data());

  const messages = buildMessages(events, mode, now);
  const tokens = await getAllTokens(db);

  if (messages.length === 0 || tokens.length === 0) {
    console.log(`Nada que enviar (mensajes=${messages.length}, tokens=${tokens.length}).`);
    return;
  }

  for (const m of messages) {
    const res = await messaging.sendEachForMulticast({
      tokens,
      notification: m,
    });
    console.log(`"${m.title}" → ${res.successCount}/${tokens.length} entregados.`);
  }
}

run().catch((err) => {
  console.error('Fallo en el emisor de notificaciones:', err);
  process.exit(1);
});

module.exports = { buildMessages, isSameUtcDay, daysAgoUtc };
