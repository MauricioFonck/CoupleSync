import 'package:couplesync/domain/entities/roulette_item.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/use_cases/roulette_use_cases.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  RouletteItem item(String id, {bool favorite = false}) =>
      RouletteItem(id: RouletteItemId(id), text: id, favorite: favorite);

  group('ImportRouletteItemsUseCase', () {
    test('importa líneas no vacías y las persiste', () async {
      final repo = InMemoryRouletteRepository();
      final uc = ImportRouletteItemsUseCase(
        rouletteRepository: repo,
        idGenerator: SeqIdGenerator(),
      );

      final count = await uc.execute(['  Idea A ', '', '   ', 'Idea B']);
      expect(count, 2);
      expect(repo.store.length, 2);
      expect(repo.store.values.every((i) => !i.favorite), isTrue);
    });

    test('lanza si no hay ideas válidas', () {
      final uc = ImportRouletteItemsUseCase(
        rouletteRepository: InMemoryRouletteRepository(),
        idGenerator: SeqIdGenerator(),
      );
      expect(
        () => uc.execute(['', '   ']),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });

  group('DrawRouletteUseCase', () {
    test('saca N del pool (recorta a su tamaño)', () {
      final uc = DrawRouletteUseCase(random: FakeRandom());
      final pool = [item('a'), item('b'), item('c')];
      expect(uc.execute(pool, count: 2).length, 2);
      expect(uc.execute(pool, count: 10).length, 3);
    });

    test('lanza si el pool está vacío', () {
      expect(
        () => DrawRouletteUseCase(random: FakeRandom()).execute([]),
        throwsA(isA<DomainInvariantException>()),
      );
    });
  });

  group('SpinRouletteUseCase', () {
    test('elige uno del subconjunto', () {
      final uc = SpinRouletteUseCase(random: FakeRandom());
      expect(uc.execute([item('a'), item('b')]).id, RouletteItemId('a'));
    });
  });

  group('SpinFavoriteUseCase', () {
    test('elige un favorito', () {
      final uc = SpinFavoriteUseCase(random: FakeRandom());
      final pool = [
        item('a'),
        item('b', favorite: true),
        item('c', favorite: true),
      ];
      expect(uc.execute(pool).favorite, isTrue);
    });

    test('lanza si no hay favoritos', () {
      expect(
        () => SpinFavoriteUseCase(random: FakeRandom()).execute([item('a')]),
        throwsA(isA<DomainInvariantException>()),
      );
    });
  });
}
