import 'package:couplesync/domain/entities/activity.dart';
import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/entities/penalty.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/use_cases/activity_use_cases.dart';
import 'package:couplesync/domain/use_cases/availability_use_cases.dart';
import 'package:couplesync/domain/use_cases/penalty_use_cases.dart';
import 'package:couplesync/domain/value_objects/activity_category.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/severity.dart';
import 'package:flutter_test/flutter_test.dart';

import '_fakes.dart';

void main() {
  final userA = UserId('A');
  final clock = FakeClock(DateTime.utc(2026, 6, 21));

  Activity seedActivity(InMemoryActivityRepository r) {
    final a = Activity(
      id: ActivityId('a1'),
      title: 'Cena',
      description: 'd',
      category: ActivityCategory('Comida'),
      createdBy: userA,
      active: true,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );
    r.store['a1'] = a;
    return a;
  }

  Penalty seedPenalty(InMemoryPenaltyRepository r) {
    final p = Penalty(
      id: PenaltyId('p1'),
      title: 'Lavar',
      description: 'd',
      severity: Severity.low,
      active: true,
    );
    r.store['p1'] = p;
    return p;
  }

  group('Activity use cases', () {
    test('Update cambia campos y toca updatedAt', () async {
      final r = InMemoryActivityRepository();
      seedActivity(r);
      final updated = await UpdateActivityUseCase(
        activityRepository: r,
        clock: clock,
      ).execute(id: ActivityId('a1'), title: 'Nueva', clearImage: true);
      expect(updated.title, 'Nueva');
      expect(updated.updatedAt, clock.now());
    });

    test('SetActive desactiva', () async {
      final r = InMemoryActivityRepository();
      seedActivity(r);
      final updated = await SetActivityActiveUseCase(
        activityRepository: r,
        clock: clock,
      ).execute(id: ActivityId('a1'), active: false);
      expect(updated.active, isFalse);
    });

    test('SetActive lanza si no existe', () async {
      expect(
        () => SetActivityActiveUseCase(
          activityRepository: InMemoryActivityRepository(),
          clock: clock,
        ).execute(id: ActivityId('x'), active: false),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('Delete elimina', () async {
      final r = InMemoryActivityRepository();
      seedActivity(r);
      await DeleteActivityUseCase(
        activityRepository: r,
      ).execute(ActivityId('a1'));
      expect(r.store.containsKey('a1'), isFalse);
    });
  });

  group('Penalty use cases', () {
    test('Update cambia severidad', () async {
      final r = InMemoryPenaltyRepository();
      seedPenalty(r);
      final updated = await UpdatePenaltyUseCase(
        penaltyRepository: r,
      ).execute(id: PenaltyId('p1'), severity: Severity.high);
      expect(updated.severity, Severity.high);
    });

    test('Update lanza si no existe', () async {
      expect(
        () => UpdatePenaltyUseCase(
          penaltyRepository: InMemoryPenaltyRepository(),
        ).execute(id: PenaltyId('x'), title: 't'),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('SetActive desactiva', () async {
      final r = InMemoryPenaltyRepository();
      seedPenalty(r);
      final updated = await SetPenaltyActiveUseCase(
        penaltyRepository: r,
      ).execute(id: PenaltyId('p1'), active: false);
      expect(updated.active, isFalse);
    });

    test('SetActive lanza si no existe', () async {
      expect(
        () => SetPenaltyActiveUseCase(
          penaltyRepository: InMemoryPenaltyRepository(),
        ).execute(id: PenaltyId('x'), active: true),
        throwsA(isA<EntityNotFoundException>()),
      );
    });

    test('Delete elimina', () async {
      final r = InMemoryPenaltyRepository();
      seedPenalty(r);
      await DeletePenaltyUseCase(penaltyRepository: r).execute(PenaltyId('p1'));
      expect(r.store.containsKey('p1'), isFalse);
    });
  });

  group('Availability use cases', () {
    test('Set y Get persisten/recuperan', () async {
      final r = InMemoryAvailabilityRepository();
      final av = Availability(
        userId: userA,
        availableWeekdays: const {1, 2, 3},
        slotsByWeekday: const {},
        blockedDates: const {},
        unavailablePeriods: const [],
      );
      await SetAvailabilityUseCase(availabilityRepository: r).execute(av);
      final got = await GetAvailabilityUseCase(
        availabilityRepository: r,
      ).execute(userA);
      expect(got.availableWeekdays, {1, 2, 3});
    });

    test('Get devuelve vacía si no existe', () async {
      final got = await GetAvailabilityUseCase(
        availabilityRepository: InMemoryAvailabilityRepository(),
      ).execute(userA);
      expect(got.availableWeekdays, isEmpty);
    });
  });
}
