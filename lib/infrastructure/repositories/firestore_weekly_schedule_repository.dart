import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/scheduled_event.dart';
import '../../domain/entities/weekly_schedule.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/ports/weekly_schedule_repository_port.dart';
import '../../domain/value_objects/week_id.dart';
import '../firebase/dtos/weekly_schedule_dto.dart';
import '../firebase/firestore_collections.dart';
import '../firebase/mappers/mappers.dart';

class FirestoreWeeklyScheduleRepository
    implements WeeklyScheduleRepositoryPort {
  FirestoreWeeklyScheduleRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _guard(WeekId weekId) =>
      _db.collection(FirestoreCollections.weeklySchedules).doc(weekId.value);

  @override
  Future<bool> exists(WeekId weekId) async =>
      (await _guard(weekId).get()).exists;

  @override
  Future<WeeklySchedule?> getByWeek(WeekId weekId) async {
    final doc = await _guard(weekId).get();
    final data = doc.data();
    return data == null ? null : WeeklyScheduleDto.fromJson(data).toDomain();
  }

  /// Crea atómicamente la agenda y sus eventos. La **transacción** lee el guard
  /// y aborta con [ScheduleGenerationConflictException] si ya existía (evita la
  /// doble generación si A y B abren la app a la vez — D2).
  @override
  Future<void> saveGenerated({
    required WeeklySchedule schedule,
    required List<ScheduledEvent> events,
  }) async {
    final guardRef = _guard(schedule.weekId);
    final eventsCol = _db.collection(FirestoreCollections.scheduledEvents);

    await _db.runTransaction((tx) async {
      final guard = await tx.get(guardRef);
      if (guard.exists) {
        throw ScheduleGenerationConflictException(
          'La agenda de ${schedule.weekId.value} ya existe.',
          weekId: schedule.weekId.value,
        );
      }
      tx.set(guardRef, schedule.toDto().toJson());
      for (final event in events) {
        tx.set(eventsCol.doc(event.id.value), event.toDto().toJson());
      }
    });
  }
}
