import '../entities/penalty.dart';
import '../exceptions/domain_exception.dart';
import '../ports/penalty_repository_port.dart';
import '../ports/random_port.dart';

/// Selecciona aleatoriamente una penitencia activa (p. ej. al fallar un evento).
/// La selección es determinista en tests vía [RandomPort].
class GeneratePenaltyUseCase {
  const GeneratePenaltyUseCase({
    required PenaltyRepositoryPort penaltyRepository,
    required RandomPort random,
  })  : _repository = penaltyRepository,
        _random = random;

  final PenaltyRepositoryPort _repository;
  final RandomPort _random;

  Future<Penalty> execute() async {
    final active = await _repository.getActive();
    if (active.isEmpty) {
      throw const DomainInvariantException(
        'No hay penitencias activas para asignar.',
      );
    }
    final index = _random.nextInt(active.length);
    return active[index];
  }
}
