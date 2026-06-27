import '../../domain/entities/roulette_item.dart';
import '../../domain/entities/roulette_spin.dart';
import '../../domain/exceptions/domain_exception.dart';
import '../../domain/ports/clock_port.dart';
import '../../domain/ports/id_generator_port.dart';
import '../../domain/ports/roulette_history_repository_port.dart';
import '../../domain/ports/roulette_repository_port.dart';
import '../../domain/use_cases/roulette_use_cases.dart';
import '../../domain/value_objects/ids.dart';
import '../../domain/value_objects/intensity_level.dart';
import '../result.dart';

/// Orquesta el módulo de ruleta: gestión de ideas (CRUD + importador + nivel),
/// modos de juego (sacar 20, revolver, girar, girar hasta algo bueno) con filtro
/// por intensidad, e historial de tiradas con marca "hecho".
class RouletteService {
  const RouletteService({
    required RouletteRepositoryPort rouletteRepository,
    required RouletteHistoryRepositoryPort historyRepository,
    required IdGeneratorPort idGenerator,
    required ClockPort clock,
    required ImportRouletteItemsUseCase importItems,
    required DrawRouletteUseCase drawRoulette,
    required SpinRouletteUseCase spinRoulette,
    required SpinFavoriteUseCase spinFavorite,
  }) : _repository = rouletteRepository,
       _history = historyRepository,
       _idGenerator = idGenerator,
       _clock = clock,
       _import = importItems,
       _draw = drawRoulette,
       _spin = spinRoulette,
       _spinFavorite = spinFavorite;

  final RouletteRepositoryPort _repository;
  final RouletteHistoryRepositoryPort _history;
  final IdGeneratorPort _idGenerator;
  final ClockPort _clock;
  final ImportRouletteItemsUseCase _import;
  final DrawRouletteUseCase _draw;
  final SpinRouletteUseCase _spin;
  final SpinFavoriteUseCase _spinFavorite;

  Future<Result<List<RouletteItem>>> all() => runCatching(_repository.getAll);

  /// Flujo en tiempo real del pool de ideas.
  Stream<List<RouletteItem>> watchItems() => _repository.watchAll();

  /// Flujo en tiempo real del historial (más reciente primero).
  Stream<List<RouletteSpin>> watchHistory() => _history.watchAll().map(
    (spins) =>
        spins.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
  );

  Future<Result<int>> import(
    List<String> lines, {
    IntensityLevel level = IntensityLevel.medium,
  }) => runCatching(() => _import.execute(lines, level: level));

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

  Future<Result<RouletteItem>> setLevel(
    RouletteItemId id,
    IntensityLevel level,
  ) => runCatching(() async {
    final current = await _requireItem(id);
    final updated = current.copyWith(level: level);
    await _repository.save(updated);
    return updated;
  });

  Future<Result<void>> delete(RouletteItemId id) =>
      runCatching(() => _repository.delete(id));

  /// Saca 20 (o [count]) ideas al azar del pool, filtrando por [levels] si se
  /// indican.
  Future<Result<List<RouletteItem>>> draw({
    int count = 20,
    Set<IntensityLevel>? levels,
  }) => runCatching(() async {
    final pool = _filter(await _repository.getAll(), levels);
    return _draw.execute(pool, count: count);
  });

  /// Gira sobre el subconjunto visible, registra la tirada y la devuelve.
  Future<Result<RouletteSpin>> spin(List<RouletteItem> subset) =>
      runCatching(() async => _record(_spin.execute(subset)));

  /// Gira hasta algo bueno (un favorito del pool, filtrable por [levels]).
  Future<Result<RouletteSpin>> spinFavorite({Set<IntensityLevel>? levels}) =>
      runCatching(() async {
        final pool = _filter(await _repository.getAll(), levels);
        return _record(_spinFavorite.execute(pool));
      });

  /// Marca una tirada como "hecha".
  Future<Result<RouletteSpin>> markDone(RouletteSpinId id) =>
      runCatching(() async {
        final spin = await _history.getById(id);
        if (spin == null) {
          throw EntityNotFoundException(
            'Tirada no encontrada.',
            entity: 'RouletteSpin',
            id: id.value,
          );
        }
        final updated = spin.copyWith(done: true);
        await _history.save(updated);
        return updated;
      });

  /// Historial de tiradas, de más reciente a más antigua.
  Future<Result<List<RouletteSpin>>> history() => runCatching(() async {
    final spins = await _history.getAll();
    return spins.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  });

  List<RouletteItem> _filter(
    List<RouletteItem> pool,
    Set<IntensityLevel>? levels,
  ) {
    if (levels == null || levels.isEmpty) return pool;
    return pool.where((i) => levels.contains(i.level)).toList();
  }

  Future<RouletteSpin> _record(RouletteItem item) async {
    final spin = RouletteSpin(
      id: RouletteSpinId(_idGenerator.newId()),
      itemId: item.id,
      text: item.text,
      level: item.level,
      createdAt: _clock.now(),
      done: false,
    );
    await _history.add(spin);
    return spin;
  }

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
