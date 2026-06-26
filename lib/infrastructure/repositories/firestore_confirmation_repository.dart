import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/confirmation.dart';
import '../../domain/ports/confirmation_repository_port.dart';
import '../../domain/value_objects/ids.dart';
import '../firebase/dtos/confirmation_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreConfirmationRepository implements ConfirmationRepositoryPort {
  FirestoreConfirmationRepository(this._db);

  final FirebaseFirestore _db;

  /// Subcolección `scheduledEvents/{eventId}/confirmations`.
  CollectionReference<Map<String, dynamic>> _col(ScheduledEventId eventId) =>
      _db
          .collection(FirestoreCollections.scheduledEvents)
          .doc(eventId.value)
          .collection(FirestoreCollections.confirmations);

  /// Id determinista por (usuario, actividad) para que el upsert reemplace.
  static String docId(Confirmation c) =>
      '${c.userId.value}__${c.activityId.value}';

  @override
  Future<List<Confirmation>> getForEvent(ScheduledEventId eventId) async {
    final snap = await _col(eventId).get();
    return snap.docs
        .map((d) => ConfirmationDto.fromJson(d.data()).toDomain())
        .toList();
  }

  @override
  Future<void> upsert(ScheduledEventId eventId, Confirmation confirmation) =>
      _col(eventId).doc(docId(confirmation)).set(confirmation.toDto().toJson());
}
