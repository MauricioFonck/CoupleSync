import '../entities/activity.dart';
import '../exceptions/domain_exception.dart';
import '../ports/activity_repository_port.dart';
import '../ports/clock_port.dart';
import '../ports/id_generator_port.dart';
import '../value_objects/activity_category.dart';
import '../value_objects/ids.dart';

/// Crea una actividad nueva (activa por defecto) con id y timestamps generados.
class CreateActivityUseCase {
  const CreateActivityUseCase({
    required ActivityRepositoryPort activityRepository,
    required IdGeneratorPort idGenerator,
    required ClockPort clock,
  })  : _repository = activityRepository,
        _idGenerator = idGenerator,
        _clock = clock;

  final ActivityRepositoryPort _repository;
  final IdGeneratorPort _idGenerator;
  final ClockPort _clock;

  Future<Activity> execute({
    required String title,
    required String description,
    required ActivityCategory category,
    required UserId createdBy,
    MediaId? imageId,
  }) async {
    if (title.trim().isEmpty) {
      throw const DomainValidationException('El título no puede estar vacío.');
    }
    final now = _clock.now();
    final activity = Activity(
      id: ActivityId(_idGenerator.newId()),
      title: title.trim(),
      description: description.trim(),
      category: category,
      createdBy: createdBy,
      active: true,
      imageId: imageId,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.save(activity);
    return activity;
  }
}

/// Actualiza campos editables de una actividad existente y toca `updatedAt`.
class UpdateActivityUseCase {
  const UpdateActivityUseCase({
    required ActivityRepositoryPort activityRepository,
    required ClockPort clock,
  })  : _repository = activityRepository,
        _clock = clock;

  final ActivityRepositoryPort _repository;
  final ClockPort _clock;

  Future<Activity> execute({
    required ActivityId id,
    String? title,
    String? description,
    ActivityCategory? category,
    MediaId? imageId,
    bool clearImage = false,
  }) async {
    final current = await _repository.getById(id);
    if (current == null) {
      throw EntityNotFoundException(
        'Actividad no encontrada.',
        entity: 'Activity',
        id: id.value,
      );
    }
    final updated = current.copyWith(
      title: title?.trim(),
      description: description?.trim(),
      category: category,
      imageId: imageId,
      clearImage: clearImage,
      updatedAt: _clock.now(),
    );
    await _repository.save(updated);
    return updated;
  }
}

/// Activa o desactiva una actividad.
class SetActivityActiveUseCase {
  const SetActivityActiveUseCase({
    required ActivityRepositoryPort activityRepository,
    required ClockPort clock,
  })  : _repository = activityRepository,
        _clock = clock;

  final ActivityRepositoryPort _repository;
  final ClockPort _clock;

  Future<Activity> execute({
    required ActivityId id,
    required bool active,
  }) async {
    final current = await _repository.getById(id);
    if (current == null) {
      throw EntityNotFoundException(
        'Actividad no encontrada.',
        entity: 'Activity',
        id: id.value,
      );
    }
    final updated = current.copyWith(active: active, updatedAt: _clock.now());
    await _repository.save(updated);
    return updated;
  }
}

/// Elimina una actividad.
class DeleteActivityUseCase {
  const DeleteActivityUseCase({
    required ActivityRepositoryPort activityRepository,
  }) : _repository = activityRepository;

  final ActivityRepositoryPort _repository;

  Future<void> execute(ActivityId id) => _repository.delete(id);
}
