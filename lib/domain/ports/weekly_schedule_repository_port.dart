import '../entities/scheduled_event.dart';
import '../entities/weekly_schedule.dart';
import '../exceptions/domain_exception.dart';
import '../value_objects/week_id.dart';

/// Puerto de persistencia de agendas semanales.
abstract interface class WeeklyScheduleRepositoryPort {
  Future<WeeklySchedule?> getByWeek(WeekId weekId);

  /// `true` si ya existe el guard de esa semana (`weeklySchedules/{weekId}`).
  Future<bool> exists(WeekId weekId);

  /// Crea **atómicamente** la agenda y sus eventos usando el guard de la semana.
  ///
  /// Si el guard ya existía (A y B abrieron la app a la vez), lanza
  /// [ScheduleGenerationConflictException] y no escribe nada (ver D2).
  Future<void> saveGenerated({
    required WeeklySchedule schedule,
    required List<ScheduledEvent> events,
  });
}
