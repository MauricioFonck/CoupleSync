import '../../domain/entities/roulette_item.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/ports/id_generator_port.dart';
import '../../domain/ports/roulette_repository_port.dart';
import '../../domain/use_cases/roulette_use_cases.dart';
import '../../domain/value_objects/ids.dart';
import '../result.dart';

/// Orquesta el módulo de ruleta: gestión de ideas (CRUD + importador) y los
/// modos de juego (sacar 20, revolver, girar, girar hasta algo bueno).
class RouletteService {
  const RouletteService({
    required RouletteRepositoryPort rouletteRepository,
    required IdGeneratorPort idGenerator,
    required ImportRouletteItemsUseCase importItems,
    required DrawRouletteUseCase drawRoulette,
    required SpinRouletteUseCase spinRoulette,
    required SpinFavoriteUseCase spinFavorite,
  }) : _repository = rouletteRepository,
       _idGenerator = idGenerator,
       _import = importItems,
       _draw = drawRoulette,
       _spin = spinRoulette,
       _spinFavorite = spinFavorite;

  final RouletteRepositoryPort _repository;
  final IdGeneratorPort _idGenerator;
  final ImportRouletteItemsUseCase _import;
  final DrawRouletteUseCase _draw;
  final SpinRouletteUseCase _spin;
  final SpinFavoriteUseCase _spinFavorite;

  Future<Result<List<RouletteItem>>> all() => runCatching(_repository.getAll);

  Future<Result<int>> import(List<String> lines) =>
      runCatching(() => _import.execute(lines));

  Future<Result<RouletteItem>> create(String text) => runCatching(() async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      throw const DomainValidationException('La idea no puede estar vacía.');
    }
    final item = RouletteItem(
      id: RouletteItemId(_idGenerator.newId()),
      text: trimmed,
      favorite: false,
    );
    await _repository.save(item);
    return item;
  });

  Future<Result<RouletteItem>> updateText(RouletteItemId id, String text) =>
      runCatching(() async {
        final current = await _requireItem(id);
        final updated = current.copyWith(text: text.trim());
        await _repository.save(updated);
        return updated;
      });

  Future<Result<RouletteItem>> toggleFavorite(RouletteItemId id) =>
      runCatching(() async {
        final current = await _requireItem(id);
        final updated = current.copyWith(favorite: !current.favorite);
        await _repository.save(updated);
        return updated;
      });

  Future<Result<void>> delete(RouletteItemId id) =>
      runCatching(() => _repository.delete(id));

  /// Saca 20 (o [count]) ideas al azar del pool.
  Future<Result<List<RouletteItem>>> draw({int count = 20}) =>
      runCatching(() async {
        final pool = await _repository.getAll();
        return _draw.execute(pool, count: count);
      });

  /// Gira sobre el subconjunto visible y devuelve la elegida.
  Future<Result<RouletteItem>> spin(List<RouletteItem> subset) =>
      runCatching(() async => _spin.execute(subset));

  /// Gira hasta algo bueno: devuelve un favorito al azar del pool.
  Future<Result<RouletteItem>> spinFavorite() => runCatching(() async {
    final pool = await _repository.getAll();
    return _spinFavorite.execute(pool);
  });

  Future<RouletteItem> _requireItem(RouletteItemId id) async {
    final current = await _repository.getById(id);
    if (current == null) {
      throw EntityNotFoundException(
        'Ítem de ruleta no encontrado.',
        entity: 'RouletteItem',
        id: id.value,
      );
    }
    return current;
  }
}
