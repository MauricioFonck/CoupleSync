import '../entities/roulette_spin.dart';
import '../value_objects/ids.dart';

/// Puerto del historial de tiradas de la ruleta.
abstract interface class RouletteHistoryRepositoryPort {
  Future<void> add(RouletteSpin spin);
  Future<List<RouletteSpin>> getAll();
  Future<RouletteSpin?> getById(RouletteSpinId id);

  /// Guarda cambios sobre una tirada existente (p. ej. marcar "hecha").
  Future<void> save(RouletteSpin spin);
}
