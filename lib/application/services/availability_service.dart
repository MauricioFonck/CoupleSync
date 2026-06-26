import '../../domain/entities/availability.dart';
import '../../domain/use_cases/availability_use_cases.dart';
import '../queries/queries.dart';
import '../result.dart';

/// Orquesta la lectura/escritura de disponibilidad.
class AvailabilityService {
  const AvailabilityService({
    required GetAvailabilityUseCase getAvailability,
    required SetAvailabilityUseCase setAvailability,
  })  : _get = getAvailability,
        _set = setAvailability;

  final GetAvailabilityUseCase _get;
  final SetAvailabilityUseCase _set;

  Future<Result<Availability>> get(AvailabilityQuery query) =>
      runCatching(() => _get.execute(query.userId));

  Future<Result<void>> set(Availability availability) =>
      runCatching(() => _set.execute(availability));
}
