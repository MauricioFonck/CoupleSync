import '../value_objects/ids.dart';
import '../value_objects/statuses.dart';

/// Decisión de un usuario sobre una actividad concreta dentro de un evento.
/// Un evento se completa solo si **ambos** usuarios aprueban (ver
/// `ScheduledEvent.isFullyApprovedBy`).
final class Confirmation {
  const Confirmation({
    required this.userId,
    required this.activityId,
    required this.status,
  });

  final UserId userId;
  final ActivityId activityId;
  final ConfirmationStatus status;

  Confirmation copyWith({ConfirmationStatus? status}) => Confirmation(
        userId: userId,
        activityId: activityId,
        status: status ?? this.status,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Confirmation &&
          other.userId == userId &&
          other.activityId == activityId &&
          other.status == status);

  @override
  int get hashCode => Object.hash(userId, activityId, status);

  @override
  String toString() => 'Confirmation($userId, $activityId, $status)';
}
