// Service worker de Firebase Cloud Messaging (recepción en segundo plano).
// Usa el SDK "compat" servido por gstatic. No incluye storageBucket (plan Spark).
importScripts(
  'https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js',
);
importScripts(
  'https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js',
);

firebase.initializeApp({
  apiKey: 'AIzaSyCpu_NMcONHAr2qVnv3x58A5z8nEhpi-VA',
  authDomain: 'couplesync-cb0a8.firebaseapp.com',
  projectId: 'couplesync-cb0a8',
  messagingSenderId: '678018643671',
  appId: '1:678018643671:web:680d520e538abb460f2292',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const title = (payload.notification && payload.notification.title) || 'CoupleSync';
  const options = {
    body: (payload.notification && payload.notification.body) || '',
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(title, options);
});
