import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/use_cases/activity_use_cases.dart';
import 'package:couplesync/domain/use_cases/generate_penalty_use_case.dart';
import 'package:couplesync/domain/use_cases/penalty_use_cases.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  final userA = UserId('A');

  group('CreateActivityUseCase', () {
    test('crea activa con id y timestamps del reloj', () async {
      final repo = InMemoryActivityRepository();
      final now = DateTime.utc(2026, 6, 21, 10);
      final uc = CreateActivityUseCase(
        activityRepository: repo,
        idGenerator: SeqIdGenerator(),
        clock: FakeClock(now),
      );

      final a = await uc.execute(
        title: '  Cena  ',
        description: 'desc',
        category: ActivityCategory('Comida'),
        createdBy: userA,
      );

      expect(a.id, ActivityId('id-1'));
      expect(a.title, 'Cena');
      expect(a.active, isTrue);
      expect(a.createdAt, now);
      expect(repo.store.containsKey('id-1'), isTrue);
    });

    test('rechaza título vacío', () async {
      final uc = CreateActivityUseCase(
        activityRepository: InMemoryActivityRepository(),
        idGenerator: SeqIdGenerator(),
        clock: FakeClock(DateTime.utc(2026)),
      );
      expect(
        () => uc.execute(
          title: '   ',
          description: '',
          category: ActivityCategory('C'),
          createdBy: userA,
        ),
        throwsA(isA<DomainValidationException>()),
      );
    });
  });

  group('UpdateActivityUseCase', () {
    test('lanza si no existe', () async {
      final uc = UpdateActivityUseCase(
        activityRepository: InMemoryActivityRepository(),
        clock: FakeClock(DateTime.utc(2026)),
      );
      expect(
        () => uc.execute(id: ActivityId('x'), title: 'nuevo'),
        throwsA(isA<EntityNotFoundException>()),
      );
    });
  });

  group('GeneratePenaltyUseCase', () {
    test('selecciona una penitencia activa', () async {
      final repo = InMemoryPenaltyRepository();
      repo.store['p1'] = Penalty(
        id: PenaltyId('p1'),
        title: 'P1',
        description: '',
        severity: Severity.low,
        active: true,
      );
      final uc = GeneratePenaltyUseCase(
        penaltyRepository: repo,
        random: FakeRandom(),
      );
      final p = await uc.execute();
      expect(p.id, PenaltyId('p1'));
    });

    test('lanza si no hay penitencias activas', () async {
      final uc = GeneratePenaltyUseCase(
        penaltyRepository: InMemoryPenaltyRepository(),
        random: FakeRandom(),
      );
      expect(uc.execute, throwsA(isA<DomainInvariantException>()));
    });
  });

  group('CreatePenaltyUseCase', () {
    test('crea activa con id generado', () async {
      final repo = InMemoryPenaltyRepository();
      final uc = CreatePenaltyUseCase(
        penaltyRepository: repo,
        idGenerator: SeqIdGenerator(),
      );
      final p = await uc.execute(
        title: 'Lavar',
        description: 'platos',
        severity: Severity.medium,
      );
      expect(p.id, PenaltyId('id-1'));
      expect(p.active, isTrue);
      expect(repo.store.containsKey('id-1'), isTrue);
    });
  });
}
