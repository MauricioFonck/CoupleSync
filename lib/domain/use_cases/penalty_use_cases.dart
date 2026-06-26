import '../entities/penalty.dart';
import '../exceptions/domain_exception.dart';
import '../ports/id_generator_port.dart';
import '../ports/penalty_repository_port.dart';
import '../value_objects/ids.dart';
import '../value_objects/severity.dart';

/// Crea una penitencia nueva (activa por defecto).
class CreatePenaltyUseCase {
  const CreatePenaltyUseCase({
    required PenaltyRepositoryPort penaltyRepository,
    required IdGeneratorPort idGenerator,
  }) : _repository = penaltyRepository,
       _idGenerator = idGenerator;

  final PenaltyRepositoryPort _repository;
  final IdGeneratorPort _idGenerator;

  Future<Penalty> execute({
    required String title,
    required String description,
    required Severity severity,
    MediaId? imageId,
  }) async {
    if (title.trim().isEmpty) {
      throw const DomainValidationException('El título no puede estar vacío.');
    }
    final penalty = Penalty(
      id: PenaltyId(_idGenerator.newId()),
      title: title.trim(),
      description: description.trim(),
      severity: severity,
      active: true,
      imageId: imageId,
    );
    await _repository.save(penalty);
    return penalty;
  }
}

/// Actualiza una penitencia existente.
class UpdatePenaltyUseCase {
  const UpdatePenaltyUseCase({required PenaltyRepositoryPort penaltyRepository})
    : _repository = penaltyRepository;

  final PenaltyRepositoryPort _repository;

  Future<Penalty> execute({
    required PenaltyId id,
    String? title,
    String? description,
    Severity? severity,
    MediaId? imageId,
    bool clearImage = false,
  }) async {
    final current = await _repository.getById(id);
    if (current == null) {
      throw EntityNotFoundException(
        'Penitencia no encontrada.',
        entity: 'Penalty',
        id: id.value,
      );
    }
    final updated = current.copyWith(
      title: title?.trim(),
      description: description?.trim(),
      severity: severity,
      imageId: imageId,
      clearImage: clearImage,
    );
    await _repository.save(updated);
    return updated;
  }
}

/// Activa o desactiva una penitencia.
class SetPenaltyActiveUseCase {
  const SetPenaltyActiveUseCase({
    required PenaltyRepositoryPort penaltyRepository,
  }) : _repository = penaltyRepository;

  final PenaltyRepositoryPort _repository;

  Future<Penalty> execute({required PenaltyId id, required bool active}) async {
    final current = await _repository.getById(id);
    if (current == null) {
      throw EntityNotFoundException(
        'Penitencia no encontrada.',
        entity: 'Penalty',
        id: id.value,
      );
    }
    final updated = current.copyWith(active: active);
    await _repository.save(updated);
    return updated;
  }
}

/// Elimina una penitencia.
class DeletePenaltyUseCase {
  const DeletePenaltyUseCase({required PenaltyRepositoryPort penaltyRepository})
    : _repository = penaltyRepository;

  final PenaltyRepositoryPort _repository;

  Future<void> execute(PenaltyId id) => _repository.delete(id);
}
