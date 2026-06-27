import 'dart:math' as math;

import '../entities/roulette_item.dart';
import '../exceptions/domain_exception.dart';
import '../ports/id_generator_port.dart';
import '../ports/random_port.dart';
import '../ports/roulette_repository_port.dart';
import '../value_objects/ids.dart';

/// Importa una lista de textos (una idea por línea) como ítems no favoritos.
/// Ignora líneas vacías. Devuelve el número de ítems creados.
class ImportRouletteItemsUseCase {
  const ImportRouletteItemsUseCase({
    required RouletteRepositoryPort rouletteRepository,
    required IdGeneratorPort idGenerator,
  }) : _repository = rouletteRepository,
       _idGenerator = idGenerator;

  final RouletteRepositoryPort _repository;
  final IdGeneratorPort _idGenerator;

  Future<int> execute(List<String> texts) async {
    final items = texts
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .map(
          (t) => RouletteItem(
            id: RouletteItemId(_idGenerator.newId()),
            text: t,
            favorite: false,
          ),
        )
        .toList();
    if (items.isEmpty) {
      throw const DomainValidationException(
        'No hay ideas válidas para importar.',
      );
    }
    await _repository.saveAll(items);
    return items.length;
  }
}

/// Saca un subconjunto aleatorio (por defecto 20) del pool. "Revolver" = volver
/// a llamar para obtener otros distintos.
class DrawRouletteUseCase {
  const DrawRouletteUseCase({required RandomPort random}) : _random = random;

  final RandomPort _random;

  List<RouletteItem> execute(List<RouletteItem> pool, {int count = 20}) {
    if (pool.isEmpty) {
      throw const DomainInvariantException('La ruleta no tiene ideas todavía.');
    }
    final take = math.min(count, pool.length);
    return _random.shuffled(pool).take(take).toList();
  }
}

/// Gira: elige uno al azar entre los ítems dados (el subconjunto visible).
class SpinRouletteUseCase {
  const SpinRouletteUseCase({required RandomPort random}) : _random = random;

  final RandomPort _random;

  RouletteItem execute(List<RouletteItem> items) {
    if (items.isEmpty) {
      throw const DomainInvariantException('No hay ideas para girar.');
    }
    return items[_random.nextInt(items.length)];
  }
}

/// Gira hasta algo bueno: elige un favorito al azar del pool.
class SpinFavoriteUseCase {
  const SpinFavoriteUseCase({required RandomPort random}) : _random = random;

  final RandomPort _random;

  RouletteItem execute(List<RouletteItem> pool) {
    final favorites = pool.where((i) => i.favorite).toList();
    if (favorites.isEmpty) {
      throw const DomainInvariantException(
        'No hay favoritos marcados todavía.',
      );
    }
    return favorites[_random.nextInt(favorites.length)];
  }
}
