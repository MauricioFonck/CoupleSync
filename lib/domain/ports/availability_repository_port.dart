import '../entities/availability.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de disponibilidad por usuario.
abstract interface class AvailabilityRepositoryPort {
  /// Devuelve la disponibilidad del usuario; vacía si nunca la configuró.
  Future<Availability> getForUser(UserId userId);
  Future<void> save(Availability availability);
}
