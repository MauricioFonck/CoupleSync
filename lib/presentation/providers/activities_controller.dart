import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/result.dart';
import '../../application/services/activity_service.dart';
import '../../domain/entities/activity.dart';
import '../../domain/value_objects/ids.dart';
import 'app_providers.dart';

/// Lista de actividades **en tiempo real** (sincronizada entre A y B).
final activitiesProvider = StreamProvider<List<Activity>>(
  (ref) => ref.watch(activityServiceProvider).watchAll(),
);

/// Acciones de mutación de actividades. Como la lista es un *stream*, no hace
/// falta recargar manualmente tras cada cambio. Devuelven `AppFailure?`
/// (`null` = éxito) para que la UI muestre el error sin conocer el dominio.
final activitiesActionsProvider = Provider<ActivitiesActions>(
  (ref) => ActivitiesActions(ref.read(activityServiceProvider)),
);

class ActivitiesActions {
  const ActivitiesActions(this._service);

  final ActivityService _service;

  Future<AppFailure?> create(CreateActivityCommand command) =>
      _failure(_service.create(command));

  Future<AppFailure?> editActivity(UpdateActivityCommand command) =>
      _failure(_service.update(command));

  Future<AppFailure?> setActive(ActivityId id, {required bool active}) =>
      _failure(_service.setActive(id, active: active));

  Future<AppFailure?> delete(ActivityId id) => _failure(_service.delete(id));

  Future<AppFailure?> _failure<T>(Future<Result<T>> action) async =>
      (await action).failureOrNull;
}
