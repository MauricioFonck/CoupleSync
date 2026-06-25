import 'package:collection/collection.dart';

import '../value_objects/ids.dart';
import '../value_objects/statuses.dart';
import '../value_objects/week_id.dart';
import 'confirmation.dart';

const ListEquality<Object?> _listEq = ListEquality<Object?>();

/// Evento programado en la agenda semanal: una fecha con una o más actividades,
/// su estado y las confirmaciones de ambos usuarios.
final class ScheduledEvent {
  const ScheduledEvent({
    required this.id,
    required this.date,
    required this.weekId,
    required this.activityIds,
    required this.status,
    required this.confirmations,
    required this.createdAt,
    this.notes,
  });

  final ScheduledEventId id;
  final DateTime date;
  final WeekId weekId;
  final List<ActivityId> activityIds;
  final CompletionStatus status;
  final List<Confirmation> confirmations;
  final String? notes;
  final DateTime createdAt;

  /// `true` si [userId] aprobó la actividad [activityId] en este evento.
  bool isApprovedBy(ActivityId activityId, UserId userId) =>
      confirmations.any(
        (c) =>
            c.activityId == activityId &&
            c.userId == userId &&
            c.status.isApproved,
      );

  /// `true` si **ambos** usuarios aprobaron **todas** las actividades.
  /// Requisito para completar el evento (regla de negocio).
  bool isFullyApprovedBy(UserId partnerA, UserId partnerB) =>
      activityIds.isNotEmpty &&
      activityIds.every(
        (a) => isApprovedBy(a, partnerA) && isApprovedBy(a, partnerB),
      );

  /// Inserta o reemplaza la confirmación de un (usuario, actividad).
  ScheduledEvent upsertConfirmation(Confirmation confirmation) {
    final next = <Confirmation>[
      ...confirmations.where(
        (c) => !(c.activityId == confirmation.activityId &&
            c.userId == confirmation.userId),
      ),
      confirmation,
    ];
    return copyWith(confirmations: next);
  }

  ScheduledEvent copyWith({
    List<ActivityId>? activityIds,
    CompletionStatus? status,
    List<Confirmation>? confirmations,
    String? notes,
    bool clearNotes = false,
  }) =>
      ScheduledEvent(
        id: id,
        date: date,
        weekId: weekId,
        activityIds: activityIds ?? this.activityIds,
        status: status ?? this.status,
        confirmations: confirmations ?? this.confirmations,
        notes: clearNotes ? null : (notes ?? this.notes),
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledEvent &&
          other.id == id &&
          other.date == date &&
          other.weekId == weekId &&
          _listEq.equals(other.activityIds, activityIds) &&
          other.status == status &&
          _listEq.equals(other.confirmations, confirmations) &&
          other.notes == notes &&
          other.createdAt == createdAt);

  @override
  int get hashCode => Object.hash(
        id,
        date,
        weekId,
        _listEq.hash(activityIds),
        status,
        _listEq.hash(confirmations),
        notes,
        createdAt,
      );

  @override
  String toString() =>
      'ScheduledEvent($id, $date, status=$status, activities=${activityIds.length})';
}
