import 'package:couplesync/domain/entities/availability.dart';
import 'package:couplesync/domain/exceptions/domain_exception.dart';
import 'package:couplesync/domain/value_objects/date_range.dart';
import 'package:couplesync/domain/value_objects/ids.dart';
import 'package:couplesync/domain/value_objects/time_slot.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Availability', () {
    test('rechaza días de semana inválidos', () {
      expect(
        () => Availability(
          userId: UserId('A'),
          availableWeekdays: const {0},
          slotsByWeekday: const {},
          blockedDates: const {},
          unavailablePeriods: const [],
        ),
        throwsA(isA<DomainValidationException>()),
      );
    });

    test('isDayAvailable respeta el día de la semana', () {
      // 2026-06-25 es jueves (weekday 4).
      final av = Availability(
        userId: UserId('A'),
        availableWeekdays: const {4},
        slotsByWeekday: const {
          4: [],
        },
        blockedDates: const {},
        unavailablePeriods: const [],
      );
      expect(av.isDayAvailable(DateTime.utc(2026, 6, 25)), isTrue); // jueves
      expect(av.isDayAvailable(DateTime.utc(2026, 6, 26)), isFalse); // viernes
    });

    test('isDayAvailable respeta fechas bloqueadas y periodos', () {
      final av = Availability(
        userId: UserId('A'),
        availableWeekdays: const {1, 2, 3, 4, 5, 6, 7},
        slotsByWeekday: const {},
        blockedDates: {DateTime.utc(2026, 6, 25)},
        unavailablePeriods: [
          DateRange(
            start: DateTime.utc(2026, 7, 1),
            end: DateTime.utc(2026, 7, 10),
          ),
        ],
      );
      expect(av.isDayAvailable(DateTime.utc(2026, 6, 25)), isFalse); // bloqueada
      expect(av.isDayAvailable(DateTime.utc(2026, 7, 5)), isFalse); // periodo
      expect(av.isDayAvailable(DateTime.utc(2026, 6, 24)), isTrue);
    });

    test('empty no tiene disponibilidad', () {
      final av = Availability.empty(UserId('B'));
      expect(av.isDayAvailable(DateTime.utc(2026, 6, 25)), isFalse);
      expect(av.slotsByWeekday, isEmpty);
      expect(TimeSlot(startMinutes: 0, endMinutes: 1).endMinutes, 1);
    });
  });
}
