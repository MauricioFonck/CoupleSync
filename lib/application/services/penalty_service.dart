import '../../domain/entities/penalty.dart';
import '../../domain/ports/penalty_repository_port.dart';
import '../../domain/use_cases/generate_penalty_use_case.dart';
import '../../domain/use_cases/penalty_use_cases.dart';
import '../../domain/value_objects/ids.dart';
import '../commands/commands.dart';
import '../queries/queries.dart';
import '../result.dart';

/// Orquesta los casos de uso de penitencias.
class PenaltyService {
  const PenaltyService({
    required CreatePenaltyUseCase createPenalty,
    required UpdatePenaltyUseCase updatePenalty,
    required SetPenaltyActiveUseCase setPenaltyActive,
    required DeletePenaltyUseCase deletePenalty,
    required GeneratePenaltyUseCase generatePenalty,
    required PenaltyRepositoryPort penaltyRepository,
  }) : _create = createPenalty,
       _update = updatePenalty,
       _setActive = setPenaltyActive,
       _delete = deletePenalty,
       _generate = generatePenalty,
       _repository = penaltyRepository;

  final CreatePenaltyUseCase _create;
  final UpdatePenaltyUseCase _update;
  final SetPenaltyActiveUseCase _setActive;
  final DeletePenaltyUseCase _delete;
  final GeneratePenaltyUseCase _generate;
  final PenaltyRepositoryPort _repository;

  Future<Result<Penalty>> create(CreatePenaltyCommand command) => runCatching(
    () => _create.execute(
      title: command.title,
      description: command.description,
      severity: command.severity,
      imageId: command.imageId,
    ),
  );

  Future<Result<Penalty>> update(UpdatePenaltyCommand command) => runCatching(
    () => _update.execute(
      id: command.id,
      title: command.title,
      description: command.description,
      severity: command.severity,
      imageId: command.imageId,
      clearImage: command.clearImage,
    ),
  );

  Future<Result<Penalty>> setActive(PenaltyId id, {required bool active}) =>
      runCatching(() => _setActive.execute(id: id, active: active));

  Future<Result<void>> delete(PenaltyId id) =>
      runCatching(() => _delete.execute(id));

  /// Selecciona una penitencia activa (p. ej. al fallar un evento).
  Future<Result<Penalty>> generate() => runCatching(() => _generate.execute());

  Future<Result<List<Penalty>>> list([
    PenaltiesQuery query = const PenaltiesQuery(),
  ]) => runCatching(
    () => query.onlyActive ? _repository.getActive() : _repository.getAll(),
  );
}
