import '../entities/scheduled_event.dart';
import '../exceptions/domain_exception.dart';
import '../ports/scheduled_event_repository_port.dart';
import '../value_objects/ids.dart';
import '../value_objects/statuses.dart';
import '../value_objects/week_id.dart';

/// Reprograma manualmente un evento a una nueva fecha. El evento conserva su id
/// y sus actividades; se reinician sus confirmaciones y queda `pending` en la
/// nueva semana ISO.
class RescheduleEventUseCase {
  const RescheduleEventUseCase({
    required ScheduledEventRepositoryPort scheduledEventRepository,
  }) : _events = scheduledEventRepository;

  final ScheduledEventRepositoryPort _events;

  Future<ScheduledEvent> execute({
    required ScheduledEventId eventId,
    required DateTime newDate,
  }) async {
    final event = await _events.getById(eventId);
    if (event == null) {
      throw EntityNotFoundException(
        'Evento no encontrado.',
        entity: 'ScheduledEvent',
        id: eventId.value,
      );
    }
    if (event.status.isClosed) {
      throw const DomainInvariantException(
        'No se puede reprogramar un evento ya cerrado.',
      );
    }

    final moved = ScheduledEvent(
      id: event.id,
      date: newDate,
      weekId: WeekId.fromDate(newDate),
      activityIds: event.activityIds,
      status: CompletionStatus.pending,
      confirmations: const [],
      notes: event.notes,
      createdAt: event.createdAt,
    );

    await _events.save(moved);
    return moved;
  }
}
