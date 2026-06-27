import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/result.dart';
import '../../application/services/roulette_service.dart';
import '../../domain/entities/roulette_item.dart';
import '../../domain/entities/roulette_spin.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/intensity_level.dart';
import 'app_providers.dart';

/// Carga el pool completo de ideas de la ruleta y orquesta su gestión.
final rouletteControllerProvider =
    AsyncNotifierProvider<RouletteController, List<RouletteItem>>(
      RouletteController.new,
    );

class RouletteController extends AsyncNotifier<List<RouletteItem>> {
  RouletteService get _service => ref.read(rouletteServiceProvider);

  @override
  Future<List<RouletteItem>> build() => _load();

  Future<List<RouletteItem>> _load() async {
    final result = await _service.all();
    return result.fold((value) => value, (failure) => throw failure);
  }

  Future<AppFailure?> import(
    String multiline, {
    IntensityLevel level = IntensityLevel.medium,
  }) => _run(() => _service.import(multiline.split('\n'), level: level));

  Future<AppFailure?> create(String text) => _run(() => _service.create(text));

  Future<AppFailure?> toggleFavorite(RouletteItemId id) =>
      _run(() => _service.toggleFavorite(id));

  Future<AppFailure?> setLevel(RouletteItemId id, IntensityLevel level) =>
      _run(() => _service.setLevel(id, level));

  Future<AppFailure?> delete(RouletteItemId id) =>
      _run(() => _service.delete(id));

  Future<AppFailure?> _run<T>(Future<Result<T>> Function() action) async {
    final failure = (await action()).failureOrNull;
    if (failure == null) {
      state = await AsyncValue.guard(_load);
    }
    return failure;
  }
}

/// Historial de tiradas (más reciente primero).
final rouletteHistoryProvider = FutureProvider<List<RouletteSpin>>((ref) async {
  final result = await ref.watch(rouletteServiceProvider).history();
  return result.fold((value) => value, (failure) => throw failure);
});

/// Número de tiradas marcadas como "hechas".
final rouletteDoneCountProvider = Provider<int>((ref) {
  final history = ref.watch(rouletteHistoryProvider).asData?.value ?? const [];
  return history.where((s) => s.done).length;
});
