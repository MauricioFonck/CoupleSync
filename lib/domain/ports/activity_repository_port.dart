import '../entities/activity.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de actividades. Implementado en infraestructura.
abstract interface class ActivityRepositoryPort {
  Future<List<Activity>> getAll();

  /// Flujo en tiempo real de todas las actividades.
  Stream<List<Activity>> watchAll();
  Future<List<Activity>> getActive();
  Future<Activity?> getById(ActivityId id);
  Future<void> save(Activity activity);
  Future<void> delete(ActivityId id);
}
