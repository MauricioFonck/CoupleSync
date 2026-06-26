import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/result.dart';
import '../../application/services/activity_service.dart';
import '../../domain/entities/activity.dart';
import '../../domain/value_objects/ids.dart';
import 'app_providers.dart';

/// Controlador del módulo de actividades: carga la lista y ejecuta el CRUD,
/// refrescando el estado tras cada cambio. Los métodos devuelven `AppFailure?`
/// (`null` = éxito) para que la UI muestre el error sin conocer el dominio.
final activitiesControllerProvider =
    AsyncNotifierProvider<ActivitiesController, List<Activity>>(
      ActivitiesController.new,
    );

class ActivitiesController extends AsyncNotifier<List<Activity>> {
  ActivityService get _service => ref.read(activityServiceProvider);

  @override
  Future<List<Activity>> build() => _load();

  Future<List<Activity>> _load() async {
    final result = await _service.list();
    return result.fold((value) => value, (failure) => throw failure);
  }

  Future<AppFailure?> create(CreateActivityCommand command) =>
      _run(() => _service.create(command));

  Future<AppFailure?> editActivity(UpdateActivityCommand command) =>
      _run(() => _service.update(command));

  Future<AppFailure?> setActive(ActivityId id, {required bool active}) =>
      _run(() => _service.setActive(id, active: active));

  Future<AppFailure?> delete(ActivityId id) => _run(() => _service.delete(id));

  Future<AppFailure?> _run<T>(Future<Result<T>> Function() action) async {
    final failure = (await action()).failureOrNull;
    if (failure == null) {
      state = await AsyncValue.guard(_load);
    }
    return failure;
  }
}
