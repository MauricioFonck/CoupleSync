import '../entities/availability.dart';
import '../ports/availability_repository_port.dart';
import '../value_objects/ids.dart';

/// Obtiene la disponibilidad de un usuario (vacía si no la configuró).
class GetAvailabilityUseCase {
  const GetAvailabilityUseCase({
    required AvailabilityRepositoryPort availabilityRepository,
  }) : _repository = availabilityRepository;

  final AvailabilityRepositoryPort _repository;

  Future<Availability> execute(UserId userId) => _repository.getForUser(userId);
}

/// Guarda/actualiza la disponibilidad de un usuario.
class SetAvailabilityUseCase {
  const SetAvailabilityUseCase({
    required AvailabilityRepositoryPort availabilityRepository,
  }) : _repository = availabilityRepository;

  final AvailabilityRepositoryPort _repository;

  Future<void> execute(Availability availability) =>
      _repository.save(availability);
}
