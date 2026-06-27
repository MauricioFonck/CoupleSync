import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/app_failure.dart';
import '../../application/result.dart';
import '../../application/services/roulette_service.dart';
import '../../domain/entities/roulette_item.dart';
import '../../domain/entities/roulette_spin.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/intensity_level.dart';
import 'app_providers.dart';

/// Pool de ideas **en tiempo real** (sincronizado entre A y B).
final rouletteItemsProvider = StreamProvider<List<RouletteItem>>(
  (ref) => ref.watch(rouletteServiceProvider).watchItems(),
);

/// Historial de tiradas **en tiempo real** (más reciente primero).
final rouletteHistoryProvider = StreamProvider<List<RouletteSpin>>(
  (ref) => ref.watch(rouletteServiceProvider).watchHistory(),
);

/// Número de tiradas marcadas como "hechas".
final rouletteDoneCountProvider = Provider<int>((ref) {
  final history = ref.watch(rouletteHistoryProvider).asData?.value ?? const [];
  return history.where((s) => s.done).length;
});

/// Acciones de mutación de la ruleta. Como las listas son *streams*, no hace
/// falta recargar manualmente tras cada cambio.
final rouletteActionsProvider = Provider<RouletteActions>(
  (ref) => RouletteActions(ref.read(rouletteServiceProvider)),
);

class RouletteActions {
  const RouletteActions(this._service);

  final RouletteService _service;

  Future<AppFailure?> import(
    String multiline, {
    IntensityLevel level = IntensityLevel.medium,
  }) => _failure(_service.import(multiline.split('\n'), level: level));

  Future<AppFailure?> create(String text) => _failure(_service.create(text));

  Future<AppFailure?> toggleFavorite(RouletteItemId id) =>
      _failure(_service.toggleFavorite(id));

  Future<AppFailure?> setLevel(RouletteItemId id, IntensityLevel level) =>
      _failure(_service.setLevel(id, level));

  Future<AppFailure?> delete(RouletteItemId id) =>
      _failure(_service.delete(id));

  Future<AppFailure?> _failure<T>(Future<Result<T>> action) async =>
      (await action).failureOrNull;
}
