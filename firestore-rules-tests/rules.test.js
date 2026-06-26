// Tests de las Security Rules de Firestore.
// Ejecutar con: `npm test` (lanza el Firebase Emulator y corre `node --test`).
// Requiere Node 20+, el Firebase CLI y el emulador de Firestore.

import assert from 'node:assert';
import { readFileSync } from 'node:fs';
import { after, before, test } from 'node:test';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import { doc, getDoc, setDoc } from 'firebase/firestore';

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: 'couplesync-cb0a8',
    firestore: { rules: readFileSync('../firestore.rules', 'utf8') },
  });
});

after(async () => {
  await testEnv?.cleanup();
});

test('un usuario no autenticado NO puede leer ni escribir', async () => {
  const db = testEnv.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(db, 'activities/a1')));
  await assertFails(setDoc(doc(db, 'activities/a1'), { title: 'x' }));
});

test('un usuario autenticado puede leer/escribir actividades', async () => {
  const db = testEnv.authenticatedContext('A').firestore();
  await assertSucceeds(setDoc(doc(db, 'activities/a1'), { title: 'Cena' }));
  await assertSucceeds(getDoc(doc(db, 'activities/a1')));
});

test('media rechaza blobs por encima del límite de tamaño', async () => {
  const db = testEnv.authenticatedContext('A').firestore();
  await assertSucceeds(setDoc(doc(db, 'media/m1'), { byteSize: 500000 }));
  await assertFails(setDoc(doc(db, 'media/m2'), { byteSize: 2000000 }));
});

test('auditLogs es de solo lectura para el cliente', async () => {
  const db = testEnv.authenticatedContext('A').firestore();
  await assertFails(setDoc(doc(db, 'auditLogs/x'), { event: 'test' }));
});

test('colecciones no listadas están denegadas', async () => {
  const db = testEnv.authenticatedContext('A').firestore();
  await assertFails(getDoc(doc(db, 'secretos/x')));
});
