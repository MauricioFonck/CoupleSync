import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/result.dart';
import '../../application/services/penalty_service.dart';
import '../../domain/entities/penalty.dart';
import '../../domain/value_objects/ids.dart';
import 'app_providers.dart';

/// Lista de penitencias **en tiempo real** (sincronizada entre A y B).
final penaltiesProvider = StreamProvider<List<Penalty>>(
  (ref) => ref.watch(penaltyServiceProvider).watchAll(),
);

/// Acciones de mutación de penitencias. La lista es un *stream*, así que no hay
/// que recargar manualmente tras cada cambio.
final penaltiesActionsProvider = Provider<PenaltiesActions>(
  (ref) => PenaltiesActions(ref.read(penaltyServiceProvider)),
);

class PenaltiesActions {
  const PenaltiesActions(this._service);

  final PenaltyService _service;

  Future<AppFailure?> create(CreatePenaltyCommand command) =>
      _failure(_service.create(command));

  Future<AppFailure?> editPenalty(UpdatePenaltyCommand command) =>
      _failure(_service.update(command));

  Future<AppFailure?> setActive(PenaltyId id, {required bool active}) =>
      _failure(_service.setActive(id, active: active));

  Future<AppFailure?> delete(PenaltyId id) => _failure(_service.delete(id));

  Future<AppFailure?> _failure<T>(Future<Result<T>> action) async =>
      (await action).failureOrNull;
}
