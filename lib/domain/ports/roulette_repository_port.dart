import '../entities/roulette_item.dart';
import '../value_objects/ids.dart';

/// Puerto de persistencia de los ítems de la ruleta.
abstract interface class RouletteRepositoryPort {
  Future<List<RouletteItem>> getAll();
  Future<RouletteItem?> getById(RouletteItemId id);
  Future<void> save(RouletteItem item);

  /// Alta masiva (importador de la lista inicial).
  Future<void> saveAll(List<RouletteItem> items);
  Future<void> delete(RouletteItemId id);
}
