import '../entities/confirmation.dart';
import '../entities/scheduled_event.dart';
import '../exceptions/domain_exception.dart';
import '../ports/confirmation_repository_port.dart';
import '../ports/scheduled_event_repository_port.dart';
import '../value_objects/ids.dart';
import '../value_objects/statuses.dart';

/// Registra la confirmación de un usuario sobre una actividad de un evento y,
/// si **ambos** usuarios han aprobado **todas** las actividades, marca el evento
/// como `completed`.
class ConfirmActivityUseCase {
  const ConfirmActivityUseCase({
    required ScheduledEventRepositoryPort scheduledEventRepository,
    required ConfirmationRepositoryPort confirmationRepository,
  }) : _events = scheduledEventRepository,
       _confirmations = confirmationRepository;

  final ScheduledEventRepositoryPort _events;
  final ConfirmationRepositoryPort _confirmations;

  Future<ScheduledEvent> execute({
    required ScheduledEventId eventId,
    required UserId userId,
    required ActivityId activityId,
    required ConfirmationStatus status,
    required UserId partnerA,
    required UserId partnerB,
  }) async {
    final event = await _events.getById(eventId);
    if (event == null) {
      throw EntityNotFoundException(
        'Evento no encontrado.',
        entity: 'ScheduledEvent',
        id: eventId.value,
      );
    }
    if (!event.activityIds.contains(activityId)) {
      throw const DomainInvariantException(
        'La actividad no pertenece a este evento.',
      );
    }
    if (event.status.isClosed) {
      throw const DomainInvariantException(
        'No se puede confirmar un evento ya cerrado.',
      );
    }

    final confirmation = Confirmation(
      userId: userId,
      activityId: activityId,
      status: status,
    );
    // Persistencia separada por (evento, usuario, actividad) — ver D4.
    await _confirmations.upsert(eventId, confirmation);

    final updated = event.upsertConfirmation(confirmation);
    final completed = updated.isFullyApprovedBy(partnerA, partnerB)
        ? updated.copyWith(status: CompletionStatus.completed)
        : updated;

    await _events.save(completed);
    return completed;
  }
}
