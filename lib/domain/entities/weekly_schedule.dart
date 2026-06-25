import 'package:collection/collection.dart';

import '../value_objects/ids.dart';
import '../value_objects/week_id.dart';

const ListEquality<Object?> _listEq = ListEquality<Object?>();

/// Agenda semanal generada para una semana ISO. Su `id` es el [WeekId], que
/// además actúa como *guard* contra doble generación (`weeklySchedules/{weekId}`,
/// ver D2).
final class WeeklySchedule {
  const WeeklySchedule({
    required this.weekId,
    required this.eventIds,
    required this.generatedAt,
  });

  final WeekId weekId;
  final List<ScheduledEventId> eventIds;
  final DateTime generatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklySchedule &&
          other.weekId == weekId &&
          _listEq.equals(other.eventIds, eventIds) &&
          other.generatedAt == generatedAt);

  @override
  int get hashCode =>
      Object.hash(weekId, _listEq.hash(eventIds), generatedAt);

  @override
  String toString() =>
      'WeeklySchedule($weekId, events=${eventIds.length})';
}
