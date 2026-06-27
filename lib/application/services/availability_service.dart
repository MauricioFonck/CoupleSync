import '../../domain/entities/availability.dart';
import '../../domain/ports/availability_repository_port.dart';
import '../../domain/use_cases/availability_use_cases.dart';
import '../../domain/value_objects/ids.dart';
import '../queries/queries.dart';
import '../result.dart';

/// Orquesta la lectura/escritura de disponibilidad.
class AvailabilityService {
  const AvailabilityService({
    required GetAvailabilityUseCase getAvailability,
    required SetAvailabilityUseCase setAvailability,
    required AvailabilityRepositoryPort availabilityRepository,
  }) : _get = getAvailability,
       _set = setAvailability,
       _repository = availabilityRepository;

  final GetAvailabilityUseCase _get;
  final SetAvailabilityUseCase _set;
  final AvailabilityRepositoryPort _repository;

  Future<Result<Availability>> get(AvailabilityQuery query) =>
      runCatching(() => _get.execute(query.userId));

  /// Flujo en tiempo real de la disponibilidad del usuario.
  Stream<Availability> watch(UserId userId) => _repository.watchForUser(userId);

  Future<Result<void>> set(Availability availability) =>
      runCatching(() => _set.execute(availability));
}
