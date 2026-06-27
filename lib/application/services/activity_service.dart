import '../../domain/entities/activity.dart';
import '../../domain/ports/activity_repository_port.dart';
import '../../domain/use_cases/activity_use_cases.dart';
import '../../domain/value_objects/ids.dart';
import '../commands/commands.dart';
import '../queries/queries.dart';
import '../result.dart';

/// Orquesta los casos de uso de actividades y expone resultados [Result].
class ActivityService {
  const ActivityService({
    required CreateActivityUseCase createActivity,
    required UpdateActivityUseCase updateActivity,
    required SetActivityActiveUseCase setActivityActive,
    required DeleteActivityUseCase deleteActivity,
    required ActivityRepositoryPort activityRepository,
  }) : _create = createActivity,
       _update = updateActivity,
       _setActive = setActivityActive,
       _delete = deleteActivity,
       _repository = activityRepository;

  final CreateActivityUseCase _create;
  final UpdateActivityUseCase _update;
  final SetActivityActiveUseCase _setActive;
  final DeleteActivityUseCase _delete;
  final ActivityRepositoryPort _repository;

  /// Flujo en tiempo real de todas las actividades (sincronizado entre A y B).
  Stream<List<Activity>> watchAll() => _repository.watchAll();

  Future<Result<Activity>> create(CreateActivityCommand command) => runCatching(
    () => _create.execute(
      title: command.title,
      description: command.description,
      category: command.category,
      createdBy: command.createdBy,
      imageId: command.imageId,
    ),
  );

  Future<Result<Activity>> update(UpdateActivityCommand command) => runCatching(
    () => _update.execute(
      id: command.id,
      title: command.title,
      description: command.description,
      category: command.category,
      imageId: command.imageId,
      clearImage: command.clearImage,
    ),
  );

  Future<Result<Activity>> setActive(ActivityId id, {required bool active}) =>
      runCatching(() => _setActive.execute(id: id, active: active));

  Future<Result<void>> delete(ActivityId id) =>
      runCatching(() => _delete.execute(id));

  Future<Result<List<Activity>>> list([
    ActivitiesQuery query = const ActivitiesQuery(),
  ]) => runCatching(
    () => query.onlyActive ? _repository.getActive() : _repository.getAll(),
  );
}
