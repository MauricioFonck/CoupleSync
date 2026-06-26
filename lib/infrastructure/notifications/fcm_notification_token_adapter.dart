import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/ports/notification_token_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/firestore_collections.dart';

/// Adaptador de [NotificationTokenPort]: obtiene el token FCM (web/VAPID) y
/// persiste los tokens del usuario en `users/{uid}.fcmTokens`. El **envío** de
/// push lo hace el emisor externo de GitHub Actions (ver D3); aquí solo se
/// reciben y se gestionan tokens.
class FcmNotificationTokenAdapter implements NotificationTokenPort {
  FcmNotificationTokenAdapter({
    required FirebaseMessaging messaging,
    required FirebaseFirestore firestore,
    String? vapidKey,
  })  : _messaging = messaging,
        _db = firestore,
        _vapidKey = vapidKey;

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _db;
  final String? _vapidKey;

  DocumentReference<Map<String, dynamic>> _userDoc(UserId userId) =>
      _db.collection(FirestoreCollections.users).doc(userId.value);

  @override
  Future<String?> currentToken() => _messaging.getToken(vapidKey: _vapidKey);

  @override
  Future<void> register(UserId userId, String token) => _userDoc(userId).set(
        {
          'fcmTokens': FieldValue.arrayUnion([token]),
        },
        SetOptions(merge: true),
      );

  @override
  Future<void> unregister(UserId userId, String token) => _userDoc(userId).set(
        {
          'fcmTokens': FieldValue.arrayRemove([token]),
        },
        SetOptions(merge: true),
      );
}
