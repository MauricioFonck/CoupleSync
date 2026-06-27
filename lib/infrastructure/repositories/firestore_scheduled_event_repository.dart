import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/confirmation.dart';
import '../../domain/entities/scheduled_event.dart';
import '../../domain/ports/scheduled_event_repository_port.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/week_id.dart';
import '../firebase/dtos/confirmation_dto.dart';
import '../firebase/dtos/scheduled_event_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreScheduledEventRepository
    implements ScheduledEventRepositoryPort {
  FirestoreScheduledEventRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection(FirestoreCollections.scheduledEvents);

  /// Hidrata las confirmaciones (subcolección) para que la regla "ambos
  /// aprueban" tenga el estado completo (ver D4).
  Future<List<Confirmation>> _confirmations(String eventId) async {
    final snap = await _col
        .doc(eventId)
        .collection(FirestoreCollections.confirmations)
        .get();
    return snap.docs
        .map((d) => ConfirmationDto.fromJson(d.data()).toDomain())
        .toList();
  }

  Future<ScheduledEvent> _hydrate(Map<String, dynamic> data) async {
    final dto = ScheduledEventDto.fromJson(data);
    return dto.toDomain(confirmations: await _confirmations(dto.id));
  }

  @override
  Future<ScheduledEvent?> getById(ScheduledEventId id) async {
    final doc = await _col.doc(id.value).get();
    final data = doc.data();
    return data == null ? null : _hydrate(data);
  }

  @override
  Future<List<ScheduledEvent>> getByWeek(WeekId weekId) async {
    final snap = await _col.where('weekId', isEqualTo: weekId.value).get();
    return Future.wait(snap.docs.map((d) => _hydrate(d.data())));
  }

  @override
  Future<List<ScheduledEvent>> getByDateRange(DateRange range) async {
    final snap = await _col
        .where(
          'date',
          isGreaterThanOrEqualTo: range.start.toIso8601String(),
          isLessThanOrEqualTo: range.end.toIso8601String(),
        )
        .get();
    return Future.wait(snap.docs.map((d) => _hydrate(d.data())));
  }

  @override
  Stream<List<ScheduledEvent>> watchByWeek(WeekId weekId) => _col
      .where('weekId', isEqualTo: weekId.value)
      .snapshots()
      .asyncMap(
        (snap) => Future.wait(snap.docs.map((d) => _hydrate(d.data()))),
      );

  @override
  Stream<List<ScheduledEvent>> watchByDateRange(DateRange range) => _col
      .where(
        'date',
        isGreaterThanOrEqualTo: range.start.toIso8601String(),
        isLessThanOrEqualTo: range.end.toIso8601String(),
      )
      .snapshots()
      .asyncMap(
        (snap) => Future.wait(snap.docs.map((d) => _hydrate(d.data()))),
      );

  @override
  Future<void> save(ScheduledEvent event) =>
      _col.doc(event.id.value).set(event.toDto().toJson());
}
