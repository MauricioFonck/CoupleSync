import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/commands/commands.dart';
import '../../application/result.dart';
import '../../application/services/penalty_service.dart';
import '../../domain/entities/penalty.dart';
import '../../domain/value_objects/ids.dart';
import 'app_providers.dart';

final penaltiesControllerProvider =
    AsyncNotifierProvider<PenaltiesController, List<Penalty>>(
  PenaltiesController.new,
);

class PenaltiesController extends AsyncNotifier<List<Penalty>> {
  PenaltyService get _service => ref.read(penaltyServiceProvider);

  @override
  Future<List<Penalty>> build() => _load();

  Future<List<Penalty>> _load() async {
    final result = await _service.list();
    return result.fold((value) => value, (failure) => throw failure);
  }

  Future<AppFailure?> create(CreatePenaltyCommand command) =>
      _run(() => _service.create(command));

  Future<AppFailure?> editPenalty(UpdatePenaltyCommand command) =>
      _run(() => _service.update(command));

  Future<AppFailure?> setActive(PenaltyId id, {required bool active}) =>
      _run(() => _service.setActive(id, active: active));

  Future<AppFailure?> delete(PenaltyId id) => _run(() => _service.delete(id));

  Future<AppFailure?> _run<T>(Future<Result<T>> Function() action) async {
    final failure = (await action()).failureOrNull;
    if (failure == null) {
      state = await AsyncValue.guard(_load);
    }
    return failure;
  }
}
