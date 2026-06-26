import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/week_id.dart';

/// Consulta de actividades (todas o solo activas).
final class ActivitiesQuery {
  const ActivitiesQuery({this.onlyActive = false});
  final bool onlyActive;
}

/// Consulta de penitencias (todas o solo activas).
final class PenaltiesQuery {
  const PenaltiesQuery({this.onlyActive = false});
  final bool onlyActive;
}

/// Consulta de los eventos de una semana.
final class WeekEventsQuery {
  const WeekEventsQuery(this.weekId);
  final WeekId weekId;
}

/// Consulta de la disponibilidad de un usuario.
final class AvailabilityQuery {
  const AvailabilityQuery(this.userId);
  final UserId userId;
}
