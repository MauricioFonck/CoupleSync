import 'package:couplesync/application/services/roulette_service.dart';
import 'package:couplesync/domain/entities/roulette_item.dart';
import 'package:couplesync/domain/use_cases/roulette_use_cases.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/intensity_level.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/use_cases/_fakes.dart';

void main() {
  late InMemoryRouletteRepository items;
  late InMemoryRouletteHistoryRepository history;
  late RouletteService service;

  RouletteService build() => RouletteService(
    rouletteRepository: items,
    historyRepository: history,
    idGenerator: SeqIdGenerator(),
    clock: FakeClock(DateTime.utc(2026, 6, 26)),
    importItems: ImportRouletteItemsUseCase(
      rouletteRepository: items,
      idGenerator: SeqIdGenerator(),
    ),
    drawRoulette: DrawRouletteUseCase(random: FakeRandom()),
    spinRoulette: SpinRouletteUseCase(random: FakeRandom()),
    spinFavorite: SpinFavoriteUseCase(random: FakeRandom()),
  );

  RouletteItem item(
    String id, {
    bool favorite = false,
    IntensityLevel level = IntensityLevel.medium,
  }) => RouletteItem(
    id: RouletteItemId(id),
    text: id,
    favorite: favorite,
    level: level,
  );

  setUp(() {
    items = InMemoryRouletteRepository();
    history = InMemoryRouletteHistoryRepository();
    service = build();
  });

  test('import asigna el nivel indicado', () async {
    await service.import(['Idea 1', 'Idea 2'], level: IntensityLevel.hard);
    final all = (await service.all()).valueOrNull!;
    expect(all.length, 2);
    expect(all.every((i) => i.level == IntensityLevel.hard), isTrue);
  });

  test('draw filtra por niveles', () async {
    items.store['a'] = item('a', level: IntensityLevel.soft);
    items.store['b'] = item('b', level: IntensityLevel.hard);

    final soft = (await service.draw(
      levels: {IntensityLevel.soft},
    )).valueOrNull!;
    expect(soft.map((i) => i.id.value), ['a']);
  });

  test('spin registra una tirada en el historial', () async {
    final result = await service.spin([item('a')]);
    final spin = result.valueOrNull!;
    expect(spin.text, 'a');
    expect(spin.done, isFalse);
    expect(history.store.length, 1);
  });

  test('markDone marca la tirada como hecha', () async {
    final spin = (await service.spin([item('a')])).valueOrNull!;
    final done = (await service.markDone(spin.id)).valueOrNull!;
    expect(done.done, isTrue);
    expect((await service.history()).valueOrNull!.first.done, isTrue);
  });

  test('spinFavorite respeta nivel y favoritos', () async {
    items.store['a'] = item('a', favorite: true, level: IntensityLevel.soft);
    items.store['b'] = item('b', favorite: true, level: IntensityLevel.hard);

    final result = await service.spinFavorite(levels: {IntensityLevel.hard});
    expect(result.valueOrNull!.text, 'b');
  });
}
