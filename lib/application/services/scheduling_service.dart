import '../../domain/entities/scheduled_event.dart';
import '../../domain/entities/weekly_schedule.dart';
import '../../domain/ports/scheduled_event_repository_port.dart';
import '../../domain/use_cases/generate_weekly_schedule_use_case.dart';
import '../../domain/use_cases/reschedule_event_use_case.dart';
import '../../domain/value_objects/date_range.dart';
import '../../domain/value_objects/week_id.dart';
import '../commands/commands.dart';
import '../queries/queries.dart';
import '../result.dart';

/// Orquesta la generación y reprogramación de la agenda semanal.
class SchedulingService {
  const SchedulingService({
    required GenerateWeeklyScheduleUseCase generateWeeklySchedule,
    required RescheduleEventUseCase rescheduleEvent,
    required ScheduledEventRepositoryPort scheduledEventRepository,
  }) : _generate = generateWeeklySchedule,
       _reschedule = rescheduleEvent,
       _events = scheduledEventRepository;

  final GenerateWeeklyScheduleUseCase _generate;
  final RescheduleEventUseCase _reschedule;
  final ScheduledEventRepositoryPort _events;

  Future<Result<WeeklySchedule>> generate(GenerateScheduleCommand command) =>
      runCatching(
        () => _generate.execute(
          targetWeek: command.targetWeek,
          partnerA: command.partnerA,
          partnerB: command.partnerB,
        ),
      );

  Future<Result<ScheduledEvent>> reschedule(RescheduleEventCommand command) =>
      runCatching(
        () => _reschedule.execute(
          eventId: command.eventId,
          newDate: command.newDate,
        ),
      );

  Future<Result<List<ScheduledEvent>>> eventsOfWeek(WeekEventsQuery query) =>
      runCatching(() => _events.getByWeek(query.weekId));

  /// Flujo en tiempo real de los eventos de una semana.
  Stream<List<ScheduledEvent>> watchWeek(WeekId weekId) =>
      _events.watchByWeek(weekId);

  /// Historial de eventos en un rango (para la vista de historial).
  Future<Result<List<ScheduledEvent>>> history(DateRange range) =>
      runCatching(() => _events.getByDateRange(range));

  /// Flujo en tiempo real del historial de eventos en un rango.
  Stream<List<ScheduledEvent>> watchHistory(DateRange range) =>
      _events.watchByDateRange(range);
}
