import '../entities/confirmation.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de confirmaciones.
///
/// Se guardan como documentos separados por (evento, usuario, actividad) para
/// que A y B escriban en campos disjuntos y no se pisen (ver D4).
abstract interface class ConfirmationRepositoryPort {
  Future<List<Confirmation>> getForEvent(ScheduledEventId eventId);
  Future<void> upsert(ScheduledEventId eventId, Confirmation confirmation);
}
